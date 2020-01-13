/**
 * Methods for testing
 */
@IsTest
public with sharing class SubmitForApprovalController_Test {
    static Id AWARD_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Standard Award').getRecordTypeId();
    static Id AWARD_CASH_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Cash Award').getRecordTypeId();


    @TestSetup
    public static void setupTestData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-OARS');
        insert hrOrg;

        // User that owns the award.
        User testAwardOwner = AwardTestUtilities.createTestUser();
        insert testAwardOwner;

        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        insert testAwardeeSupervisor;

        User testInactiveAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testInactiveAwardeeSupervisor.LastName = 'User Supervisor';
        testInactiveAwardeeSupervisor.Username = 'test.inactiveawardeesupervisor@epa.gov.test';
        testInactiveAwardeeSupervisor.IsActive = false;
        insert testInactiveAwardeeSupervisor;

        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        Contact awardeeSupervisorContact = AwardTestUtilities.createEmployee(hrOrg);
        awardeeSupervisorContact.User__c = UserInfo.getUserId();
        insert awardeeSupervisorContact;

        Contact employee = AwardTestUtilities.createEmployee(hrOrg);
        employee.Supervisor__c = testAwardeeSupervisor.Id;
        insert employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 20000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Awardee_Direct_Supervisor__c = testAwardeeSupervisor.Id;
        award.OwnerId = testAwardOwner.Id;
        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Authorizing_Official__c = testAwardeeSupervisor.Id;
        award.Requesting_Official__c = awardeeSupervisorContact.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = 'MODERATE VALUE & GENERAL APPLICATION ($650-1,300)';
        award.Budget__c = budget.Id;
        award.Cash_Award_Amount__c = 1000;
        insert award;
    }

    @IsTest
    public static void testSubmit() {
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
        controller.submitSingleAward();
        Test.stopTest();
    }

    @IsTest
    public static void testSubmittingOutsideOrdAward() {
        Award__c award = [SELECT Id FROM Award__c];
        award.Outside_ORD__c = true;
        update award;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
        controller.submitSingleAward();
        Test.stopTest();
    }

    @IsTest
    public static void testSubmittingAwardWithoutJustification() {
        Award__c award = [SELECT Id FROM Award__c];
        award.Supervisor_Justification__c = null;
        update award;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
        controller.submitSingleAward();
        Test.stopTest();

        System.assertNotEquals(null, ApexPages.getMessages(), 'Justification error should have been thrown and added to page.');
    }

//    @IsTest
//    public static void testSubmittingAwardWithoutBudget() {
//        Award__c award = [SELECT Id FROM Award__c];
//        award.Budget__c = null;
//        update award;
//
//        Test.startTest();
//        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
//        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
//        controller.submitSingleAward();
//        Test.stopTest();
//
//        System.assertNotEquals(null, ApexPages.getMessages(), 'Budget error should have been thrown and added to page.');
//    }

    @IsTest
    public static void testSubmittingAwardWithMissingApprover() {
        Award__c award = [SELECT Id FROM Award__c];
        award.Cash_Award_Amount__c = 1000;
        award.Authorizing_Official__c = null;
        update award;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController([SELECT Id FROM Award__c]);
        SubmitForApprovalController controller = new SubmitForApprovalController(sc);
        controller.submitSingleAward();
        Test.stopTest();

        System.assertNotEquals(null, ApexPages.getMessages(), 'Should have received an error when submitting an award with no approver.');
    }
}