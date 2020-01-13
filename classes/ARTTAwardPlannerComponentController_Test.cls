/**
 * Created by justin.dove on 2019-04-30.
 */

@IsTest
public with sharing class ARTTAwardPlannerComponentController_Test {
    static Id AWARD_CASH_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Cash Award').getRecordTypeId();
    static String VALUE_APPLICATION_EXCEPTIONAL = 'EXCEPTIONAL VALUE & EXTENDED APPLICATION ($1,300-3,150)';

    @TestSetup
    public static void testData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-OARS');
        insert hrOrg;

        List<Contact> employees = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            Contact employee = AwardTestUtilities.createEmployee(hrOrg);
            employee.LastName = employee.LastName + i;

            employees.add(employee);
        }
        insert employees;

        Document__c budget = new Document__c();
        budget.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
        budget.Award_Total_Budget__c = 10000;
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
    public static void getAwardAndBudget() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];

        Account hrOrg = AwardTestUtilities.createOrganization('ORD-OARS');
        insert hrOrg;

        Document__c budget = new Document__c();
        budget.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get(AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME).getRecordTypeId();
        budget.Award_Total_Budget__c = 10000;
        budget.Award_Budget_Start_Date__c = System.today();
        budget.Award_Budget_Org__c = hrOrg.Id;
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Budget__c = budget.Id;
        award.Planned_Date__c = System.today();
        award.OwnerId = UserInfo.getUserId();
        insert award;

        test.startTest();
        List<Document__c> budgets = ARTTAwardPlannerComponentController.getBudgets();
        List<Award__c> awards = ARTTAwardPlannerComponentController.getAwards();
        List<Award__c> filteredAwards = ARTTAwardPlannerComponentController.getFilteredAwards(hrOrg.Name);

        award.Cash_Award_Amount__c = 300;
        ARTTAwardPlannerComponentController.saveAwards(new List<Award__c>{ award });
        test.stopTest();

        System.assertNotEquals(null, budgets, 'Should have returned inserted budgets.');
        System.assertNotEquals(null, awards, 'Should have returned inserted awards.');
        System.assertNotEquals(null, filteredAwards, 'Should have returned an award filtered by HR Org name.');
    }

    @IsTest
    public static void testSubmitAwards() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Document__c budget = [SELECT Id FROM Document__c LIMIT 1];
        Account budgetOrg = [SELECT Id FROM Account LIMIT 1];

        // IOAA Supervisor User on the award.
        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        // User's supervisor related on the User's related contact.
        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'User Supervisor';
        testUserSupervisor.Username = 'test.usersupervisor@epa.gov.test';
        testUserSupervisor.DelegatedApproverId = testIoaaSupervisor.Id;
        insert testUserSupervisor;

        Contact roContact = AwardTestUtilities.createEmployee(budgetOrg);
        roContact.User__c = UserInfo.getUserId();
        roContact.Supervisor__c = testUserSupervisor.Id;
        insert roContact;

        // User who is listed as the awardee's supervisor.
        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        testAwardeeSupervisor.DelegatedApproverId = testUserSupervisor.Id;
        insert testAwardeeSupervisor;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 3000;
        award.Budget__c = budget.Id;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Authorizing_Official__c = UserInfo.getUserId();
        award.Requesting_Official__c = roContact.Id;
        award.Status__c = 'Planned';
        award.HR_Reviewed_Date__c = System.today();
        insert award;

        test.startTest();
        ARTTAwardPlannerComponentController.submitAwardsForApproval(new List<Award__c>{ award });
        test.stopTest();
    }

    @IsTest
    public static void testOutsideOrdAwardSubmit() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Document__c budget = [SELECT Id FROM Document__c LIMIT 1];
        Account budgetOrg = [SELECT Id FROM Account LIMIT 1];

        Account outsideOrdOrg = AwardTestUtilities.createOrganization('AO-OES');
        insert outsideOrdOrg;

        Contact outsideOrdEmployee = AwardTestUtilities.createEmployee(outsideOrdOrg);
        insert outsideOrdEmployee;

        // IOAA Supervisor User on the award.
        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        // User's supervisor related on the User's related contact.
        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'User Supervisor';
        testUserSupervisor.Username = 'test.usersupervisor@epa.gov.test';
        testUserSupervisor.DelegatedApproverId = testIoaaSupervisor.Id;
        insert testUserSupervisor;

        Contact roContact = AwardTestUtilities.createEmployee(budgetOrg);
        roContact.User__c = UserInfo.getUserId();
        roContact.Supervisor__c = testUserSupervisor.Id;
        insert roContact;

        // User who is listed as the awardee's supervisor.
        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        testAwardeeSupervisor.DelegatedApproverId = testUserSupervisor.Id;
        insert testAwardeeSupervisor;

        Award__c award = AwardTestUtilities.createAward(outsideOrdEmployee);
        award.Cash_Award_Amount__c = 3000;
        award.Budget__c = budget.Id;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Authorizing_Official__c = UserInfo.getUserId();
        award.Requesting_Official__c = roContact.Id;
        award.Status__c = 'Planned';
        award.HR_Reviewed_Date__c = System.today();
        award.Outside_ORD__c = true;
        insert award;

        test.startTest();
        ARTTAwardPlannerComponentController.submitAwardsForApproval(new List<Award__c>{ award });
        test.stopTest();
    }

}