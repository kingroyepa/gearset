@IsTest
public with sharing class AwardProcessSupporter_Test {
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
    public static void testSupervisorApproval() {
        List<Decimal> awardAmounts = new List<Decimal>{1000, 2000, 3000};
        List<Award__c> awards = [
                SELECT Id
                FROM Award__c
                LIMIT 3
        ];

        for (Integer i = 0; i < awardAmounts.size(); i++) {
            awards[i].Cash_Award_Amount__c = awardAmounts[i];
        }

        Test.startTest();
        AwardProcessSupporter.checkSupervisorApproval(awards);
        Test.stopTest();

        System.assert(!awards[0].Requires_Supervisor_Approval__c, 'Cash award less than $1,000 does not require supervisor approval');
        System.assert(!awards[1].Requires_Supervisor_Approval__c, 'Cash award of exactly $2,000 no longer requires supervisor approval');
        System.assert(awards[2].Requires_Supervisor_Approval__c, 'Cash award greater than $2,000 requires supervisor approval');
    }


    @IsTest
    public static void testBudgetBalances() {
        Document__c budget = [
                SELECT Id
                FROM Document__c
                WHERE RecordType.Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
        ];

        Contact employee = [SELECT Id FROM Contact LIMIT 1];

        budget.Award_Total_Budget__c = 3000;
        budget.Award_S_Award_Budget__c = 1500;
        budget.Award_Title_42_SL_ST_Budget__c = 1500;
        update budget;

        Award__c award = new Award__c();
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        award.Budget__c = budget.Id;
        award.Emp_Name__c = employee.Id;
        award.OwnerId = UserInfo.getUserId();
        award.Cash_Award_Amount__c = 2000;
        award.Type_of_Benefit__c = TYPE_OF_BENEFIT;
        award.Value_of_Benefit__c = VALUE_OF_BENEFIT;
        award.Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
        award.Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
        award.Submitted_Date__c = System.today();
        award.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        insert award;

        Award__c secondAward = new Award__c();
        secondAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        secondAward.Budget__c = budget.Id;
        secondAward.Emp_Name__c = employee.Id;
        secondAward.OwnerId = UserInfo.getUserId();
        secondAward.Cash_Award_Amount__c = 2000;
        secondAward.Type_of_Benefit__c = TYPE_OF_BENEFIT;
        secondAward.Value_of_Benefit__c = VALUE_OF_BENEFIT;
        secondAward.Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
        secondAward.Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
        secondAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        secondAward.Submitted_Date__c = System.today();
        insert secondAward;

        Test.startTest();
        award.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        award.Bypass_Validation__c = true;
        secondAward.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        secondAward.Bypass_Validation__c = true;
        try {
            // Need to set this to false because all updates are run in the same context, thus the Boolean is not reset
            AwardProcessSupporter.hasBeenCalculated = false;
            update new List<Award__c>{award, secondAward};
            System.assert(false, 'Should have caught a budget error here.');
        } catch (DmlException dmle) {
            System.debug('Caught AwardException with error: ' + dmle.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void retrieveBudgetsById() {
        List<Document__c> budgets = new List<Document__c>();
        Set<Id> budgetIds = new Set<Id>();
        Account org = AwardTestUtilities.createOrganization('ORD-ACC-USB');
        insert org;

        Id budgetRecordTypeId = [
                SELECT Id
                FROM RecordType
                WHERE SobjectType = 'Document__c'
                AND Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
                LIMIT 1
        ].Id;

        for (Integer i = 0; i < 3; i++) {
            Document__c budget = new Document__c();
            budget.Award_Total_Budget__c = 300000;
            budget.RecordTypeId = budgetRecordTypeId;
            budget.Award_Budget_Start_Date__c = System.today();

            budgets.add(budget);
        }
        insert budgets;

        for (Document__c budget : budgets) {
            budgetIds.add(budget.Id);
        }

        Test.startTest();
        Map<Id, Document__c> budgetsByIds = AwardProcessSupporter.getBudgetsById(budgetIds);
        Test.stopTest();

        System.assertEquals(budgetIds.size(), budgetsByIds.size(), 'Should have retrieved all budgets for the given Ids.');
    }

    @IsTest
    public static void testTimeOffAwards() {
        List<Decimal> timeOffAmounts = new List<Decimal>{5, 12};
        Award__c[] awards = [SELECT Id FROM Award__c LIMIT 2];
        String timeOffException;

        for (Integer i = 0; i < awards.size(); i++) {
            awards[i].Time_Off_Amount__c = timeOffAmounts[i];
            awards[i].Type_of_Benefit__c = TYPE_OF_BENEFIT;
            awards[i].Value_of_Benefit__c = VALUE_OF_BENEFIT;
            awards[i].Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
            awards[i].Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
            awards[i].RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID;
        }
        update awards;

        Test.startTest();
        for (Award__c award : awards) {
            // Set hasBeenCalculated to false to mimic a new trigger context.
            AwardProcessSupporter.hasBeenCalculated = false;
            award.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;

            try {
                update award;
            } catch (DmlException dmle) {
                timeOffException = dmle.getMessage();
            }
        }
        Test.stopTest();

        Award__c supervisorApprovalNeededAward = [
                SELECT Id, Requires_Supervisor_Approval__c
                FROM Award__c
                WHERE Time_Off_Amount__c > 10
        ];

        System.assertEquals(true, supervisorApprovalNeededAward.Requires_Supervisor_Approval__c, 'A 10-hour award should have triggered supervisor approval');
    }
    
    @IsTest
    public static void testCumulativeTimeOffLimit() {
        // Mimic filling out the award
        Award__c award = [SELECT Id, Emp_Name__c, Budget__c FROM Award__c LIMIT 1];
        
        Award__c firstNewAward = new Award__c();
        firstNewAward.Emp_Name__c = award.Emp_Name__c;
        firstNewAward.Budget__c = award.Budget__c;
        firstNewAward.Time_Off_Amount__c = 50;
        firstNewAward.Type_of_Benefit__c = TYPE_OF_BENEFIT;
        firstNewAward.Value_of_Benefit__c = VALUE_OF_BENEFIT;
        firstNewAward.Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION;
        firstNewAward.Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION;
        firstNewAward.RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID;
        firstNewAward.Status__c = AwardConstants.AWARD_STATUS_PAID;
        firstNewAward.Bypass_Validation__c = true;
        firstNewAward.Submitted_Date__c = System.today();
        insert firstNewAward;

        // Submit the award
        SubmitForApprovalController submit = new SubmitForApprovalController(new ApexPages.StandardController(award));
        PageReference reference = submit.submitSingleAward();

        // Create a new award that would bring the employee's total to greater than 80 cumulative hours
        Award__c newAward = new Award__c(
                RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID,
                Emp_Name__c = award.Emp_Name__c,
                Time_Off_Amount__c = 40,
                Type_of_Benefit__c = TYPE_OF_BENEFIT,
                Value_of_Benefit__c = VALUE_OF_BENEFIT,
                Extent_of_Contribution__c = EXTENT_OF_CONTRIBUTION,
                Supervisor_Justification__c = SUPERVISOR_JUSTIFICATION,
                Budget__c = award.Budget__c,
                Submitted_Date__c = System.today(),
                OwnerId = UserInfo.getUserId()
        );
        insert newAward;

        Test.startTest();
        // Submit the award and catch an error
        newAward.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
        newAward.Bypass_Validation__c = true;
        newAward.Submitted_Date__c = System.today();
        try {
            update newAward;
            System.assert(false, 'Should have caught a DmlException because the total hours is greater than 80.');
        } catch (DmlException dmle) {
            System.debug('Caught DmlException with message: ' + dmle.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void testMultipleAwardsForOneEmployee() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c firstAward = AwardTestUtilities.createAward(employee);
        firstAward.Cash_Award_Amount__c = 3000;
        firstAward.STAA_Award_Amount__c = 0;
        firstAward.Title_42_SL_ST_Award_Amount__c = 0;
        firstAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        firstAward.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.Cash_Award_Amount__c = 3000;
        secondAward.STAA_Award_Amount__c = 0;
        secondAward.Title_42_SL_ST_Award_Amount__c = 0;
        secondAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        secondAward.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;

        List<Award__c> awards = new List<Award__c>{firstAward, secondAward};

        Test.startTest();
        AwardProcessSupporter.checkIoaaApproval(awards);
        Test.stopTest();

        System.assertEquals(true, firstAward.Requires_IOAA_Approval__c, 'Award should require IOAA approval.');
        System.assertEquals(true, secondAward.Requires_IOAA_Approval__c, 'Award should require IOAA approval.');
    }

    @IsTest
    public static void testJustificationError() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 500;
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;

        Test.startTest();
        try {
            AwardProcessSupporter.submissionChecks(new List<Award__c>{ award }, UserInfo.getUserId());
            System.assert(false, 'Should have caught a missing justification exception.');
        } catch (Exception e) {
            System.debug('>>>>> Received the following error message: ' + e.getMessage());
            System.assert(e.getMessage().contains('Justification'));
        }
        Test.stopTest();
    }

    @IsTest
    public static void testBudgetError() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];

        Award__c award = AwardTestUtilities.createAward(employee);
        award.Cash_Award_Amount__c = 500;
        award.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        award.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        award.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        award.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        award.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        award.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;

        Test.startTest();
        try {
            AwardProcessSupporter.submissionChecks(new List<Award__c>{ award }, UserInfo.getUserId());
            System.assert(false, 'Should have caught a missing budget exception.');
        } catch (Exception e) {
            System.debug('>>>>> Received the following error message: ' + e.getMessage());
            System.assert(e.getMessage().contains('budget'));
        }
        Test.stopTest();
    }

    @IsTest
    public static void testSendingEmails() {
        Award__c award = [SELECT Id FROM Award__c LIMIT 1];

        Test.startTest();
        AwardProcessSupporter.sendPdfEmails(new List<Id>{award.Id});
        Test.stopTest();
    }

    @IsTest
    public static void testRejectAwardApprovals() {
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
        insert award;

        test.startTest();
        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setComments('Please approve.');
        request.setObjectId(award.Id);
        request.setProcessDefinitionNameOrId('ORD_Awards_Approval_Process');
        request.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(request);

        AwardProcessSupporter.rejectAwardApprovals(new List<Id>{ award.Id });
        test.stopTest();
    }
    
    @IsTest
    public static void testCashAwardRank() {
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

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.Cash_Award_Amount__c = 3000;
        secondAward.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        secondAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        secondAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        secondAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        secondAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        secondAward.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        secondAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        secondAward.Authorizing_Official__c = UserInfo.getUserId();
        secondAward.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
        secondAward.HR_Reviewed_Date__c = System.today() - 1;
        secondAward.Date_Ready_for_FPPS__c = System.today() - 1;
        insert secondAward;

        test.startTest();
        List<Award__c> insertedAwards = [SELECT Id FROM Award__c];
        for (Award__c insertedAward : insertedAwards) {
            insertedAward.Status__c = AwardConstants.AWARD_STATUS_READY_FPPS;
            insertedAward.Bypass_Validation__c = true;
        }
        update insertedAwards;
        test.stopTest();
    }

    @IsTest
    public static void testToAwardRank() {
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

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.Cash_Award_Amount__c = 3000;
        secondAward.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        secondAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        secondAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        secondAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        secondAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        secondAward.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        secondAward.RecordTypeId = AWARD_TIMEOFF_RECORDTYPE_ID;
        secondAward.Authorizing_Official__c = UserInfo.getUserId();
        secondAward.Status__c = AwardConstants.AWARD_STATUS_HR_REVIEW;
        secondAward.HR_Reviewed_Date__c = System.today() - 1;
        secondAward.Date_Ready_for_FPPS__c = System.today() - 1;
        insert secondAward;

        test.startTest();
        List<Award__c> insertedAwards = [SELECT Id FROM Award__c];
        for (Award__c insertedAward : insertedAwards) {
            insertedAward.Status__c = AwardConstants.AWARD_STATUS_READY_FPPS;
            insertedAward.Bypass_Validation__c = true;
        }
        update insertedAwards;
        test.stopTest();
    }

    @IsTest
    public static void testMultipleSubmittedAwards() {
        Contact employee = [SELECT Id, Name, Account.Name FROM Contact LIMIT 1];
        Document__c budget = [
                SELECT Id
                FROM Document__c
                WHERE RecordType.Name = :AwardConstants.AWARD_BUDGET_DOCUMENT_RECORDTYPE_NAME
        ];

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
        award.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        award.Submitted_Date__c = System.today();
        insert award;

        Award__c secondAward = AwardTestUtilities.createAward(employee);
        secondAward.Cash_Award_Amount__c = 3000;
        secondAward.Budget__c = budget.Id;
        secondAward.Value_and_Application__c = AwardTestUtilities.VALUE_APPLICATION;
        secondAward.Extent_of_Contribution__c = AwardTestUtilities.EXTENT_OF_CONTRIBUTION;
        secondAward.Value_of_Benefit__c = AwardTestUtilities.VALUE_OF_BENEFIT;
        secondAward.Type_of_Benefit__c = AwardTestUtilities.TYPE_OF_BENEFIT;
        secondAward.Supervisor_Justification__c = AwardTestUtilities.SUPERVISOR_JUSTIFICATION;
        secondAward.Value_and_Application__c = VALUE_APPLICATION_EXCEPTIONAL;
        secondAward.RecordTypeId = AWARD_CASH_RECORDTYPE_ID;
        secondAward.Authorizing_Official__c = UserInfo.getUserId();
        secondAward.Status__c = AwardConstants.AWARD_STATUS_PLANNED;
        secondAward.Submitted_Date__c = System.today() - 1;
        insert secondAward;

        test.startTest();
        List<Award__c> insertedAwards = [SELECT Id FROM Award__c];
        for (Award__c insertedAward : insertedAwards) {
            insertedAward.Status__c = AwardConstants.AWARD_STATUS_SUBMITTED;
            insertedAward.Bypass_Validation__c = true;
            update insertedAward;
        }
        test.stopTest();
    }
}