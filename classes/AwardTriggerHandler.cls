public class AwardTriggerHandler {

    public static void beforeInsert(List<Award__c> beforeInsertList) {
        setDivisionAndBranch(beforeInsertList);
        setOwnersContactAndApprovers(beforeInsertList);
        setBudgetOnAward(beforeInsertList);
    }

    public static void afterInsert(Map<Id, Award__c> afterUpdateMap) {
        shareWithSupervisorsAndApprovers(afterUpdateMap.values(), null);
    }

    public static void beforeUpdate(Map<Id, Award__c> beforeUpdateMap, Map<Id, Award__c> oldAwardsByIds) {
        doAwardChecks(beforeUpdateMap.values(), oldAwardsByIds);
        resetAwardingOrgInfo(beforeUpdateMap.values(), oldAwardsByIds);
    }

    public static void afterUpdate(Map<Id, Award__c> afterUpdateMap, Map<Id, Award__c> oldValuesMap) {
        updateBudgets(afterUpdateMap.values());
        shareWithSupervisorsAndApprovers(afterUpdateMap.values(), oldValuesMap);
        submitForDirectSupervisorApproval(afterUpdateMap.values(), oldValuesMap);
        sendHrdPdfs(afterUpdateMap.values(), oldValuesMap);
        getRankableAwards(afterUpdateMap.values(), oldValuesMap);
    }

    /**
     * Filter the awards that need to be checked for business processes.
     *
     * Updated to include only ARTT awards based on Record Type.
     *
     * @param awardUpdateList List of updated awards
     */
    private static void doAwardChecks(List<Award__c> awardUpdateList, Map<Id, Award__c> oldAwardsByIds) {
        // List and map data structures to contain only ARTT awards for checking
        List<Award__c> awardsToCheckList = new List<Award__c>();
        Map<Id, Award__c> oldAwardsToCheckMap = new Map<Id, Award__c>();

        for (Award__c award : awardUpdateList) {
            if (AwardConstants.AWARD_RECORD_TYPES.contains(Schema.SObjectType.Award__c.getRecordTypeInfosById().get(award.RecordTypeId).getName())) {
                awardsToCheckList.add(award);

                // Check to make sure the award is in the old map; could be a new record - don't want to throw an error
                if (oldAwardsByIds.containsKey(award.Id)) {
                    oldAwardsToCheckMap.put(award.Id, oldAwardsByIds.get(award.Id));
                }
            }
        }

        // Send only ARTT awards for checking
        AwardProcessSupporter.performAllAwardChecks(awardsToCheckList, oldAwardsToCheckMap);
    }

    /**
     * Use the contact's Organization name to derive the division and branch. Then add the information to the Division and
     * branch fields on the award.
     *
     * @param awards List of awards that are being inserted.
     */
    @TestVisible
    private static void setDivisionAndBranch(List<Award__c> awards) {
        List<Id> awardeeIds = new List<Id>();
        for (Award__c award : awards) {
            awardeeIds.add(award.Emp_Name__c);
        }

        Map<Id, Contact> awardeeIdWithContact = new Map<Id, Contact>([SELECT Id, Account.Name FROM Contact WHERE Id IN :awardeeIds]);

        for (Award__c award : awards) {
            Contact awardee = awardeeIdWithContact.get(award.Emp_Name__c);
            String fullOrgName = awardee.Account.Name;
            List<String> orgNameParts = fullOrgName.split('-');

            if (!orgNameParts[0].equals('ORD')) {
                award.Outside_ORD__c = TRUE;
            }

            if (orgNameParts.size() == 4) {
                award.Branch__c = orgNameParts[3];
                award.Division__c = orgNameParts[2];
                award.LCO__c = orgNameParts[1];
            } else if (orgNameParts.size() == 3) {
                award.Division__c = orgNameParts[2];
                award.LCO__c = orgNameParts[1];
            } else if (orgNameParts.size() == 2) {
                award.LCO__c = orgNameParts[1];
            }
        }
    }

    /**
     * For each award, set the associated budget based on the organization associated with the requesting official.
     * Right now, this method assumes that the budgets for each org already exist.
     *
     * @param awards List of awards getting inserted.
     */
    @TestVisible
    private static void setBudgetOnAward(List<Award__c> awards) {
        Map<String, Document__c> budgetsByDepartment = new Map<String, Document__c>();
        Set<Id> requestingOfficialIds = new Set<Id>();

        Map<Id, String> orgNamesByRequestingOfficialIds = new Map<Id, String>();

        // Add requesting official Ids to a list to later get their HR Orgs
        for (Award__c award : awards) {
            if (award.Requesting_Official__c != null) {
                requestingOfficialIds.add(award.Requesting_Official__c);
            }
        }

        // Get the HR Org and/or Detail Org for each requesting official
        Contact[] requestingOfficialContact = [
                SELECT Id, Account.Name, Detail_Org__r.Name
                FROM Contact
                WHERE Id IN :requestingOfficialIds
        ];

        // For each requesting official, put into a map the requesting official Id and either their HR Org or Detail Org
        // This will be used to get the associated budget for the award
        for (Contact contact : requestingOfficialContact) {
            // If the supervisor is on detail, then use the Detail Org instead of the Organization they belong to
            orgNamesByRequestingOfficialIds.put(contact.Id, contact.Detail_Org__r.Name == null ? contact.Account.Name : contact.Detail_Org__r.Name);
        }

        // Get all budgets based on the values put into the map for each requesting official
        List<Document__c> budgets = AwardProcessSupporter.getBudgetsByOrganizationName(orgNamesByRequestingOfficialIds.values());
        for (Document__c budget : budgets) {
            budgetsByDepartment.put(budget.Award_Budget_Org__r.Name, budget);
        }

        for (Award__c award : awards) {
            String hrOrgName = orgNamesByRequestingOfficialIds.get(award.Requesting_Official__c);
            if (budgetsByDepartment.containsKey(hrOrgName)) {
                Award.Budget__c = budgetsByDepartment.get(hrOrgName).Id;
            }
        }
    }

    /**
     * Update the allocated budget amount after an an award has been updated.
     *
     * @param awards List of updated awards.
     */
    @TestVisible
    private static void updateBudgets(List<Award__c> awards) {
        Set<Id> budgetIds = new Set<Id>();

        // If award status != Planned, add the award to an update list
        for (Award__c award : awards) {
            if (award.Budget__c != null && !award.Reference__c) {
                budgetIds.add(award.Budget__c);
            }
        }

        // Get the associated budget from each award, if one exists
        if (!budgetIds.isEmpty()) {
            List<Document__c> budgetsToUpdate = new List<Document__c>();
            List<Document__c> qsiBudgetsToUpdate = new List<Document__c>();

            List<AggregateResult> budgetAllocations = [
                    SELECT Budget__c, SUM(Cash_Award_Amount__c) cashAmount, SUM(Title_42_SL_ST_Award_Amount__c) title42Amount
                    FROM Award__c
                    WHERE Budget__c IN :budgetIds
                    AND Status__c IN :AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC
                    AND Incoming_Award__c = false
                    AND Reference__c != true
                    GROUP BY Budget__c
            ];

            // Need a separate query to get the count of QSI awards per budget
            List<AggregateResult> qsiAllocations = [
                    SELECT Budget__c, Count(Id) qsiCount
                    FROM Award__c
                    WHERE Budget__c IN :budgetIds
                    AND Status__c IN :AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC
                    AND RecordTypeId = :AwardConstants.AWARD_RECORDTYPEID_QSI
                    AND Reference__c != true
                    GROUP BY Budget__c
            ];

            for (AggregateResult result : budgetAllocations) {
                Document__c budget = new Document__c();
                Decimal cashAmount = (Decimal) result.get('cashAmount') == null ? 0 : (Decimal) result.get('cashAmount');
                Decimal title42Amount = (Decimal) result.get('title42Amount') == null ? 0 : (Decimal) result.get('title42Amount');
                budget.Id = (Id) result.get('Budget__c');
                budget.Award_Allocated_Amount__c = cashAmount + title42Amount;
                budget.Award_Title_42_SL_ST_Budget_Allocated__c = title42Amount;
                budget.Award_S_Award_Budget_Allocated__c = cashAmount;

                budgetsToUpdate.add(budget);
            }

            for (AggregateResult qsiResult : qsiAllocations) {
                Document__c budget = new Document__c();
                Decimal qsiAllocationAmounts = (Decimal) qsiResult.get('qsiCount') == null ? 0 : (Decimal) qsiResult.get('qsiCount');
                budget.Id = (Id) qsiResult.get('Budget__c');
                budget.Award_QSI_Budget_Allocated__c = qsiAllocationAmounts;
                qsiBudgetsToUpdate.add(budget);
            }

            if (!budgetsToUpdate.isEmpty()) {
                update budgetsToUpdate;
                update qsiBudgetsToUpdate;
            }
        }
    }

    /**
     * Set the owner's contact record in the <code>Owner_Contact__c</code> field. This is necessary for the approval
     * process and using other formula fields on the award.
     *
     * @param awards List of awards to be inserted.
     */
    @TestVisible
    private static void setOwnersContactAndApprovers(List<Award__c> awards) {
        List<Id> awardeeIds = new List<Id>();
        List<Id> requestingOfficialIds = new List<Id>();
        for (Award__c award : awards) {
            awardeeIds.add(award.Emp_Name__c);
            requestingOfficialIds.add(award.Requesting_Official__c);
        }

        // The IOAA approver is set for all of ORD and is stored as custom metadata for easy management
        Awards_IOAA_Approver__mdt ioaaApprover = [SELECT IOAA_Approver_Id__c FROM Awards_IOAA_Approver__mdt WHERE Department__c = 'ORD'];

        Map<Id, Contact> contactsById = AwardProcessSupporter.getContactsById(requestingOfficialIds);
        Map<Id, Contact> awardeesById = new Map<Id, Contact>([SELECT Id, Supervisor__c FROM Contact WHERE Id IN :awardeeIds]);

        for (Award__c award : awards) {
            if (contactsById.containsKey(award.Requesting_Official__c)) {
                award.RO_HR_Org2__c = contactsById.get(award.Requesting_Official__c).Detail_Org__c == null ? contactsById.get(award.Requesting_Official__c).AccountId : contactsById.get(award.Requesting_Official__c).Detail_Org__c;
                award.Authorizing_Official__c = contactsById.get(award.Requesting_Official__c).Supervisor__c;
                award.Awardee_Direct_Supervisor__c = awardeesById.get(award.Emp_Name__c).Supervisor__c;
                award.IOAA_Approver__c = (Id) ioaaApprover.IOAA_Approver_Id__c;
            }
        }
    }

    /**
     * Share records with a User's supervisor and other approvers so that they can access the award when they receive
     * an approval request.
     *
     * @param awards Awards to be shared with supervisors and approvers
     * @param oldAwardsByIds Old award values by Id
     */
    @TestVisible
    private static void shareWithSupervisorsAndApprovers(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Award__c> submittedAwardsToShare = new List<Award__c>();
        List<Award__c> createdAwardsToShare = new List<Award__c>();
        List<Id> awardeeIds = new List<Id>();
        List<Id> ownerIds = new List<Id>();
        List<Id> requestingOfficials = new List<Id>();
        Map<Id, Id> supervisorByAwardeeIds = new Map<Id, Id>();
        Map<Id, Contact> contactByOwnerId = new Map<Id, Contact>();
        Map<Id, Contact> contactsByContactIdWithUser = new Map<Id, Contact>();
        Map<Id, List<Award__c>> awardsByUserId = new Map<Id, List<Award__c>>();

        // Lists of Award share records to insert
        List<Award__Share> awardShares = new List<Award__Share>();
        Award__Share supervisorShare;
        Award__Share ioaaApproverShare;
        Award__Share awardeeSupervisorShare;
        Award__Share requestingOfficialShare;
        Award__Share delegatedApproverShare;

        // First, share the record with the Supervisor's supervisor
        // Second, share the record with the IOAA supervisor
        // Third, share the record with the awardee's supervisor, if supervisor is different than award owner
        for (Award__c award : awards) {
            if (AwardConstants.AWARD_STATUS_SUBMITTED.equals(award.Status__c) &&
                    !AwardConstants.AWARD_STATUS_SUBMITTED.equals(oldAwardsByIds.get(award.Id).Status__c)) {
                System.debug('>>>> Employee supervisor Id: ' + award.Emp_Name__r.Supervisor__c);
                submittedAwardsToShare.add(award);
                awardeeIds.add(award.Emp_Name__c);
            }

            // New records are identified because there is no record in the old map or the old map is empty
            // Need to share with requesting official whenever a record is created or when an owner changes
            if (!String.isEmpty(award.Requesting_Official__c)
//                    ((oldAwardsByIds != null && oldAwardsByIds.containsKey(award.Id) && award.Requesting_Official__c != oldAwardsByIds.get(award.Id).Requesting_Official__c) ||
//                            (oldAwardsByIds != null && oldAwardsByIds.containsKey(award.Id) && award.OwnerId != oldAwardsByIds.get(award.Id).OwnerId) ||
//                            oldAwardsByIds == null)
                    ) {
                createdAwardsToShare.add(award);
                requestingOfficials.add(award.Requesting_Official__c);
                ownerIds.add(award.OwnerId);
            }
        }

        if (!awardeeIds.isEmpty()) {
            Contact[] awardeeSupervisor = [SELECT Id, Supervisor__c FROM Contact WHERE Id IN :awardeeIds];
            for (Contact awardee : awardeeSupervisor) {
                supervisorByAwardeeIds.put(awardee.Id, awardee.Supervisor__c);
            }
        }

        if (!ownerIds.isEmpty()) {
            contactByOwnerId = AwardProcessSupporter.getContactsByUserId(ownerIds);
        }

        if (!requestingOfficials.isEmpty()) {
            contactsByContactIdWithUser = AwardProcessSupporter.getContactsById(requestingOfficials);
        }

        // Create all the share records and add to the share list
        // Trying to share the record with the owner will throw an error since you cannot insert a share that provides less access than the user already has.
        for (Award__c award : submittedAwardsToShare) {
            if (award.IOAA_Approver__c != null && award.IOAA_Approver__c != award.OwnerId) {
                ioaaApproverShare = new Award__Share();
                ioaaApproverShare.ParentId = award.Id;
                ioaaApproverShare.UserOrGroupId = award.IOAA_Approver__c;
                ioaaApproverShare.AccessLevel = 'read';
                awardShares.add(ioaaApproverShare);

                // For every user who is getting shared an award record, put that users Id in a map with the awards they're getting shared
                // This will be used to query for delegated approvers and making sure they get access to the record, as well
                if (awardsByUserId.containsKey(award.IOAA_Approver__c)) {
                    List<Award__c> ioaaAwardList = awardsByUserId.get(award.IOAA_Approver__c);
                    ioaaAwardList.add(award);
                    awardsByUserId.put(award.IOAA_Approver__c, ioaaAwardList);
                } else {
                    awardsByUserId.put(award.IOAA_Approver__c, new List<Award__c>{ award });
                }
            }

            if (award.Authorizing_Official__c != null && award.Authorizing_Official__c != award.OwnerId) {
                supervisorShare = new Award__Share();
                supervisorShare.ParentId = award.Id;
                supervisorShare.UserOrGroupId = award.Authorizing_Official__c;
                supervisorShare.AccessLevel = 'read';
                awardShares.add(supervisorShare);

                if (awardsByUserId.containsKey(award.Authorizing_Official__c)) {
                    List<Award__c> aoAwardList = awardsByUserId.get(award.Authorizing_Official__c);
                    aoAwardList.add(award);
                    awardsByUserId.put(award.Authorizing_Official__c, aoAwardList);
                } else {
                    awardsByUserId.put(award.Authorizing_Official__c, new List<Award__c>{ award });
                }
            }

            // Keeping this here for reference: supervisorByAwardeeIds.get(award.Emp_Name__c) != null && supervisorByAwardeeIds.get(award.Emp_Name__c) != award.OwnerId
            if (award.Awardee_Direct_Supervisor__c != null && award.Awardee_Direct_Supervisor__c != award.OwnerId && award.Awardee_Direct_Supervisor__c != contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c) {
                awardeeSupervisorShare = new Award__Share();
                awardeeSupervisorShare.ParentId = award.Id;
                awardeeSupervisorShare.UserOrGroupId = award.Awardee_Direct_Supervisor__c; // Old value: supervisorByAwardeeIds.get(award.Emp_Name__c);
                awardeeSupervisorShare.AccessLevel = 'read';
                awardShares.add(awardeeSupervisorShare);

                if (awardsByUserId.containsKey(award.Awardee_Direct_Supervisor__c)) { // Original logic:  awardsByUserId.containsKey(supervisorByAwardeeIds.get(award.Emp_Name__c))
                    List<Award__c> supervisorAwardList = awardsByUserId.get(award.Awardee_Direct_Supervisor__c);
                    supervisorAwardList.add(award);
                    awardsByUserId.put(award.Awardee_Direct_Supervisor__c, supervisorAwardList);
                } else {
                    awardsByUserId.put(award.Awardee_Direct_Supervisor__c, new List<Award__c>{ award });
                }
            }
        }

        for (Award__c award : createdAwardsToShare) {
            if (!String.isEmpty(award.Requesting_Official__c) && contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c != award.OwnerId) {
                requestingOfficialShare = new Award__Share();
                requestingOfficialShare.ParentId = award.Id;
                requestingOfficialShare.UserOrGroupId = contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c;
                requestingOfficialShare.AccessLevel = 'edit';
                awardShares.add(requestingOfficialShare);
            }

            if (awardsByUserId.containsKey(contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c)) {
                List<Award__c> roAwardList = awardsByUserId.get(contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c);
                roAwardList.add(award);
                awardsByUserId.put(contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c, roAwardList);
            } else {
                awardsByUserId.put(contactsByContactIdWithUser.get(award.Requesting_Official__c).User__c, new List<Award__c>{ award });
            }
        }

        Map<Id, User> usersByIds = new Map<Id, User>([SELECT Id, DelegatedApproverId FROM User WHERE Id IN :awardsByUserId.keySet()]);

        for (Id userId : usersByIds.keySet()) {
            // For each Id, get the associated awards and then create a share record for the delegated approver and add to awardShares
            if (String.isNotBlank(usersByIds.get(userId).DelegatedApproverId)) {
                List<Award__c> awardList = awardsByUserId.get(userId);
                for (Award__c award : awardList) {
                    if (usersByIds.get(userId).DelegatedApproverId != award.OwnerId) {
                        delegatedApproverShare = new Award__Share();
                        delegatedApproverShare.ParentId = award.Id;
                        delegatedApproverShare.UserOrGroupId = usersByIds.get(userId).DelegatedApproverId;
                        delegatedApproverShare.AccessLevel = 'read';
                        awardShares.add(delegatedApproverShare);
                    }
                }
            }
        }

        if (!awardShares.isEmpty()) {
            insert awardShares;
        }
    }

    /**
     * If the award's owner changes, reset the awarding org info on the award. To be used in a before context so no
     * need to call <code>update</code> specifically.
     *
     * @param awards List of updated awards.
     * @param oldAwardsByIds
     */
    private static void resetAwardingOrgInfo(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds){
        List<Award__c> awardsToUpdate = new List<Award__c>();
        List<Award__c> roOrgUpdates = new List<Award__c>();

        for (Award__c award : awards) {
            if (award.Requesting_Official__c != oldAwardsByIds.get(award.Id).Requesting_Official__c &&
                    AwardConstants.AWARD_RECORDTYPEID_SET.contains(award.RecordTypeId)) {
                awardsToUpdate.add(award);
            }

            if (award.Budget__c != oldAwardsByIds.get(award.Id).Budget__c && AwardConstants.AWARD_RECORDTYPEID_SET.contains(award.RecordTypeId)) {
                roOrgUpdates.add(award);
            }
        }

        if (!awardsToUpdate.isEmpty()) {
            setOwnersContactAndApprovers(awardsToUpdate);
            setDivisionAndBranch(awardsToUpdate);
            setBudgetOnAward(awardsToUpdate);
        }

        if (!roOrgUpdates.isEmpty()) {
             resetHrOrgOnBudgetChange(roOrgUpdates);
        }
    }

    /**
     * An award needs to be submitted to a direct supervisor if the requesting official and the awardee are employees of
     * ORD but do not belong to the same HR Org. Awards should only be submitted to the direct supervisor if the award
     * had already been approved either automatically or by the requesting official's supervisor and, if necessary, the
     * IOAA approver.
     *
     * @param awards List of awards that potentially need to be sent for direct supervisor approval.
     */
    @TestVisible
    private static void submitForDirectSupervisorApproval(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Award__c> directSuperApprovalAwards = new List<Award__c>();
        List<Id> employeeIds = new List<Id>();
        Map<Id, Id> supervisorsByEmployeeId = new Map<Id, Id>();

        for (Award__c award : awards) {
            // Want to make sure that the award status is newly changed to approved ... don't want to have an approval
            // process started up because of unnecessary changes to a submitted record.
            if (AwardConstants.AWARD_STATUS_HR_REVIEW.equals(award.Status__c) && award.Outside_Org__c &&
                    award.Status__c != oldAwardsByIds.get(award.Id).Status__c &&
                    !AwardConstants.AWARD_STATUS_PENDING_APPROVAL.equals(oldAwardsByIds.get(award.Id).Status__c) &&
                    !award.Outside_ORD__c &&
                    !AwardConstants.AWARD_RECORDTYPEID_TITLE42.equals(award.RecordTypeId)) {
                directSuperApprovalAwards.add(award);
                employeeIds.add(award.Emp_Name__c);
            }
        }

        if (!employeeIds.isEmpty()) {
            Contact[] employees = [SELECT Id, Supervisor__c FROM Contact WHERE Id IN :employeeIds];

            for (Contact employee : employees) {
                supervisorsByEmployeeId.put(employee.Id, employee.Supervisor__c);
            }
        }

        if (!directSuperApprovalAwards.isEmpty()) {
            Id userId = UserInfo.getUserId();

            for (Award__c award : directSuperApprovalAwards) {
                if (award.OwnerId != award.Awardee_Direct_Supervisor__c) {
                    Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
                    approvalReq.setSubmitterId(userId);
                    approvalReq.setProcessDefinitionNameOrId('Direct_Supervisor_Approval_Process');
                    approvalReq.setObjectId(award.Id);
                    approvalReq.setComments('Please review this award for approval.');

                    try {
                        Approval.ProcessResult result = Approval.process(approvalReq);
                        System.assert(result.isSuccess());
                    } catch (Exception e) {
                        System.debug('Error message: ' + e.getMessage());
                        award.addError('An error occurred submitting the award with the following message: ' + e.getMessage());
                    }
                }
            }
        }
    }

    /**
     * HRD requested that awards that are ready for entry into the SSC have their PDF justification forms sent to a shared
     * e-mail inbox. This method checks that the status is ready for SSC and that its previous value was not ready for SSC
     * and then sends the award to the future method for creating and sending the PDFs.
     *
     * @param awards Awards that have been updated.
     * @param oldAwardsById Awards by ID with old values.
     *
     * TODO - Need to determine what the new value should be when sending the PDFs to HRD.
     */
    @TestVisible
    private static void sendHrdPdfs(List<Award__c> awards, Map<Id, Award__c> oldAwardsById) {
        List<Id> readyForSSCAwards = new List<Id>();

        for (Award__c award : awards) {
            if (AwardConstants.AWARD_STATUS_READY_FOR_SSC.equals(award.Status__c) && !AwardConstants.AWARD_STATUS_READY_FOR_SSC.equals(oldAwardsById.get(award.Id).Status__c)) {
                readyForSSCAwards.add(award.Id);
            }
        }

        if (readyForSSCAwards.size() > 0) {
            AwardProcessSupporter.sendPdfEmails(readyForSSCAwards);
        }
    }

    @TestVisible
    private static void getRankableAwards(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Id> rankableAwardIds = new List<Id>();

        for (Award__c award : awards) {
            if ((AwardConstants.AWARD_STATUS_READY_FPPS.equals(award.Status__c) && !AwardConstants.AWARD_STATUS_READY_FPPS.equals(oldAwardsByIds.get(award.Id).Status__c)) ||
                    AwardConstants.AWARD_STATUS_READY_FPPS.equals(oldAwardsByIds.get(award.Id).Status__c) && AwardConstants.AWARD_STATUS_ENTERED_FPPS.equals(award.Status__c)) {
                rankableAwardIds.add(award.Id);
            }
        }

        if (!rankableAwardIds.isEmpty()) {
            AwardProcessSupporter.rankAwardsFuture(rankableAwardIds);
        }
    }

    @TestVisible
    private static void resetHrOrgOnBudgetChange(List<Award__c> awards) {
        Map<Id, Document__c> budgets;
        Set<Id> budgetIds = new Set<Id>();

        for (Award__c award : awards) {
            if (String.isNotBlank(award.Budget__c)) {
                budgetIds.add(award.Budget__c);
            }
        }

        budgets = AwardProcessSupporter.getBudgetsById(budgetIds);

        for (Award__c award : awards) {
            award.RO_HR_Org2__c = budgets.get(award.Budget__c).Award_Budget_Org__c;
        }
    }
}