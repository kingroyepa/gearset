/**
 * AwardProcessSupporter contains methods that handle award validations and makes sure that no awards exceed cash amount
 * and time off limits.
 */

public class AwardProcessSupporter {
    public static Boolean hasBeenCalculated = false;

    public static void performAllAwardChecks(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        checkHoursRequirements(awards, oldAwardsByIds);
        checkSupervisorApproval(awards);
        checkIoaaApproval(awards);
        checkBudgetBalances(awards, oldAwardsByIds);
        checkValueApplicationAmount(awards);
    }

    /**
     * Before inserting an award nomination, check to see if the award will require supervisor approval.
     *
     * @param awards List of award nominations being created
     */
    @TestVisible
    private static void checkSupervisorApproval(List<Award__c> awards) {
        for (Award__c award : awards) {
            award.Requires_Supervisor_Approval__c = false;

            if (!AwardConstants.AWARD_RECORDTYPEID_TITLE42.equals(award.RecordTypeId)) {
                if ((award.Cash_Award_Amount__c > 2000 || award.STAA_Award_Amount__c > 2000) ||
                        (award.Time_Off_Amount__c != null && award.Time_Off_Amount__c > 10)) {
                    award.Requires_Supervisor_Approval__c = true;
                }
            }
        }
    }

    /**
     * Any individual awards that are greater than $2K or exceed $5K total or time off that equals more than 1
     * full workday requires IOAA approval and should be marked as such.
     *
     * @param awards Awards that are updated or inserted and need to be checked against previous awards or other in-
     * process awards
     */
    @TestVisible
    private static void checkIoaaApproval(List<Award__c> awards) {
        List<Id> employeeIds = new List<Id>();
        List<Id> awardIds = new List<Id>();
        Map<Id, Decimal> currentAwardValuesMap = new Map<Id, Decimal>();
        Map<Id, Decimal> previousEmployeeAwardsMap = new Map<Id, Decimal>();

        for (Award__c award : awards) {
            if (AwardConstants.AWARD_RECORDTYPEID_CASH.equals(award.RecordTypeId)) {
                employeeIds.add(award.Emp_Name__c);
                awardIds.add(award.Id);

                Decimal currentAwardValue = award.Cash_Award_Amount__c;
                if (currentAwardValuesMap.containsKey(award.Emp_Name__c)) {
                    Decimal existingValue = currentAwardValuesMap.get(award.Emp_Name__c);
                    currentAwardValuesMap.put(award.Emp_Name__c, currentAwardValue + existingValue);
                } else {
                    currentAwardValuesMap.put(award.Emp_Name__c, currentAwardValue);
                }
            }
        }

        if (!employeeIds.isEmpty() && !awardIds.isEmpty()) {
            previousEmployeeAwardsMap = getPreviousAwardAmounts(employeeIds, awardIds);

            for (Award__c award : awards) {
                award.Requires_IOAA_Approval__c = false;
                Decimal previousAwardsValues = 0;

                if (previousEmployeeAwardsMap.containsKey(award.Emp_Name__c)) {
                    previousAwardsValues = previousEmployeeAwardsMap.get(award.Emp_Name__c);
                }

                Decimal totalValue = previousAwardsValues + currentAwardValuesMap.get(award.Emp_Name__c);
                if (totalValue > 0) {
                    award.Total_Award_Amount_on_Submit__c = totalValue;
                }

                if (totalValue >= 5000) {
                    award.Requires_IOAA_Approval__c = true;
                    award.Requires_Supervisor_Approval__c = true;
                }
            }
        }
    }

