public with sharing class PDFFormCreatorController {
    private final Id awardId;
    public String awardInternalId {get; set;}
    public String employeeName {get; set;}
    public String employeeId {get; set;}
    public String employeePosition {get; set;}
    public String employeeGrade {get; set;}
    public String employeeOrganization {get; set;}
    public String employeePhoneNumber {get; set;}
    public String awardWorkCode {get; set;}
    public Decimal cashAwardAmount {get; set;}
    public Decimal OTSAwardAmount {get; set;}
    public Decimal awardAmount {get; set;}
    public Decimal timeOffAmount {get; set;}
    public Boolean tangibleBenefit {get; set;}
    public Boolean intangibleBenefit {get; set;}
    public Boolean onTheSpotAward {get; set;}
    public Boolean groupCashAward {get; set;}
    public Boolean individualCashAward {get; set;}
    public Boolean groupTimeOff {get; set;}
    public Boolean timeOffAward {get; set;}
    public Boolean moderate {get; set;}
    public Boolean substantial {get; set;}
    public Boolean high {get; set;}
    public Boolean exceptional {get; set;}
    public Boolean limited {get; set;}
    public Boolean extended {get; set;}
    public Boolean broad {get; set;}
    public Boolean general {get; set;}
    public String justification {get; set;}
    public String requestingOfficialName {get; set;}
    public String requestingOfficialTitle {get; set;}
    public String authorizingOfficialName {get; set;}
    public String authorizingOfficialTitle {get; set;}
    public Datetime currentDatetime {get; set;}
    public String currentDate {get; set;}
    public String submittedDate {get; set;}
    public String employeeAchievement {get; set;}
    public String materialImprovement {get; set;}
    public String unitCostReduction {get; set;}
    public String significantContribution {get; set;}
    public String exhibitsBehavior {get; set;}
    public String scientificAdvancement {get; set;}
    public String noteworthyPublication {get; set;}
    public String improvesService {get; set;}
    public Boolean requiresSupervisorApproval {get; set;}
    public Boolean requiresIOAAApproval {get; set;}
    public Boolean outsideOrg {get; set;}
    public Boolean outsideOrd {get; set;}
    public String awardeeDirSuperName {get; set;}
    public String awardeeDirSuperTitle {get; set;}
    public String aoApprovalDate {get; set;}
    public String ioaaApproverName {get; set;}
    public String ioaaApproverTitle {get; set;}
    public List<ProcessInstanceStep> approvalHistory {get; set;}

    public PDFFormCreatorController(ApexPages.StandardController stdController) {
        this.awardId = stdController.getId();
        Award__c currentAward = getCurrentAward(this.awardId);
        awardInternalId = currentAward.Name;

        // If the Cincinnati Justification is not blank, parse it
        if(currentAward.Cincinnati_Office_Justification__c != null) {
            parseCincinnatiJustification(currentAward);
        }

        // Get the approval history related to this award
        approvalHistory = getApprovalHistory(this.awardId);

        // Set Employee Information
        this.employeeName = currentAward.Emp_Name__r.Name;
        this.employeeId = currentAward.Emp_ID__c;
        this.employeePosition = currentAward.Emp_Name__r.Position_Title__c;
        this.employeeGrade = currentAward.Emp_Name__r.Grade__c;
        this.employeeOrganization = currentAward.Emp_Name__r.Account.Name;
        this.employeePhoneNumber = currentAward.Emp_Name__r.Phone;
        this.awardWorkCode = currentAward.Work_Code__c;
        this.cashAwardAmount = currentAward.Cash_Award_Amount__c;
        this.timeOffAmount = currentAward.Time_Off_Amount__c;
        this.OTSAwardAmount = currentAward.OTS_Amount__c;
        this.justification = currentAward.Supervisor_Justification__c;
        this.requestingOfficialName = currentAward.Requesting_Official_Supervisor__c;
        this.requestingOfficialTitle = currentAward.Requesting_Official_Supervisor_Title__c;
        this.authorizingOfficialName = currentAward.Authorizing_Official_Name__c;
        this.authorizingOfficialTitle = currentAward.Authorizing_Official_Title__c;
        this.currentDatetime = System.now();
        this.currentDate = Date.today().format();
        this.submittedDate = currentAward.Submitted_Date__c != null ? currentAward.Submitted_Date__c.format() : null;
        this.aoApprovalDate = currentAward.Supervisor_Approval_Date__c != null ? currentAward.Supervisor_Approval_Date__c.format() : null;
        this.requiresSupervisorApproval = currentAward.Requires_Supervisor_Approval__c;
        this.requiresIOAAApproval = currentAward.Requires_IOAA_Approval__c;
        this.outsideOrg = currentAward.Outside_Org__c;
        this.outsideOrd = currentAward.Outside_ORD__c;
        this.awardeeDirSuperName = currentAward.Awardee_Direct_Supervisor__r.Name;
        this.awardeeDirSuperTitle = currentAward.Awardee_Direct_Supervisor__r.Title;
        this.ioaaApproverName = currentAward.IOAA_Approver__r.Name;
        this.ioaaApproverTitle = currentAward.IOAA_Approver__r.Title;
        
        // Set class variables based on picklist values
        this.tangibleBenefit = currentAward.Type_of_Benefit__c == 'Tangible' ? true : false;
        this.intangibleBenefit = currentAward.Type_of_Benefit__c == 'Intangible' ?  true : false;
        this.moderate = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('MODERATE VALUE') ? true : false;
        this.substantial = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('SUBSTANTIAL VALUE') ? true : false;
        this.high = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('HIGH VALUE') ? true : false;
        this.exceptional = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('EXCEPTIONAL VALUE') ? true : false;
        this.limited = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('LIMITED APPLICATION') ? true : false;
        this.extended = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('EXTENDED APPLICATION') ? true : false;
        this.broad = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('BROAD APPLICATION') ? true : false;
        this.general = currentAward.Value_and_Application__c != null && currentAward.Value_and_Application__c.contains('GENERAL APPLICATION') ? true : false;

        // Set class variables based on whether or not the fields either have values or those values are greater than 0
        this.individualCashAward = currentAward.Cash_Award_Amount__c != null && currentAward.Cash_Award_Amount__c > 0  && !(currentAward.OTS_Amount__c > 0) ? true : false;
        this.groupCashAward = currentAward.Group_Award_Name__c != null ? true : false;
        this.timeOffAward = currentAward.Time_Off_Amount__c != null && currentAward.Time_Off_Amount__c > 0 ? true : false;
        this.onTheSpotAward = currentAward.OTS_Amount__c != null && currentAward.OTS_Amount__c > 0 ? true : false;
        this.awardAmount = this.onTheSpotAward ? currentAward.OTS_Amount__c : currentAward.Cash_Award_Amount__c;
    }

    public PageReference createOnePageForm() {
        Award__c award = getCurrentAward(this.awardId);

        Attachment attachment = new Attachment();
        PageReference pdf = Page.AwardSinglePageForm;
        pdf.getParameters().put('Id', this.awardId);
        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('PDF Content') : pdf.getContent();
        attachment.Body = pdfBlob;
        attachment.Name = award.Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_1page.pdf';
        attachment.ParentId = award.Id;
        insert attachment;

        return new PageReference('/' + award.Id);
    }

    public PageReference createDoublePageForm() {
        Award__c award = getCurrentAward(this.awardId);

        Attachment attachment = new Attachment();
        PageReference pdf = Page.AwardDoublePageForm;
        pdf.getParameters().put('Id', this.awardId);
        Blob pdfBlob = Test.isRunningTest() ? Blob.valueOf('PDF Content') : pdf.getContent();
        attachment.Body = pdfBlob;
        attachment.Name = award.Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_2page.pdf';
        attachment.ParentId = award.Id;
        insert attachment;

        return new PageReference('/' + award.Id);
    }

    public PageReference createCincinnatiForm() {
        Award__c award = getCurrentAward(this.awardId);

        Attachment attachment = new Attachment();
        PageReference pdf = Page.CincinnatiJustificationForm;
        pdf.getParameters().put('Id', this.awardId);
        attachment.Body = Test.isRunningTest() ? Blob.valueOf('PDF Content') : pdf.getContentAsPDF();
        attachment.Name = award.Emp_Name__r.Name + '_' + String.valueOf(Date.today()) + '_CincinattiJustification.pdf';
        attachment.ParentId = award.Id;
        insert attachment;

        return new PageReference('/' + award.Id);
    }

    private Award__c getCurrentAward(Id awardId) {
        Award__c award = [
                SELECT Id, Name, Emp_Name__r.Name, Emp_ID__c, Emp_Name__r.Position_Title__c, Emp_Name__r.Grade__c, Emp_Name__r.Account.Name,
                        Extent_of_Contribution__c, Cash_Award_Amount__c, Group_Award_Name__c, Work_Code__c,
                        Supervisor_Justification__c, Type_of_Benefit__c, OTS_Amount__c, Time_Off_Amount__c,
                        Requesting_Official_Supervisor__c, Requesting_Official_Supervisor_Title__c, Authorizing_Official_Name__c,
                        Authorizing_Official_Title__c, Submitted_Date__c, Supervisor_Approval_Date__c, Emp_Name__r.Phone, Cincinnati_Office_Justification__c,
                        Requires_Supervisor_Approval__c, Requires_IOAA_Approval__c, Outside_Org__c, Awardee_Direct_Supervisor__r.Name,
                        Awardee_Direct_Supervisor__r.Title, Outside_ORD__c, IOAA_Approver__r.Name, IOAA_Approver__r.Title, Value_and_Application__c
                FROM Award__c
                WHERE Id = :awardId
                LIMIT 1
        ];

        return award;
    }

    private void parseCincinnatiJustification(Award__c award) {
        String cinciJustification = award.Cincinnati_Office_Justification__c;
        List<String> justificationReasons = new List<String>();

        if (cinciJustification != null) {
            justificationReasons = cinciJustification.split(';');
        }

        if (justificationReasons.size() > 0) {
            for (String reason : justificationReasons) {
                if (reason.contains('Substantially surpasses performance goals')) {
                    this.employeeAchievement = 'X';
                }

                if (reason.contains('Improved performance over the prior period')) {
                    this.materialImprovement = 'X';
                }

                if (reason.contains('Reduced costs, expert performance, increased efficiencies')) {
                    this.unitCostReduction = 'X';
                }

                if (reason.contains('Makes significant contributions to the EPA')) {
                    this.significantContribution = 'X';
                }

                if (reason.contains('Exemplifies core values of the EPA')) {
                    this.exhibitsBehavior = 'X';
                }

                if (reason.contains('Achieves Specific Scientific Advancements')) {
                    this.scientificAdvancement = 'X';
                }

                if (reason.contains('Prepares outstanding publications')) {
                    this.noteworthyPublication = 'X';
                }

                if (reason.contains('Improves service to the public')) {
                    this.improvesService = 'X';
                }
            }
        }
    }

    private List<ProcessInstanceStep> getApprovalHistory(Id awardId) {
        ProcessInstance[] processInstance = [
                SELECT Id
                FROM ProcessInstance
                WHERE TargetObjectId = :awardId
                AND Status = 'Approved'
                LIMIT 1
        ];

        if (processInstance.isEmpty()) {
            return null;
        }

        List<ProcessInstanceStep> approvalHistory = [
                SELECT Id, OriginalActor.Name, Actor.Name, CreatedDate, StepStatus
                FROM ProcessInstanceStep
                WHERE ProcessInstanceId = :processInstance[0].Id
        ];

        return approvalHistory;
    }
}