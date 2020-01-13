/**
 * Class and methods for instantiating the BudgetPlanner Visualforce page.
 */

public with sharing class BudgetPlannerController {
    public List<Document__c> budgetList {get; set;}

    public BudgetPlannerController() {
        if (this.budgetList == null) {
            this.budgetList = getBudgets();
        }
    } 

    @AuraEnabled
    public static List<Document__c> getBudgets() {
        List<Document__c> budgets = [
                SELECT Id, Name, Award_Total_Budget__c, Award_Budget_Org__r.Name, Award_S_Award_Budget__c, Award_Title_42_SL_ST_Budget__c,
                        Award_S_Award_Budget_Allocated__c, Award_Title_42_SL_ST_Budget_Allocated__c
                FROM Document__c
                WHERE RecordType.Name = 'Document - Award Budget'
                AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                ORDER BY Award_Budget_Org__r.Name ASC
        ];

        return budgets;
    }

    @AuraEnabled
    public static void saveBudgets(List<Document__c> budgets) {
        if(!budgets.isEmpty()) {
            update budgets;
        }
    }

    @AuraEnabled
    public static Id getARTTAdjustmentRecordTypeId() {
        return Schema.SObjectType.Adjustment__c.getRecordTypeInfosByName().get('ARTT Budget Adjustment').getRecordTypeId();
    }
}