    /**
     * Get the monetary values of all in-process or paid awards per employee. Though, we want to exclude the current awards
     * that have triggered this check in case we get an errant value. (The context is beforeUpdate, so querying the database
     * might retrieve a previous value of the award in the trigger and provide an incorrect calculation.)
     *
     * @param employeeIds Salesforce Ids for employees on awards applications
     *
     * @return A map of employee Salesforce Id and total amount of awards in process
     */
    @TestVisible
    private static Map<Id, Decimal> getPreviousAwardAmounts(List<Id> employeeIds, List<Id> awardIds) {
        Map<Id, Decimal> employeeAwardMap = new Map<Id, Decimal>();

        AggregateResult[] awardTotals = [
                SELECT Emp_Name__c, SUM(Cash_Award_Amount__c) cashAmount, SUM(STAA_Award_Amount__c) staaAmount,
                        SUM(Title_42_SL_ST_Award_Amount__c) title42Amount, SUM(OTS_Amount__c) otsAmount
                FROM Award__c
                WHERE Status__c NOT IN ('Planned','Rejected')
                AND Emp_Name__c IN :employeeIds
                AND Id NOT IN :awardIds
                AND Submitted_Date__c = THIS_FISCAL_YEAR
                AND (Cash_Award_Amount__c <> null OR STAA_Award_Amount__c <> null OR Title_42_SL_ST_Award_Amount__c <> null OR OTS_Amount__c <> null)
                AND Reference__c != TRUE
                GROUP BY Emp_Name__c
        ];

        if (!awardTotals.isEmpty()) {
            for (AggregateResult result : awardTotals) {
                System.debug('>>>> Pending result: ' + result);
                Decimal totalAwardValue = ((Decimal) result.get('cashAmount') == null ? 0 : (Decimal) result.get('cashAmount')) + ((Decimal) result.get('staaAmount') == null ? 0 : (Decimal) result.get('staaAmount')) + ((Decimal) result.get('title42Amount') == null ? 0 : (Decimal) result.get('title42Amount')) + ((Decimal) result.get('otsAmount') == null ? 0 : (Decimal) result.get('otsAmount'));
                employeeAwardMap.put((Id) result.get('Emp_Name__c'), totalAwardValue);
            }
        }

        return employeeAwardMap;
    }

    /**
     * Check the award amount versus the remaining budget to make sure the awards won't exceed the organization's budget. hasBeenCalculated boolean
     * is there to prevent double-calculations when a record is updated twice in a single transaction.
     *
     * @param awards List of new awards in trigger
     * @param oldAwardsByIds Map of old awards by Id in trigger
     */
    @TestVisible
    private static void checkBudgetBalances(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        System.debug('>>>> Current hasBeenCalculated value: ' + hasBeenCalculated);
        if (!hasBeenCalculated) {
            Map<Id, List<Award__c>> awardsByBudgetId = new Map<Id, List<Award__c>>();

            // Check to see if the award is associated with a budget
            // If no budget, then no check needs to be performed
            for (Award__c award : awards) {
                if (award.Budget__c != null && award.Cash_Award_Amount__c != 0 &&
                        // Here we want to make sure the run the calculation for awards that have previously not been accounted for in the budget
                        // So, we'll check to make sure the current status is one we want to use for calculations, but the previous status wasn't
                        AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC.contains(award.Status__c) &&
                        !AwardConstants.AWARD_STATUS_FOR_BUDGET_CALC.contains(oldAwardsByIds.get(award.Id).Status__c) &&
                        Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_CASH).getRecordTypeId().equals(award.RecordTypeId)) {
                    if (awardsByBudgetId.containsKey(award.Budget__c)) {
                        List<Award__c> awardList = awardsByBudgetId.get(award.Budget__c);
                        awardList.add(award);
                        awardsByBudgetId.put(award.Budget__c, awardList);
                    } else {
                        List<Award__c> awardList = new List<Award__c>{award};
                        awardsByBudgetId.put(award.Budget__c, awardList);
                    }
                }
            }

            if (!awardsByBudgetId.isEmpty()) {
                // Get the budget amounts from the budget Ids in awardsByBudgetId
                Map<Id, Document__c> budgetsById = getBudgetsById(awardsByBudgetId.keySet());

                // For each budget Id in awardsByBudgetId, sum the award amounts and compare to the budget amounts
                for (Id budgetId : awardsByBudgetId.keySet()) {
                    System.debug('>>>>> Budget total amount allocated: ' + budgetsById.get(budgetId).Award_Allocated_Amount__c);
                    System.debug('>>>>> Budget total amount remaining: ' + budgetsById.get(budgetId).Award_Remaining_Budget__c);
                    Decimal title42Totals = 0;
                    Decimal sAwardTotals = 0;
                    List<Award__c> awardList = awardsByBudgetId.get(budgetId);
                    for (Award__c award : awardList) {
                        title42Totals = title42Totals + award.Title_42_SL_ST_Award_Amount__c;
                        sAwardTotals = sAwardTotals + award.Cash_Award_Amount__c;
                        System.debug('>>>>> New award totals amounts: Title 42 total: ' + title42Totals + ', S Award Totals: ' + sAwardTotals);
                    }

                    if (budgetsById.containsKey(budgetId)) {
                        Document__c budget = budgetsById.get(budgetId);
                        // TODO - Need to create a field to track total title 42 amounts allocated to the budget.
                        if (sAwardTotals + budget.Award_Allocated_Amount__c > budget.Award_S_Award_Budget__c) {
                            Decimal totals = sAwardTotals + budget.Award_Allocated_Amount__c;
                            System.debug('>>>>> Award totals + allocated amount: ' + totals);
                            System.debug('>>>>> Total budget: ' + budget.Award_Total_Budget__c);
                            throw new AwardException('Award amounts exceed total Organization budget.');
                        }
                    }
                }
            }
        }

