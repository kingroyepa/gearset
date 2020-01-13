/**
 * Class and methods for testing the AwardsTriggerHandler class.
 */
@IsTest
public with sharing class AwardTriggerHandler_Test {
    static Id AWARD_CASH_RECORDTYPE_ID = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get('Cash Award').getRecordTypeId();

    @TestSetup
    public static void createTestData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-OARS-EMD-CB');
        hrOrg.Code__c = 'NA000000';
        insert hrOrg;

        Contact employeeContact = AwardTestUtilities.createEmployee(hrOrg);
        insert employeeContact;
    }

    @IsTest
    public static void testSettingDivsionAndBranch() {
        Contact employee = [SELECT Id, Account.Name FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        Account divisionOrg = AwardTestUtilities.createOrganization('ORD-ABC-DEF');
        divisionOrg.Code__c = 'NA000001';
        insert divisionOrg;

        Contact employeeContactTwo = AwardTestUtilities.createEmployee(divisionOrg);
        insert employeeContactTwo;

        Account lcoOrg = AwardTestUtilities.createOrganization('ORD-ABC');
        lcoOrg.Code__c = 'NA000002';
        insert lcoOrg;

        Contact employeeContactThree = AwardTestUtilities.createEmployee(lcoOrg);
        insert employeeContactThree;

        Award__c divisionAndBranchAward = AwardTestUtilities.createAward(employee);
        divisionAndBranchAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        divisionAndBranchAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        divisionAndBranchAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        divisionAndBranchAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        divisionAndBranchAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;

        Award__c divisionAward = AwardTestUtilities.createAward(employeeContactTwo);
        divisionAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        divisionAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        divisionAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        divisionAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        divisionAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;

        Award__c lcoAward = AwardTestUtilities.createAward(employeeContactThree);
        lcoAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        lcoAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        lcoAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        lcoAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        lcoAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;

        List<Award__c> awardsList = new List<Award__c>{divisionAndBranchAward, divisionAward, lcoAward};

        Test.startTest();
        try {
            insert awardsList;
        } catch (Exception e) {
            System.debug('Caught a exception on insert with message: ' + e.getMessage());
        }
        Test.stopTest();

        List<String> orgPartStrings = employee.Account.Name.split('-');
        Map<Id, Award__c> awardsByIds = new Map<Id, Award__c>([SELECT Id, LCO__c, Division__c, Branch__c FROM Award__c]);

        System.assertEquals(orgPartStrings[1], awardsByIds.get(divisionAndBranchAward.Id).LCO__c, 'LCO strings are not the same.');
        System.assertEquals(orgPartStrings[2], awardsByIds.get(divisionAndBranchAward.Id).Division__c, 'Division strings are not the same.');
        System.assertEquals(orgPartStrings[3], awardsByIds.get(divisionAndBranchAward.Id).Branch__c, 'Branch strings are not the same.');
        System.assertEquals(null, awardsByIds.get(divisionAward.Id).Branch__c, 'Branch should be null.');
        System.assertEquals(null, awardsByIds.get(lcoAward.Id).Division__c, 'Division should be null');
    }

    @IsTest
    public static void testBudgetAndContactSettings() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        User testUser = AwardTestUtilities.createTestUser();
        insert testUser;

        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'Supervisor';
        testUserSupervisor.Username = 'test.supervisor@epa.gov.test';
        insert testUserSupervisor;

        Contact requestingOfficial = new Contact();
        requestingOfficial.User__c = testUser.Id;
        requestingOfficial.FirstName = testUser.FirstName;
        requestingOfficial.LastName = testUser.LastName;
        requestingOfficial.Person_Type__c = 'Employee';
        requestingOfficial.AccountId = hrOrg.Id;
        requestingOfficial.Supervisor__c = testUserSupervisor.Id;
        insert requestingOfficial;

        PermissionSetAssignment assignAwardPermissionSet = AwardTestUtilities.assignAwardSupervisorPermSet(testUser);
        System.runAs(testUser) {
            insert assignAwardPermissionSet;
        }

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Requesting_Official__c = requestingOfficial.Id;

        Test.startTest();
        System.runAs(testUser) {
            insert award;
        }
        Test.stopTest();

        Award__c updatedAward = [SELECT Id, Authorizing_Official__c, Budget__c, Requesting_Official__c FROM Award__c LIMIT 1];

        System.assertEquals(budget.Id, updatedAward.Budget__c, 'Budget Ids do not match.');
        System.assertEquals(testUserSupervisor.Id, updatedAward.Authorizing_Official__c, 'Authorizing official Id does not ' +
                'match testSupervisor Id.');
        System.assertEquals(requestingOfficial.Id, updatedAward.Requesting_Official__c, 'Owner contact Id does not match ' +
                'requesting official Id.');
    }

    @IsTest
    public static void testCustomSharing() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        // User that owns the award.
        User testAwardOwner = AwardTestUtilities.createTestUser();
        testAwardOwner.DelegatedApproverId = UserInfo.getUserId();
        insert testAwardOwner;

        // IOAA Supervisor User on the award.
        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        testIoaaSupervisor.DelegatedApproverId = testAwardOwner.Id;
        insert testIoaaSupervisor;

        // User's supervisor related on the User's related contact.
        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'User Supervisor';
        testUserSupervisor.Username = 'test.usersupervisor@epa.gov.test';
        testUserSupervisor.DelegatedApproverId = testIoaaSupervisor.Id;
        insert testUserSupervisor;

        // User who is listed as the awardee's supervisor.
        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        testAwardeeSupervisor.DelegatedApproverId = testUserSupervisor.Id;
        insert testAwardeeSupervisor;

        Contact testAwardOwnerContact = AwardTestUtilities.createEmployee(hrOrg);
        testAwardOwnerContact.User__c = testAwardOwner.Id;
        testAwardOwnerContact.Supervisor__c = testUserSupervisor.Id;
        insert testAwardOwnerContact;
        
        employee.Supervisor__c = testAwardeeSupervisor.Id;
        update employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        budget.Award_Budget_Start_Date__c = System.today();
        insert budget;

        Document__c childBudget = AwardTestUtilities.createBudget(hrOrg, 5000);
        childBudget.Award_S_Award_Budget__c = 2500;
        childBudget.Award_Title_42_SL_ST_Budget__c = 2500;
        childBudget.Parent_Budget__c = budget.Id;
        childBudget.Award_Budget_Start_Date__c = System.today();
        insert childBudget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Awardee_Direct_Supervisor__c = testAwardeeSupervisor.Id;
        award.OwnerId = testAwardOwner.Id;
        award.Requesting_Official__c = testAwardOwnerContact.Id;
