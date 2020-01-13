/**
 * Server side controller methods for using ARTT lightning components
 */

public with sharing class ARTTAwardPlannerComponentController {
    @AuraEnabled
    public static List<Document__c> getBudgets() {
        List<Award__c> awards = getAwards();
        List<Document__c> budgets;
        Set<Id> budgetIds;

        if (!awards.isEmpty()) {
            budgetIds = new Set<Id>();
            for (Award__c award : awards) {
                if (!String.isBlank(award.Budget__c)) {
                    budgetIds.add(award.Budget__c);
                }
            }
        }

        if (!budgetIds.isEmpty()) {
            budgets = AwardProcessSupporter.getBudgetsById(budgetIds).values();
        }

        return budgets;
    }

    @AuraEnabled
    public static List<Award__c> getAwards() {
        List<Award__c> myAwards = [
                SELECT Id, Name, Emp_Name__r.Name, LCO__c, Division__c, Branch__c, Outside_LCO__c, Outside_ORD__c,
                        Cash_Award_Amount__c, Time_Off_Amount__c, Group_Award_Amount__c, Group_Award_Name__c,
                        Type_of_Benefit__c, Value_of_Benefit__c, Extent_of_Contribution__c, Supervisor_Justification__c,
                        Status__c, Pay_Period__c, OTS_Amount__c, Budget__c, RecordType.Name, Budget__r.Name, Budget__r.Award_Budget_Org__r.Name,
                        Value_and_Application__c, Requesting_Official__c, Authorizing_Official__c, Awardee_Direct_Supervisor__c, QSI__c
                FROM Award__c
                WHERE Status__c = :AwardConstants.AWARD_STATUS_PLANNED
                AND (Planned_Date__c = THIS_FISCAL_YEAR
                OR (RecordTypeId = :AwardConstants.AWARD_RECORDTYPEID_TIMEOFF
                AND Planned_Date__c = THIS_YEAR))
                AND (Requesting_Official__r.User__c = :UserInfo.getUserId() OR OwnerId = :UserInfo.getUserId())
                ORDER BY Emp_Name__r.LastName ASC
        ];

        return myAwards;
    }

    @AuraEnabled
    public static List<Award__c> getFilteredAwards(String budgetOrg) {
        List<Award__c> myAwards = [
                SELECT Id, Name, Emp_Name__r.Name, LCO__c, Division__c, Branch__c, Outside_LCO__c, Outside_ORD__c,
                        Cash_Award_Amount__c, Time_Off_Amount__c, Group_Award_Amount__c, Group_Award_Name__c,
                        Type_of_Benefit__c, Value_of_Benefit__c, Extent_of_Contribution__c, Supervisor_Justification__c,
                        Status__c, Pay_Period__c, OTS_Amount__c, Budget__c, RecordType.Name, Budget__r.Name, Budget__r.Award_Budget_Org__r.Name,
                        Value_and_Application__c, Requesting_Official__c, Authorizing_Official__c, Awardee_Direct_Supervisor__c, QSI__c
                FROM Award__c
                WHERE Status__c = :AwardConstants.AWARD_STATUS_PLANNED
                AND Budget__r.Award_Budget_Org__r.Name = :budgetOrg
                AND (Planned_Date__c = THIS_FISCAL_YEAR
                OR (RecordTypeId = :AwardConstants.AWARD_RECORDTYPEID_TIMEOFF
                AND Planned_Date__c = THIS_YEAR))
                ORDER BY Emp_Name__r.LastName ASC
        ];

        return myAwards;
    }

    @AuraEnabled
    public static void saveAwards(List<Award__c> awards){
        if (!awards.isEmpty()) {
            update awards;
        }
    }

    /**
     * Before submitting awards for approval, checks to make sure that the amounts of the awards do not exceed the
     * budget and then submits the awards for approval.
     *
     * @return Refreshes the page.
     */
    @AuraEnabled
    public static void submitAwardsForApproval(List<Award__c> awards) {
        List<Award__c> outsideOrdAwards = new List<Award__c>();

        // Check to make sure that the submitted awards pass justification and budget validations.
        AwardProcessSupporter.submissionChecks(awards, UserInfo.getUserId());

        for (Award__c award : awards) {
            if (!award.Outside_ORD__c) {
                Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
                approvalReq.setSubmitterId(UserInfo.getUserId());
                approvalReq.setProcessDefinitionNameOrId('ORD_Awards_Approval_Process');
                approvalReq.setObjectId(award.Id);
                approvalReq.setComments('Please review this award for approval.');

                Approval.ProcessResult result = Approval.process(approvalReq);
            } else {
                // If award is outside ORD, set status and update awards
                award.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
                award.Submitted_Date__c = System.today();
                outsideOrdAwards.add(award);
            }
        }

        if (!outsideOrdAwards.isEmpty()) {
            update outsideOrdAwards;
        }
    }
}