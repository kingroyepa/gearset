/**
 * Constant values necessary for the awards tracking application.
 */

public class AwardConstants {
    // Award Status values
    public static final String AWARD_STATUS_REFERENCE = 'Reference';
    public static final String AWARD_STATUS_PLANNED = 'Planned';
    public static final String AWARD_STATUS_SUBMITTED = 'Submitted';
    public static final String AWARD_STATUS_PENDING_APPROVAL = 'Pending Direct Supervisor Approval';
    public static final String AWARD_STATUS_APPROVED = 'Received by OARS/Approved';
    public static final String AWARD_STATUS_HR_REVIEW = 'HR Review';
    public static final String AWARD_STATUS_SENT_UNION_REVIEW = 'Sent for Union Review';
    public static final String AWARD_STATUS_AWAITING_FUNDING = 'Awaiting Funding';
    public static final String AWARD_STATUS_READY_FOR_SSC = 'Ready for SSC';
    public static final String AWARD_STATUS_TO_SSC = 'To SSC';
    public static final String AWARD_STATUS_READY_FPPS = 'Ready for FPPS';
    public static final String AWARD_STATUS_ENTERED_FPPS = 'Entered into FPPS';
    public static final String AWARD_STATUS_READY_BULK_UPLOAD = 'Ready for Bulk Upload';
    public static final String AWARD_STATUS_BULK_UPLOADED = 'Bulk Uploaded';
    public static final String AWARD_STATUS_FUNDED = 'Funded';
    public static final String AWARD_STATUS_PARTIALLY_PAID = 'Partially Paid';
    public static final String AWARD_STATUS_PAID = 'Paid';
    public static final String AWARD_STATUS_REJECTED = 'Rejected';

    // Award Statuses used for calculations
    public static final Set<String> AWARD_STATUS_FOR_BUDGET_CALC = new Set<String>{
            AWARD_STATUS_SUBMITTED,
            AWARD_STATUS_PENDING_APPROVAL,
            AWARD_STATUS_APPROVED,
            AWARD_STATUS_HR_REVIEW,
            AWARD_STATUS_SENT_UNION_REVIEW,
            AWARD_STATUS_AWAITING_FUNDING,
            AWARD_STATUS_READY_FOR_SSC,
            AWARD_STATUS_TO_SSC,
            AWARD_STATUS_READY_FPPS,
            AWARD_STATUS_ENTERED_FPPS,
            AWARD_STATUS_READY_BULK_UPLOAD,
            AWARD_STATUS_BULK_UPLOADED,
            AWARD_STATUS_FUNDED,
            AWARD_STATUS_PARTIALLY_PAID,
            AWARD_STATUS_PAID
    };

    // Award Document names
    public static final String AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME = 'Document - Award Budget';
    public static final String AWARD_BUDGET_CONTROL_DOCUMENT_RECORDTYPE_NAME = 'Document - Award Budget Control';

    // Award Document Ids
    public static final Id AWARD_BUDGET_RECORDTYPEID = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
    public static final Id AWARD_BUDGETCONTROL_RECORDTYPEID = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_CONTROL_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();

    // Award Document record type Id set for easy filtering
    public static final Set<Id> AWARD_BUDGET_RECORDTYPEID_SET = new Set<Id> {
            AWARD_BUDGET_RECORDTYPEID,
            AWARD_BUDGETCONTROL_RECORDTYPEID
    };

    // Award Document Record Type names used for calculations
    public static final Set<String> AWARD_BUDGET_RECORD_TYPES = new Set<String> {
            AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME,
            AWARD_BUDGET_CONTROL_DOCUMENT_RECORDTYPE_NAME
    };

    // Award Record Type names
    public static final String AWARD_RECORDTYPE_CASH = 'Cash Award';
    public static final String AWARD_RECORDTYPE_OTS = 'OTS Award';
    public static final String AWARD_RECORDTYPE_QSI = 'QSI Award';
    public static final String AWARD_RECORDTYPE_STANDARD = 'Standard Award';
    public static final String AWARD_RECORDTYPE_TIMEOFF = 'Time Off Award';
    public static final String AWARD_RECORDTYPE_TITLE42 = 'Title 42/SL/ST';

    // Award Record Type Ids
    public static final Id AWARD_RECORDTYPEID_CASH = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_CASH).getRecordTypeId();
    public static final Id AWARD_RECORDTYPEID_OTS = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_OTS).getRecordTypeId();
    public static final Id AWARD_RECORDTYPEID_QSI = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_QSI).getRecordTypeId();
    public static final Id AWARD_RECORDTYPEID_STANDARD = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_STANDARD).getRecordTypeId();
    public static final Id AWARD_RECORDTYPEID_TIMEOFF = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_TIMEOFF).getRecordTypeId();
    public static final Id AWARD_RECORDTYPEID_TITLE42 = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_RECORDTYPE_TITLE42).getRecordTypeId();

    // Award Record Type Id Set
    public static final Set<Id> AWARD_RECORDTYPEID_SET = new Set<Id> {
            AWARD_RECORDTYPEID_CASH,
            AWARD_RECORDTYPEID_OTS,
            AWARD_RECORDTYPEID_QSI,
            AWARD_RECORDTYPEID_STANDARD,
            AWARD_RECORDTYPEID_TIMEOFF,
            AWARD_RECORDTYPEID_TITLE42
    };

    // Award Record Type set used for calculations
    public static final Set<String> AWARD_RECORD_TYPES = new Set<String> {
            AWARD_RECORDTYPE_CASH,
            AWARD_RECORDTYPE_OTS,
            AWARD_RECORDTYPE_QSI,
            AWARD_RECORDTYPE_STANDARD,
            AWARD_RECORDTYPE_TIMEOFF,
            AWARD_RECORDTYPE_TITLE42
    };
}