//        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Authorizing_Official__c = testAwardeeSupervisor.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = 'MODERATE VALUE & GENERAL APPLICATION ($650-1,300)';
        award.Budget__c = childBudget.Id;
        award.Cash_Award_Amount__c = 1000;
        award.Time_Off_Amount__c = 0;
        award.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        award.Planned_Date__c = System.today();

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        secondAward.Awardee_Direct_Supervisor__c = testAwardeeSupervisor.Id;
        secondAward.OwnerId = testAwardOwner.Id;
        secondAward.Requesting_Official__c = testAwardOwnerContact.Id;
//        secondAward.IOAA_Approver__c = testIoaaSupervisor.Id;
        secondAward.Authorizing_Official__c = testAwardeeSupervisor.Id;
        secondAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        secondAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        secondAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        secondAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        secondAward.Value_and_Application__c = 'MODERATE VALUE & GENERAL APPLICATION ($650-1,300)';
        secondAward.Budget__c = childBudget.Id;
        secondAward.Cash_Award_Amount__c = 1000;
        secondAward.Time_Off_Amount__c = 0;
        secondAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        secondAward.Planned_Date__c = System.today();
        insert new List<Award__c>{award, secondAward};
        System.debug('>>>>> First award values: ' + award);
        System.debug('>>>>> Second award values: ' + secondAward);

        Test.startTest();
        List<Award__c> updatedAwardList = new List<Award__c>();
        List<Award__c> insertedAwards = new List<Award__c>([SELECT Id FROM Award__c]);
        for (Award__c insertedAward : insertedAwards) {
            Award__c tempAward = new Award__c();
            tempAward.Id = insertedAward.Id;
            tempAward.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
            tempAward.Bypass_Validation__c = true;
            updatedAwardList.add(tempAward);
        }
        System.debug('>>>>> Award values before update: ' + award);
        update updatedAwardList;
