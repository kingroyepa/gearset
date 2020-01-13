/**
 * Methods for testing creating 1- and 2-page PDF forms.
 */

@IsTest
public with sharing class PDFFormCreatorController_Test {
    static Id AWARD_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Standard Award').getRecordTypeId();

    @TestSetup
    public static void setupTestData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-ABC-DEF-GHI');
        insert hrOrg;

        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        insert testAwardeeSupervisor;

        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        Contact employee = AwardTestUtilities.createEmployee(hrOrg);
        employee.Supervisor__c = testAwardeeSupervisor.Id;
        insert employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 20000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.RecordTypeId = AWARD_RECORDTYPE_ID;
        award.OwnerId = UserInfo.getUserId();
        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Budget__c = budget.Id;
        award.Cash_Award_Amount__c = 1000;
        insert award;
    }

    @IsTest
    public static void testFormCreation() {
        Award__c award = [SELECT Id FROM Award__c];

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(award);
        PDFFormCreatorController controller = new PDFFormCreatorController(sc);
        controller.createOnePageForm();
        controller.createDoublePageForm();
        Test.stopTest();
    }

    @IsTest
    public static void createCincinattiForm() {
        Award__c award = [SELECT Id FROM Award__c];
        award.Cincinnati_Office_Justification__c = 'Substantially surpasses performance goals;Improved performance over the prior period;' +
                'Reduced costs, expert performance, increased efficiencies;Exemplifies core values of the EPA;Achieves Specific Scientific Advancements;' +
                'Prepares outstanding publications;Improves service to the public;Makes significant contributions to the EPA';
        update award;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(award);
        PDFFormCreatorController controller = new PDFFormCreatorController(sc);
        controller.createCincinnatiForm();
        Test.stopTest();
    }

}