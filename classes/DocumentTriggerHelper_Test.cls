/**
 * Created by justin.dove on 2019-04-25.
 */
@IsTest
public class DocumentTriggerHelper_Test {
    @TestSetup
    public static void setupTestData() {
        Account hrOrg = AwardTestUtilities.createOrganization('ORD-OARS');
        insert hrOrg;

        Document__c controlBudget = AwardTestUtilities.createBudget(hrOrg, 10000);
        controlBudget.RecordTypeId = AwardConstants.AWARD_BUDGETCONTROL_RECORDTYPEID;
        controlBudget.Award_S_Award_Budget__c = 5000;
        controlBudget.Award_Title_42_SL_ST_Budget__c = 5000;
        insert controlBudget;
    }

    @IsTest
    public static void testBudgetControls() {
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];
        Document__c controlBudget = [SELECT Id FROM Document__c LIMIT 1];

        Document__c firstBudget = AwardTestUtilities.createBudget(hrOrg, 5000);
        firstBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        firstBudget.Parent_Budget__c = controlBudget.Id;
        firstBudget.Award_S_Award_Budget__c = 3000;
        firstBudget.Award_Title_42_SL_ST_Budget__c = 0;

        Document__c secondBudget = AwardTestUtilities.createBudget(hrOrg, 6000);
        secondBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        secondBudget.Parent_Budget__c = controlBudget.Id;
        secondBudget.Award_S_Award_Budget__c = 6000;
        secondBudget.Award_Title_42_SL_ST_Budget__c = 0;

        test.startTest();
        System.debug('>>>> Inserting first budget.');
        insert firstBudget;

        try {
            System.debug('>>>> Inserting second budget.');
            insert secondBudget;
            System.assert(false, 'Should have caught an exception here.');
        } catch(Exception e) {
            System.debug('>>>>> Error message: ' + e.getMessage());
        }

        secondBudget.Award_S_Award_Budget__c = 0;
        secondBudget.Award_Title_42_SL_ST_Budget__c = 6000;

        try {
            System.debug('>>>> Re-attempt inserting second budget.');
            insert secondBudget;
            System.assert(false, 'Should have caught another exception here.');
        } catch(Exception e) {
            System.debug('>>>>> Error message: ' + e.getMessage());
        }

        secondBudget.Award_Title_42_SL_ST_Budget__c = 1000;
        insert secondBudget;
        test.stopTest();
    }

    @IsTest
    public static void testFirstBudgetInserts() {
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];
        Document__c controlBudget = [SELECT Id FROM Document__c LIMIT 1];

        Document__c firstBudget = AwardTestUtilities.createBudget(hrOrg, 8000);
        firstBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        firstBudget.Parent_Budget__c = controlBudget.Id;
        firstBudget.Award_S_Award_Budget__c = 8000;
        firstBudget.Award_Title_42_SL_ST_Budget__c = 0;

        Document__c secondBudget = AwardTestUtilities.createBudget(hrOrg, 8000);
        secondBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        secondBudget.Parent_Budget__c = controlBudget.Id;
        secondBudget.Award_S_Award_Budget__c = 0;
        secondBudget.Award_Title_42_SL_ST_Budget__c = 8000;

        test.startTest();
        try {
            insert firstBudget;
            System.assert(false, 'Should have caught an exception here.');
        } catch(Exception e) {
            System.debug('>>>>> Error message: ' + e.getMessage());
        }

        try {
            insert secondBudget;
            System.assert(false, 'Should have caught an exception here.');
        } catch(Exception e) {
            System.debug('>>>>> Error message: ' + e.getMessage());
        }
        test.stopTest();
    }

    @IsTest
    public static void testMultipleBudgetInserts() {
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];
        Document__c controlBudget = [SELECT Id FROM Document__c LIMIT 1];

        Account secondHrOrg = AwardTestUtilities.createOrganization('ORD-OARS-EMD');
        insert secondHrOrg;

        Document__c secondControlBudget = AwardTestUtilities.createBudget(secondHrOrg, 10000);
        secondControlBudget.RecordTypeId = AwardConstants.AWARD_BUDGETCONTROL_RECORDTYPEID;
        secondControlBudget.Award_S_Award_Budget__c = 5000;
        secondControlBudget.Award_Title_42_SL_ST_Budget__c = 5000;
        insert secondControlBudget;

        Document__c firstBudget = AwardTestUtilities.createBudget(secondHrOrg, 5000);
        firstBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        firstBudget.Parent_Budget__c = secondControlBudget.Id;
        firstBudget.Award_S_Award_Budget__c = 3000;
        firstBudget.Award_Title_42_SL_ST_Budget__c = 0;

        Document__c secondBudget = AwardTestUtilities.createBudget(secondHrOrg, 5000);
        secondBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        secondBudget.Parent_Budget__c = secondControlBudget.Id;
        secondBudget.Award_S_Award_Budget__c = 0;
        secondBudget.Award_Title_42_SL_ST_Budget__c = 5000;

        Document__c thirdBudget = AwardTestUtilities.createBudget(hrOrg, 5000);
        firstBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        firstBudget.Parent_Budget__c = secondControlBudget.Id;
        firstBudget.Award_S_Award_Budget__c = 3000;
        firstBudget.Award_Title_42_SL_ST_Budget__c = 0;

        test.startTest();
        List<Document__c> budgets = new List<Document__c>{firstBudget, secondBudget, thirdBudget};
        insert budgets;
        test.stopTest();
    }

    @IsTest
    public static void testBudgetUpdate() {
        Account hrOrg = [SELECT Id FROM Account LIMIT 1];
        Document__c controlBudget = [SELECT Id FROM Document__c LIMIT 1];

        Document__c firstBudget = AwardTestUtilities.createBudget(hrOrg, 5000);
        firstBudget.RecordTypeId = AwardConstants.AWARD_BUDGET_RECORDTYPEID;
        firstBudget.Parent_Budget__c = controlBudget.Id;
        firstBudget.Award_S_Award_Budget__c = 3000;
        firstBudget.Award_Title_42_SL_ST_Budget__c = 0;
        insert firstBudget;

        Document__c insertedBudget = [SELECT Id FROM Document__c WHERE Id = :firstBudget.Id];

        test.startTest();
        insertedBudget.Award_Title_42_SL_ST_Budget__c = 3000;
        update insertedBudget;
        test.stopTest();
    }
}