//
//        secondAward.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
//        secondAward.Submitted_Date__c = System.today();
//        secondAward.Bypass_Validation__c = true;
//        update new List<Award__c>{award, secondAward};
        Test.stopTest();
    }

    @IsTest
    public static void testSubmitForDirectSupervisorApproval() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        Account newHrOrg = AwardTestUtilities.createOrganization('ORD-OARS-EMD-CB');
        insert newHrOrg;

        // User that owns the award.
        User testAwardOwner = AwardTestUtilities.createTestUser();
        insert testAwardOwner;

        // IOAA Supervisor User on the award.
        User testIoaaSupervisor = AwardTestUtilities.createTestUser();
        testIoaaSupervisor.LastName = 'IOAA Supervisor';
        testIoaaSupervisor.Username = 'test.ioaasupervisor@epa.gov.test';
        insert testIoaaSupervisor;

        // User's supervisor related on the User's related contact.
        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'User Supervisor';
        testUserSupervisor.Username = 'test.usersupervisor@epa.gov.test';
        insert testUserSupervisor;

        // User who is listed as the awardee's supervisor.
        User testAwardeeSupervisor = AwardTestUtilities.createTestUser();
        testAwardeeSupervisor.LastName = 'User Supervisor';
        testAwardeeSupervisor.Username = 'test.awardeesupervisor@epa.gov.test';
        insert testAwardeeSupervisor;

        Contact testAwardOwnerContact = AwardTestUtilities.createEmployee(newHrOrg);
        testAwardOwnerContact.User__c = testAwardOwner.Id;
        testAwardOwnerContact.Supervisor__c = testUserSupervisor.Id;
        insert testAwardOwnerContact;

        employee.Supervisor__c = testAwardeeSupervisor.Id;
        update employee;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c award = AwardTestUtilities.createAward(employee);
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Awardee_Direct_Supervisor__c = testAwardeeSupervisor.Id;
        award.OwnerId = testAwardOwner.Id;
        award.IOAA_Approver__c = testIoaaSupervisor.Id;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.Value_and_Application__c = 'MODERATE VALUE & GENERAL APPLICATION ($650-1,300)';
        award.Budget__c = budget.Id;
        award.Cash_Award_Amount__c = 1000;
        insert award;

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        secondAward.Awardee_Direct_Supervisor__c = testAwardeeSupervisor.Id;
        secondAward.OwnerId = testAwardOwner.Id;
        secondAward.IOAA_Approver__c = testIoaaSupervisor.Id;
        secondAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        secondAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        secondAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        secondAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        secondAward.Value_and_Application__c = 'MODERATE VALUE & GENERAL APPLICATION ($650-1,300)';
        secondAward.Budget__c = budget.Id;
        secondAward.Cash_Award_Amount__c = 1000;
        insert secondAward;

        Map<Id, Award__c> oldAwardsByIds = new Map<Id, Award__c>();
        oldAwardsByIds.put(award.Id, award);
        oldAwardsByIds.put(secondAward.Id, secondAward);

        Test.startTest();
        award.Status__c = 'HR Review';
        award.Bypass_Validation__c = true;
        update award;
        AwardTriggerHandler.submitForDirectSupervisorApproval(new List<Award__c>{ award, secondAward }, oldAwardsByIds);
        Test.stopTest();
    }

    @IsTest
    public static void testSendingPDFs() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c newAward = AwardTestUtilities.createAward(employee);
        newAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        newAward.OwnerId = UserInfo.getUserId();
        newAward.IOAA_Approver__c = UserInfo.getUserId();
        newAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        newAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        newAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        newAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        newAward.Budget__c = budget.Id;
        newAward.Cash_Award_Amount__c = 1000;
        newAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        insert newAward;

        Test.startTest();
        Award__c insertedAward = [SELECT Id FROM Award__c LIMIT 1];
        insertedAward.Status__c = AwardConstants.AWARD_STATUS_READY_FOR_SSC;
        update newAward;
        Test.stopTest();
    }

    @IsTest
    public static void testChangingBudget() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        Account ordOars = AwardTestUtilities.createOrganization('ORD-OARS');
        ordOars.Code__c = 'NA000001';
        insert ordOars;

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Document__c secondBudget = AwardTestUtilities.createBudget(ordOars, 10000);
        insert secondBudget;

        Award__c newAward = AwardTestUtilities.createAward(employee);
        newAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        newAward.OwnerId = UserInfo.getUserId();
        newAward.IOAA_Approver__c = UserInfo.getUserId();
        newAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        newAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        newAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        newAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        newAward.Budget__c = budget.Id;
        newAward.Cash_Award_Amount__c = 1000;
        newAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        insert newAward;

        test.startTest();
        Award__c insertedAward = [SELECT Id FROM Award__c WHERE Id = :newAward.Id LIMIT 1];
        insertedAward.Budget__c = secondBudget.Id;
        update insertedAward;
        test.stopTest();

        Award__c updatedOrgAward = [SELECT Id, RO_HR_Org2__c FROM Award__c WHERE Id = :newAward.Id LIMIT 1];
        System.assertEquals(ordOars.Id, updatedOrgAward.RO_HR_Org2__c, 'The award RO Org should match the budget\'s org.');
    }

    @IsTest
    public static void testQsiAwardInsert() {
        Contact employee = [SELECT Id FROM Contact LIMIT 1];
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];

        User testUser = AwardTestUtilities.createTestUser();
        insert testUser;

        User testUserSupervisor = AwardTestUtilities.createTestUser();
        testUserSupervisor.LastName = 'Supervisor';
        testUserSupervisor.Username = 'test.supervisor@epa.gov.test';
        insert testUserSupervisor;

        Contact requestingOfficial = new Contact();
        requestingOfficial.User__c = testUser.Id;
        requestingOfficial.FirstName = testUser.FirstName;
        requestingOfficial.LastName = testUser.LastName;
        requestingOfficial.Person_Type__c = 'Employee';
        requestingOfficial.AccountId = hrOrg.Id;
        requestingOfficial.Supervisor__c = testUserSupervisor.Id;
        insert requestingOfficial;

        PermissionSetAssignment assignAwardPermissionSet = AwardTestUtilities.assignAwardSupervisorPermSet(testUser);
        System.runAs(testUser) {
            insert assignAwardPermissionSet;
        }

        Document__c budget = AwardTestUtilities.createBudget(hrOrg, 10000);
        insert budget;

        Award__c firstQsiAward = AwardTestUtilities.createAward(employee);
        firstQsiAward.RecordTypeId = AwardConstants.AWARD_RECORDTYPEID_QSI;
        firstQsiAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        firstQsiAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        firstQsiAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        firstQsiAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        firstQsiAward.Requesting_Official__c = requestingOfficial.Id;
        firstQsiAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        firstQsiAward.Budget__c = budget.Id;
        firstQsiAward.Reference__c = false;
        firstQsiAward.QSI__c = true;

        Award__c secondQsiAward = AwardTestUtilities.createAward(employee);
        secondQsiAward.RecordTypeId = AwardConstants.AWARD_RECORDTYPEID_QSI;
        secondQsiAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        secondQsiAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        secondQsiAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        secondQsiAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        secondQsiAward.Requesting_Official__c = requestingOfficial.Id;
        secondQsiAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        secondQsiAward.Budget__c = budget.Id;
        secondQsiAward.Reference__c = false;
        secondQsiAward.QSI__c = true;

        insert new LIst<Award__c>{firstQsiAward, secondQsiAward};

        test.startTest();
        List<Award__c> qsiAwards = [SELECT Id FROM Award__c WHERE QSI__c = true];
        List<Award__c> updatedAwards = new List<Award__c>();
        for (Award__c award : qsiAwards) {
            Award__c tempAward = new Award__c();
            tempAward.Id = award.Id;
            tempAward.Status__c = AwardConstants.AWARD_STATUS_PAID;
            updatedAwards.add(tempAward);
        }

        update updatedAwards;
        test.stopTest();
    }
}