public class SubmitForApprovalController {
    private final Id awardId;
    private final Award__c currentAward;
    private final Id userId;

    public SubmitForApprovalController(ApexPages.StandardController stdController) {
        this.awardId = stdController.getId();
        this.currentAward = getCurrentAwardInfo(this.awardId);
        this.userId = UserInfo.getUserId();
    }

    @TestVisible
    private Award__c getCurrentAwardInfo(Id awardId) {
        Award__c currentAward = [
                SELECT Id, Outside_ORD__c, Cash_Award_Amount__c, Time_Off_Amount__c, Value_of_Benefit__c, Type_of_Benefit__c,
                        Extent_of_Contribution__c, Supervisor_Justification__c, Budget__c, Value_and_Application__c, Requesting_Official__c,
                        RecordTypeId
                FROM Award__c
                WHERE Id = :awardId
                LIMIT 1
        ];

        return currentAward;
    }

    public PageReference submitSingleAward() {
        if (this.currentAward.Outside_ORD__c) {
            this.currentAward.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
            this.currentAward.Submitted_Date__c = System.today();
            this.currentAward.Bypass_Validation__c = true;
            save();

            PageReference awardPage = new PageReference('/' + awardId);
            awardPage.setRedirect(true);
            return awardPage;
        } else {
            // Check that the award has proper justification before submitting.
            try {
                System.debug('>>>>> Running User Id: ' + userId);
                AwardProcessSupporter.submissionChecks(new List<Award__c> { currentAward }, this.userId);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, e.getMessage()));
                return null;
            }

            Approval.ProcessSubmitRequest approvalReq = new Approval.ProcessSubmitRequest();
            approvalReq.setSubmitterId(userId);
            approvalReq.setProcessDefinitionNameOrId('ORD_Awards_Approval_Process');
            approvalReq.setObjectId(currentAward.Id);
            approvalReq.setComments('Please review this award for approval.');

            try {
                Approval.ProcessResult result = Approval.process(approvalReq);
            } catch (Exception e) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.FATAL, 'An error occurred while submitting the award with the following message: ' + e.getMessage()));
                return null;
            }

            PageReference awardPage = new PageReference('/' + awardId);
            awardPage.setRedirect(true);
            return awardPage;
        }
    }

    @TestVisible
    private PageReference save() {
        update this.currentAward;

        PageReference awardPage = new PageReference('/' + awardId);
        awardPage.setRedirect(true);
        return awardPage;
    }
}