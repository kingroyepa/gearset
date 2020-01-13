/**
 * Created by justin.dove on 2019-04-30.
 */
@IsTest
public with sharing class AwardCloneController_Test {
    static String TYPE_OF_BENEFIT = 'Tangible';
    static String VALUE_OF_BENEFIT = 'Substantial';
    static String EXTENT_OF_CONTRIBUTION = 'Broad';
    static String SUPERVISOR_JUSTIFICATION = 'Good work.';
    static String VALUE_APPLICATION_EXCEPTIONAL = 'EXCEPTIONAL VALUE & EXTENDED APPLICATION ($1,300-3,150)';
    static Id AWARD_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Standard Award').getRecordTypeId();
    static Id AWARD_CASH_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Cash Award').getRecordTypeId();
    static Id AWARD_TIMEOFF_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Time Off Award').getRecordTypeId();

    @TestSetup
    public static void testData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-ABC-NRML');
        insert hrOrg;

        List<Contact> employees = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact employee = AwardTestUtilities.createEmployee(hrOrg);
            employee.LastName = employee.LastName + i;

            employees.add(employee);
        }
        insert employees;

        Document__c parentBudget = new Document__c();
        parentBudget.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_CONTROL_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
        parentBudget.Award_Total_Budget__c = 20000;
        parentBudget.Award_S_Award_Budget__c = 10000;
        parentBudget.Award_Title_42_SL_ST_Budget__c = 10000;
        parentBudget.Award_Budget_Start_Date__c = System.today();
        insert parentBudget;

        Document__c budget = new Document__c();
        budget.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
        budget.Award_Total_Budget__c = 10000;
        budget.Award_S_Award_Budget__c = 5000;
        budget.Award_Title_42_SL_ST_Budget__c = 5000;
        budget.Parent_Budget__c = parentBudget.Id;
        budget.Award_Budget_Start_Date__c = System.today();
        insert budget;

        List<Award__c> awards = new List<Award__c>();
        for (Integer i = 0; i < employees.size(); i++) {
            Award__c award = AwardTestUtilities.createAward(employees[i]);
            award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
            award.Budget__c = budget.Id;
            award.Planned_Date__c = System.today();
            award.OwnerId = UserInfo.getUserId();

            awards.add(award);
        }
        insert awards;
    }

    @IsTest
    public static void testCashAwardClone() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 3000;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Authorizing_Official__c = UserInfo.getUserId();
        award.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
        award.Date_Ready_for_Bulk_Upload__c = System.today();
        award.Date_Ready_for_FPPS__c = System.today();
        insert award;

        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(award);
        AwardCloneController awardController = new AwardCloneController(controller);
        awardController.cashAwardClone();
        Test.stopTest();
    }

    @IsTest
    public static void testTimeOffAwardClone() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 3000;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        award.RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID;
        award.Authorizing_Official__c = UserInfo.getUserId();
        award.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
        award.Date_Ready_for_Bulk_Upload__c = System.today();
        award.Date_Ready_for_FPPS__c = System.today();
        insert award;

        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(award);
        AwardCloneController awardController = new AwardCloneController(controller);
        awardController.timeoffAwardClone();
        Test.stopTest();
    }

    @IsTest
    public static void testNullRecordType() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 3000;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        award.RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID;
        award.Authorizing_Official__c = UserInfo.getUserId();
        award.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
        award.Date_Ready_for_Bulk_Upload__c = System.today();
        award.Date_Ready_for_FPPS__c = System.today();
        insert award;

        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(award);
        AwardCloneController awardController = new AwardCloneController(controller);
        awardController.cloneAward(null);
        Test.stopTest();
    }

    @IsTest
    public static void testErrorAward() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 3000;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        award.RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID;
        award.Authorizing_Official__c = UserInfo.getUserId();
        award.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
        award.Date_Ready_for_Bulk_Upload__c = System.today();
        award.Date_Ready_for_FPPS__c = System.today();
        insert award;

        Test.startTest();
        Award__c insertedAward = [SELECT Id FROM Award__c WHERE Id = :award.Id];
        award.Value_and_Application__c = null;
        update insertedAward;
        ApexPages.StandardController controller = new ApexPages.StandardController(insertedAward);
        AwardCloneController awardController = new AwardCloneController(controller);
        awardController.timeoffAwardClone();
        Test.stopTest();
    }
}