        System.debug('>>>>> Setting hasBeenCalculated to true.');
        hasBeenCalculated = true;
    }

    /**
     * Queries and returns a list of budgets during the current fiscal year when supplied a list of HR Org names.
     *
     * @param orgNames List of HR Org names for which you want budgets
     *
     * @return List of budget objects
     */
    public static List<Document__c> getBudgetsByOrganizationName(List<String> orgNames) {
        List<Document__c> budgets = [
                SELECT Id, Parent_Budget__c, Award_Allocated_Amount__c, Award_Total_Budget__c, Award_Remaining_Budget__c, Award_Budget_Org__r.Name
                FROM Document__c
                WHERE RecordType.Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
                AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                AND Award_Budget_Org__r.Name IN :orgNames
        ];

        return budgets;
    }

    /**
     * Queries and returns fields for a budget when supplied the budget's Id.
     *
     * @param budgetIds Ids for the budgets needing queried
     *
     * @return List of budget objects
     */
    public static Map<Id, Document__c> getBudgetsById(Set<Id> budgetIds) {
        Map<Id, Document__c> budgetsById = new Map<Id, Document__c>([
                SELECT Id, Parent_Budget__c, Award_Budget_Org__r.Name,
                        Award_Allocated_Amount__c, Award_Total_Budget__c, Award_Remaining_Budget__c,
                        Award_Title_42_SL_ST_Budget__c, Award_S_Award_Budget__c, Award_S_Award_Budget_Allocated__c, Award_Title_42_SL_ST_Budget_Allocated__c
                FROM Document__c
                WHERE Id IN :budgetIds
                AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                ORDER BY Award_Budget_Org__r.Name ASC
        ]);

        return budgetsById;
    }

    /**
     * Check to see if an employee will cross the 80 hour per year threshold. If so, prevent the award from being submitted.
     *
     * @param awards
     * @param oldAwardsByIds
     */
    @TestVisible
    private static void checkHoursRequirements(List<Award__c> awards, Map<Id, Award__c> oldAwardsByIds) {
        List<Award__c> awardsWithHours = new List<Award__c>();
        List<Id> employeeIds = new List<Id>();
        // Check if there are any hours allocated in the award.
        for (Award__c award : awards) {
            if (AwardConstants.AWARD_STATUS_SUBMITTED.equals(award.Status__c) && !AwardConstants.AWARD_STATUS_SUBMITTED.equals(oldAwardsByIds.get(award.Id).Status__c)
                    && award.Time_Off_Amount__c != null && !award.Outside_ORD__c && AwardConstants.AWARD_RECORDTYPEID_TIMEOFF.equals(award.RecordTypeId)) {
                awardsWithHours.add(award);
                employeeIds.add(award.Emp_Name__c);
            }
        }

        // Get the employee's hours awards for the calendar year.
        if (!awardsWithHours.isEmpty()) {
            List<Id> awardIds = new List<Id>();
            for (Award__c award : awardsWithHours) {
                awardIds.add(award.Id);
            }
            Map<Id, Decimal> employeeIdsWithTimeOff = getPreviousTimeOffAmounts(employeeIds, awardIds);

            // If the sum of hours is > 80, throw an error.
            for (Award__c award : awardsWithHours) {
                if (employeeIdsWithTimeOff.containsKey(award.Emp_Name__c)) {
                    Decimal totalTime = award.Time_Off_Amount__c + employeeIdsWithTimeOff.get(award.Emp_Name__c);
                    if (totalTime > 0) {
                        award.Total_Time_Off_on_Submit__c = totalTime;
                    }

                    if (totalTime > 80) {
                        award.addError('Employee will receive more than 80 hours of time off for this calendar year. ' +
                                'Please adjust the time off amount and submit again.');
                    }
                }
            }
        }
    }

    /**
     * Get all previous time off award amounts for a given employee during the calendar year.
     *
     * @param employeeIds Salesforce Ids of the employees you are checking
     * @param awardIds List of award Ids not needed as part of the check
     *
     * @return a Map of the employee Id and sum of hours in previous awards
     */
    @TestVisible
    private static Map<Id, Decimal> getPreviousTimeOffAmounts(List<Id> employeeIds, List<Id> awardIds) {
        Map<Id, Decimal> employeeHoursMap = new Map<Id, Decimal>();

        List<AggregateResult> results = [
                SELECT Emp_Name__c, SUM(Time_Off_Amount__c) timeOffSum
                FROM Award__c
                WHERE Submitted_Date__c = THIS_YEAR
                AND Status__c NOT IN ('Planned','Rejected')
                AND Emp_Name__c IN :employeeIds
                AND Id NOT IN :awardIds
                AND Time_Off_Amount__c != NULL
                GROUP BY Emp_Name__c
        ];

        if (!results.isEmpty()) {
            for (AggregateResult result : results) {
                employeeHoursMap.put((Id) result.get('Emp_Name__c'), (Decimal) result.get('timeOffSum'));
            }
        }

        return employeeHoursMap;
    }

    /**
     * Each user has an associated contact record that carries with it information that is needed for the application
     * to perform properly. This method gets those contacts and returns a map with User Id for easy retrieval.
     *
     * @param userIds List of user Ids for which you want contacts
     *
     * @return Map of User Id and Contact objects
     */
    public static Map<Id, Contact> getContactsByUserId(List<Id> userIds) {
        Map<Id, Contact> contactsByUserIds = new Map<Id, Contact>();

        List<Contact> contacts = [
                SELECT Id, User__c, Supervisor__c, AccountId, Detail_Org__c
                FROM Contact
                WHERE User__c IN :userIds
        ];

        for (Contact contact : contacts) {
            contactsByUserIds.put(contact.User__c, contact);
        }

        return contactsByUserIds;
    }

    /**
     * Retrieves contacts with supervisors and detail org info.
     *
     * @param userIds List of user Ids for which you want contacts
     *
     * @return Map of User Id and Contact objects
     */
    public static Map<Id, Contact> getContactsById(List<Id> contactIds) {
        Map<Id, Contact> contactsByUserIds = new Map<Id, Contact>();

        List<Contact> contacts = [
                SELECT Id, User__c, User__r.DelegatedApproverId, Supervisor__c, AccountId, Detail_Org__c
                FROM Contact
                WHERE Id IN :contactIds
        ];

        for (Contact contact : contacts) {
            contactsByUserIds.put(contact.Id, contact);
        }

        return contactsByUserIds;
    }

    /**
     * Check an award to make sure that it both has a budget and proper justification. If not, then throw an error on the
     * offending award.
     *
     * @param awards
     */
    public static void submissionChecks(List<Award__c> awards, Id userId) {
        Map<Id, Contact> userContactsByIds = getContactsByUserId(new List<Id>{ userId });
        List<Id> requestingOfficialIds = new List<Id>();
        for (Award__c award : awards) {
            if (String.isNotBlank(award.Requesting_Official__c)) {
                requestingOfficialIds.add(award.Requesting_Official__c);
            }
        }

        Map<Id, Contact> requestingOfficialInfoById = getContactsById(requestingOfficialIds);

        for (Award__c award : awards) {
            // Only apply justification and V&A checks on cash awards.
            if (AwardConstants.AWARD_RECORDTYPE_CASH.equals(Schema.SObjectType.Award__c.getRecordTypeInfosById().get(award.RecordTypeId).getName())) {
                // First check that the justification is properly filled out and the award has a V&A value.
            	if (award.Supervisor_Justification__c == null || award.Value_and_Application__c  == null) {
                	throw new AwardException('A submitted cash award must have the Value and Application ' +
                        	'and Supervisor Justification fields filled out. Please check those fields for completion ' +
                        	'and try saving/submitting again.');
           	 	}

                // Next, check to make sure that there is a budget associated with the award.
                if (award.Budget__c == null) {
                    throw new AwardException('An award cannot be submitted if it is not associated with a budget. Please associate ' +
                            'the award with a budget and try to submit again.');
                }
            }

            System.debug('>>>>> User Id: ' + userId);
            System.debug('>>>>> Requesting official Id: ' + award.Requesting_Official__c);
            System.debug('>>>>> Requesting official\'s delegated approver: ' + requestingOfficialInfoById.get(award.Requesting_Official__c).User__r.DelegatedApproverId);
            if (!userContactsByIds.containsKey(userId) || (award.Requesting_Official__c != userContactsByIds.get(userId).Id && userId != requestingOfficialInfoById.get(award.Requesting_Official__c).User__r.DelegatedApproverId)) {
                throw new AwardException('Only the requesting official or official delegate are allowed to submit awards. Please notify the ' +
                        'requesting official to submit this award.');
            }
        }
    }

    /**
     * HRD requested that e-mails with the PDF justification forms be sent to a shared inbox whenever an award is ready for SSC processing.
     * This method assembles the documents and asynchronously sends the e-mail to the address in a specified custom metadata field.
     *
     * @param awardIds Ids for awards that are ready for SSC processing.
     */
    @Future(callout=true)
    public static void sendPdfEmails(List<Id> awardIds) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Map<Id, Award__c> awardInfoForEmail = getAwardInfoForEmail(awardIds);

        for (Id awardId : awardIds) {
            Awards_HRD_Recipients__mdt recipient = [SELECT Id, Email_Address__c FROM Awards_HRD_Recipients__mdt WHERE Office_Name__c = 'ORD-HRD' LIMIT 1];

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setPlainTextBody(String.format('{0}\n{1}\n{2}\n{3}\n{4}\n{5}', new List<String>{
                    'Requesting Official Org: ' + awardInfoForEmail.get(awardId).RO_HR_Org2__r.Name,
                    'Awardee: ' + awardInfoForEmail.get(awardId).Emp_Name__r.Name,
                    'Awardee Org: ' + awardInfoForEmail.get(awardId).Emp_Name__r.Account.Name,
                    'Time: ' + awardInfoForEmail.get(awardId).Time_Off_Amount__c,
                    'Amount: ' + awardInfoForEmail.get(awardId).Cash_Award_Amount__c,
                    'Award Id: ' + awardInfoForEmail.get(awardId).Name
            }));
            email.setSubject(awardInfoForEmail.get(awardId).RO_HR_Org2__r.Name + ', ' + awardInfoForEmail.get(awardId).Emp_Name__r.Name);
            email.setWhatId(awardId);
            email.setSaveAsActivity(false);
            email.setToAddresses(new List<String> {recipient.Email_Address__c});

            PageReference singlePagePdf = Page.AwardSinglePageForm;
            singlePagePdf.getParameters().put('Id', awardId);
            Blob singlePagePdfBlob = Test.isRunningTest() ? Blob.valueOf('PDF Content') : singlePagePdf.getContent();

            PageReference doublePagePdf = Page.AwardDoublePageForm;
            doublePagePdf.getParameters().put('Id', awardId);
            Blob doublePagePdfBlob = Test.isRunningTest() ? Blob.valueOf('PDF Content') : doublePagePdf.getContent();

            Messaging.EmailFileAttachment singlePageAttachment = new Messaging.EmailFileAttachment();
            singlePageAttachment.setFileName(awardInfoForEmail.get(awardId).Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_SinglePagePDF.pdf');
            singlePageAttachment.body = singlePagePdfBlob;

            Messaging.EmailFileAttachment doublePageAttachment = new Messaging.EmailFileAttachment();
            doublePageAttachment.setFileName(awardInfoForEmail.get(awardId).Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_DoublePagePDF.pdf');
            doublePageAttachment.body = doublePagePdfBlob;

            email.setFileAttachments(new List<Messaging.EmailFileAttachment>{singlePageAttachment, doublePageAttachment});
            emails.add(email);
        }

        if (emails.size() > 0) {
            try {
                Messaging.sendEmail(emails);
            } catch (Exception e) {
                System.debug('Email message failed with following message: ' + e.getMessage());
            }
        }
    }

    /**
     * Helper method to get information related to the award for sending the HRD email.
     *
     * @param awardIds Awards Ids for which to get related info.
     *
     * @return Map of award Id and the award object.
     */
    private static Map<Id, Award__c> getAwardInfoForEmail(List<Id> awardIds) {
        Map<Id, Award__c> awardInfoMap;

        if (awardIds.size() > 0) {
            awardInfoMap = new Map<Id, Award__c>([SELECT Id, Emp_Name__r.Account.Name, Time_Off_Amount__c, Cash_Award_Amount__c, RO_HR_Org2__r.Name, Emp_Name__r.Name, Name FROM Award__c WHERE Id IN :awardIds]);
        }

        return awardInfoMap;
    }

    /**
     * An award's amount must be between the minimum and maximum values based on the Awards Value and Application selection. This method
     * gets the max and min values from custom metadata and makes sure the value is between the values and throws an error if not.
     *
     * @param awards
     */
    private static void checkValueApplicationAmount(List<Award__c> awards) {
        // Get the values from the custom metadata
        List<ARTT_Value_and_Application_Settings__mdt> arttSettings = [
                SELECT Picklist_Value__c, Minimum_Amount__c, Maximum_Amount__c
                FROM ARTT_Value_and_Application_Settings__mdt
        ];

        // Create a map using the metadata custom picklist value field
        Map<String, ARTT_Value_and_Application_Settings__mdt> arttSettingsMap = new Map<String, ARTT_Value_and_Application_Settings__mdt>();
        for (ARTT_Value_and_Application_Settings__mdt setting : arttSettings) {
            arttSettingsMap.put(setting.Picklist_Value__c, setting);
        }

        // Check to see that the a picklist value is chosen
        for (Award__c award : awards) {
            if (String.isNotEmpty(award.Value_and_Application__c) &&
                    arttSettingsMap.containsKey(award.Value_and_Application__c) &&
                    award.Cash_Award_Amount__c != null &&
                    (AwardConstants.AWARD_RECORDTYPEID_CASH.equals(award.RecordTypeId) || AwardConstants.AWARD_RECORDTYPEID_OTS.equals(award.RecordTypeId))) {
                // For the picklist value, get the minimum and maximum from the map
                // Validate the award amount is between the min and max
                Decimal awardAmount = AwardConstants.AWARD_RECORDTYPEID_CASH.equals(award.RecordTypeId) ? award.Cash_Award_Amount__c : award.OTS_Amount__c;
                System.debug('Cash value of the award: ' + awardAmount);
                System.debug('Minimum allowable value: ' + arttSettingsMap.get(award.Value_and_Application__c).Minimum_Amount__c);
                System.debug('Maximum allowable value: ' + arttSettingsMap.get(award.Value_and_Application__c).Maximum_Amount__c);
                if (awardAmount < (Decimal) arttSettingsMap.get(award.Value_and_Application__c).Minimum_Amount__c ||
                        awardAmount > (Decimal) arttSettingsMap.get(award.Value_and_Application__c).Maximum_Amount__c) {
                    // Add error to award if not valid
                    throw new AwardException('A cash award with a value and application value must fall between the minimum and maximum allowed values. The current ' +
                            'award amount is: ' + awardAmount + ', and the Minimum and Maximum amounts allowed are: ' + (Decimal) arttSettingsMap.get(award.Value_and_Application__c).Minimum_Amount__c +
                            'and ' + (Decimal) arttSettingsMap.get(award.Value_and_Application__c).Maximum_Amount__c + '. Please update the award and save again.');
                }
            }
        }
    }

    /**
     * This method automatically rejects approval requests that are awaiting approval. The method is primarily used when an award
     * is sent back to the requesting official by the HRD analyst.
     *
     * @param approvalRequests list of approval requests currently waiting approval
     * @param rejectReason message displayed on the approval request as the reason for the rejection
     */
    @InvocableMethod
    public static void rejectAwardApprovals(List<Id> awardIds) {
        // Get any approvals related to the supplied award Ids
        List<ProcessInstanceWorkitem> approvalRequests = [
                SELECT Id
                FROM ProcessInstanceWorkitem
                WHERE ProcessInstance.TargetObjectId IN :awardIds
        ];

        // If there are approvals
        if (!approvalRequests.isEmpty()) {
            List<Approval.ProcessWorkitemRequest> rejectionRequests = new List<Approval.ProcessWorkitemRequest>();
            // For each approval request, create a new work item request and add it to the list
            for (ProcessInstanceWorkitem workitem : approvalRequests) {
                Approval.ProcessWorkitemRequest request = new Approval.ProcessWorkitemRequest();
                request.setWorkitemId(workitem.Id);
                request.setComments('This award has been sent back to the requesting official.');
                request.setAction('Reject');

                rejectionRequests.add(request);
            }

            // Process the work items with the rejected status
            List<Approval.ProcessResult> rejectionResults = Approval.process(rejectionRequests);
        }
    }

    /**
     * Awards need to be ranked in order of when they were received by HR for HR review. However, in an effort to not cause
     * recursion, we'll do this ranking in the future based on the awards that are being updated now.
     *
     * @param awardIds List of awards that have been updated and called from process builder process
     */
    // TODO - Rank awards. Cannot be an invocable method because one already exists in this class.
    @Future(callout=false)
    public static void rankAwardsFuture(List<Id> awardIds) {
        Map<Id, List<Award__c>> cashAwardsByContactId = new Map<Id, List<Award__c>>();
        Map<Id, List<Award__c>> toAwardsByContactId = new Map<Id, List<Award__c>>();
        List<Award__c> awardsToUpdate = new List<Award__c>();
        Set<Id> employeeIdSet = new Set<Id>();

        // First get a list of all employees from the awards that need to be ranked
        List<Award__c> awardEmployeeList = new List<Award__c>([SELECT Id, Emp_Name__c FROM Award__c WHERE Id IN :awardIds]);

        // Put the employee Ids into a set
        for (Award__c award : awardEmployeeList) {
            employeeIdSet.add(award.Emp_Name__c);
        }

        // Query all cash awards ready for bulk upload awards where the employee Id is in the employee Id set.
        List<Award__c> bulkCashAwards = [
                SELECT Id, Emp_Name__c, Date_Ready_for_FPPS__c
                FROM Award__c
                WHERE RecordTypeId = :AwardConstants.AWARD_RECORDTYPEID_CASH
                AND Emp_Name__c IN :employeeIdSet
                AND Status__c IN (:AwardConstants.AWARD_STATUS_READY_FPPS, :AwardConstants.AWARD_STATUS_READY_BULK_UPLOAD, :AwardConstants.AWARD_STATUS_BULK_UPLOADED, :AwardConstants.AWARD_STATUS_PAID)
                AND Group_Award_Name__c = null
                AND Date_Ready_for_FPPS__c = THIS_FISCAL_YEAR
                ORDER BY Emp_Name__c ASC, Date_Ready_for_FPPS__c ASC
        ];

        List<Award__c> bulkTimeOffAwards = [
                SELECT Id, Emp_Name__c, Date_Ready_for_FPPS__c
                FROM Award__c
                WHERE RecordTypeId = :AwardConstants.AWARD_RECORDTYPEID_TIMEOFF
                AND Emp_Name__c IN :employeeIdSet
                AND Status__c IN (:AwardConstants.AWARD_STATUS_READY_FPPS, :AwardConstants.AWARD_STATUS_READY_BULK_UPLOAD, :AwardConstants.AWARD_STATUS_BULK_UPLOADED, :AwardConstants.AWARD_STATUS_PAID)
                AND Group_Award_Name__c = null
                AND Date_Ready_for_FPPS__c = THIS_YEAR
                ORDER BY Emp_Name__c ASC, Date_Ready_for_FPPS__c ASC
        ];

        // If no bulk awards, do nothing
        if (!bulkCashAwards.isEmpty()) {
            for (Award__c award : bulkCashAwards) {
                // Create a map of id to award list for each award returned.
                if (!cashAwardsByContactId.containsKey(award.Emp_Name__c)) {
                    cashAwardsByContactId.put(award.Emp_Name__c, new List<Award__c>{award});
                } else {
                    List<Award__c> awardList = cashAwardsByContactId.get(award.Emp_Name__c);
                    awardList.add(award);
                    cashAwardsByContactId.put(award.Emp_Name__c, awardList);
                }
            }

            // Loop through the map and rank the awards that were returned in order and then update them.
            for (Id contactId : cashAwardsByContactId.keySet()) {
                List<Award__c> rankedAwards = cashAwardsByContactId.get(contactId);

                for (Integer i=0; i<rankedAwards.size(); i++) {
                    Award__c award = rankedAwards[i];
                    award.Cash_Award_Counter__c = i + 1;
                }

                awardsToUpdate.addAll(rankedAwards);
            }
        }

        if (!bulkTimeOffAwards.isEmpty()) {
            for (Award__c toAward : bulkTimeOffAwards) {
                if (!toAwardsByContactId.containsKey(toAward.Emp_Name__c)) {
                    toAwardsByContactId.put(toAward.Emp_Name__c, new List<Award__c>{toAward});
                } else {
                    List<Award__c> toAwardList = toAwardsByContactId.get(toAward.Emp_Name__c);
                    toAwardList.add(toAward);
                    toAwardsByContactId.put(toAward.Emp_Name__c, toAwardList);
                }
            }

            for (Id contactId : toAwardsByContactId.keySet()) {
                List<Award__c> rankedToAwards = toAwardsByContactId.get(contactId);

                for (Integer i=0; i<rankedToAwards.size(); i++) {
                    Award__c toAward = rankedToAwards[i];
                    toAward.TO_Award_Counter__c = i + 1;
                }

                awardsToUpdate.addAll(rankedToAwards);
            }
        }

        update awardsToUpdate;
    }
}