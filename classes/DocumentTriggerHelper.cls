public class DocumentTriggerHelper {
    /**
     * Perform necessary budget control operations before a document is updated or inserted. First, must check to make
     * sure the record is an ARTT budget record type. If so, pass those records to other methods to handle specific
     * control operations.
     *
     * @param documentRecords List of document records, unknown if budget records
     */
    public static void doArttBudgetControls(List<Document__c> documentRecords) {
        // List of budget records only, not control records
        List<Document__c> budgetRecords = new List<Document__c>();

        for (Document__c document : documentRecords) {
            if (AwardConstants.AWARD_BUDGET_RECORDTYPEID.equals(document.RecordTypeId)) {
                budgetRecords.add(document);
            }
        }

        if (!budgetRecords.isEmpty()) {
            // call out to budget record controls
            calculateBudgetsAgainstControl(budgetRecords);
        }
    }

    /**
     * For a list of budget records, make sure they don't exceed the budget control amount. This calculation is based on
     * before inserts, so we need to get the total amount of each S and Title 42 budgets and add these new budget amounts
     * to them. If the previous amount associated with the control budget plus the new budgets inserted or updated exceed
     * the total amount listed on the control, then an error is thrown.
     *
     * @param awardBudgets list of budgets that are being inserted or updated
     */
    @TestVisible
    private static void calculateBudgetsAgainstControl(List<Document__c> awardBudgets) {
        // Use boolean to prevent multiple calculations for a single transaction.
        Boolean hasBeenCalculated = false;
        if (!hasBeenCalculated) {
            List<Id> awardBudgetIds = new List<Id>();
            Map<Id, List<Document__c>> budgetsByControlId = new Map<Id, List<Document__c>>();
            Map<Id, Document__c> controlBudgets;
            List<AggregateResult> budgetSums;
            Map<Id, AggregateResult> budgetSumsByControlId;

            for (Document__c budget : awardBudgets) {
                if (String.isNotBlank(budget.Parent_Budget__c) && !budgetsByControlId.containsKey(budget.Parent_Budget__c)) {
                    budgetsByControlId.put(budget.Parent_Budget__c, new List<Document__c>{budget});
                } else if (String.isNotBlank(budget.Parent_Budget__c)){
                    List<Document__c> tempBudgetList = budgetsByControlId.get(budget.Parent_Budget__c);
                    tempBudgetList.add(budget);
                    budgetsByControlId.put(budget.Parent_Budget__c, tempBudgetList);
                }
                awardBudgetIds.add(budget.Id);
            }

            if (!budgetsByControlId.isEmpty()) {
                // Need to get the control budget amounts for comparisons
                controlBudgets = new Map<Id, Document__c>([
                        SELECT Id, Award_S_Award_Budget__c, Award_Title_42_SL_ST_Budget__c, Award_Budget_Org__r.Name
                        FROM Document__c
                        WHERE Id IN :budgetsByControlId.keySet()
                        AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                ]);

                // Need to get the current totals for all budgets with the parent budget equal to the control Id
                budgetSums = [
                        SELECT Parent_Budget__c, SUM(Award_Title_42_SL_ST_Budget__c) title42Sum, SUM(Award_S_Award_Budget__c) sAwardSum
                        FROM Document__c
                        WHERE Parent_Budget__c IN :budgetsByControlId.keySet()
                        AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                        AND Id NOT IN :awardBudgetIds
                        GROUP BY Parent_Budget__c
                ];

                // Put the aggregate result in a map for easier extraction
                if (!budgetSums.isEmpty()) {
                    budgetSumsByControlId = new Map<Id, AggregateResult>();
                    for (AggregateResult result : budgetSums) {
                        budgetSumsByControlId.put((Id) result.get('Parent_Budget__c'), result);
                    }
                }

                // Loop through each control Id, get the new budgets with amounts
                // Add the title 42 and s-control amounts to integers
                // Check to see if the new amounts plus existing amounts are greater than control
                // If so, fire a new award exception
                for (Id controlBudgetId : budgetsByControlId.keySet()) {
                    // Hold the totals for each of the new budgets
                    Decimal budgetTitle42Totals = 0;
                    Decimal budgetSControlTotals = 0;

                    for (Document__c newBudget : budgetsByControlId.get(controlBudgetId)) {
                        if (newBudget.Award_Title_42_SL_ST_Budget__c != null) {
                            budgetTitle42Totals = budgetTitle42Totals + newBudget.Award_Title_42_SL_ST_Budget__c;
                        }
                        if (newBudget.Award_S_Award_Budget__c != null) {
                            budgetSControlTotals = budgetSControlTotals + newBudget.Award_S_Award_Budget__c;
                        }
                    }

                    // Add the S Award and Title 42 Award totals to the current existing total
                    // If greater than the control, throw an error
                    // If the budget sums query returns 0 results, then check the totals vs the control values
                    if (budgetSumsByControlId != null && budgetSumsByControlId.containsKey(controlBudgetId)){
                        if ((Decimal) budgetSumsByControlId.get(controlBudgetId).get('title42Sum') + budgetTitle42Totals > controlBudgets.get(controlBudgetId).Award_Title_42_SL_ST_Budget__c) {
                            throw new AwardException('The total amount of Title 42 awards exceeds the budget amount for ' + controlBudgets.get(controlBudgetId).Award_Budget_Org__r.Name +
                                    '. Please adjust your amounts and try to save again.');
                        }

                        if ((Decimal) budgetSumsByControlId.get(controlBudgetId).get('sAwardSum') + budgetSControlTotals > controlBudgets.get(controlBudgetId).Award_S_Award_Budget__c) {
                            throw new AwardException('The total amount of S Awards exceeds the budget amount for ' + controlBudgets.get(controlBudgetId).Award_Budget_Org__r.Name +
                                    '. Please adjust your amounts and try to save again.');
                        }
                    } else {
                        if (budgetTitle42Totals > controlBudgets.get(controlBudgetId).Award_Title_42_SL_ST_Budget__c) {
                            throw new AwardException('The total amount of Title 42 awards exceeds the budget amount for ' + controlBudgets.get(controlBudgetId).Award_Budget_Org__r.Name +
                                    '. Please adjust your amounts and try to save again.');
                        }

                        if (budgetSControlTotals > controlBudgets.get(controlBudgetId).Award_S_Award_Budget__c) {
                            throw new AwardException('The total amount of S Awards exceeds the budget amount for ' + controlBudgets.get(controlBudgetId).Award_Budget_Org__r.Name +
                                    '. Please adjust your amounts and try to save again.');
                        }
                    }
                }
            }
        }

        hasBeenCalculated = true;
    }

    /**
     * For budgets that have successfully gone through checks, update the parent budgets Title 42 and S-award allocated
     * values.
     *
     * @param budgets list of budgets that have been inserted or updated
     */
    public static void updateControlBudgets(List<Document__c> budgets){
        Boolean hasBeenCalculated = false;

        if (!hasBeenCalculated) {
            Map<Id, List<Document__c>> budgetsByControlId = new Map<Id, List<Document__c>>();
            List<Document__c> controlBudgetUpdateList = new List<Document__c>();
            List<Id> awardBudgetIds = new List<Id>();
            List<AggregateResult> budgetSums;
            Map<Id, AggregateResult> budgetSumsByControlId;

            for (Document__c budget : budgets) {
                System.debug('>>>> Current keys in budgetsByControlId: ' + budgetsByControlId.keySet());
                System.debug('>>>> Current budget info: Id: ' + budget.Id + ', Parent Budget Id: ' + budget.Parent_Budget__c);
                if (String.isNotBlank(budget.Parent_Budget__c) && !budgetsByControlId.containsKey(budget.Parent_Budget__c)) {
                    budgetsByControlId.put(budget.Parent_Budget__c, new List<Document__c>{budget});
                } else if (String.isNotBlank(budget.Parent_Budget__c)){
                    List<Document__c> tempBudgetList = budgetsByControlId.get(budget.Parent_Budget__c);
                    tempBudgetList.add(budget);
                    budgetsByControlId.put(budget.Parent_Budget__c, tempBudgetList);
                }
                awardBudgetIds.add(budget.Id);
            }

            budgetSums = [
                    SELECT Parent_Budget__c, SUM(Award_Title_42_SL_ST_Budget__c) title42Sum, SUM(Award_S_Award_Budget__c) sAwardSum
                    FROM Document__c
                    WHERE Parent_Budget__c IN :budgetsByControlId.keySet()
                    AND Award_Budget_Start_Date__c = THIS_FISCAL_YEAR
                    AND Id NOT IN :awardBudgetIds
                    GROUP BY Parent_Budget__c
            ];

            // Put the aggregate result in a map for easier extraction
            if (!budgetSums.isEmpty()) {
                budgetSumsByControlId = new Map<Id, AggregateResult>();
                for (AggregateResult result : budgetSums) {
                    budgetSumsByControlId.put((Id) result.get('Parent_Budget__c'), result);
                }
            }

            for (Id controlId : budgetsByControlId.keySet()) {
                Decimal title42Sum = 0;
                Decimal sAwardSum = 0;
                for (Document__c budget : budgetsByControlId.get(controlId)) {
                    title42Sum = title42Sum + budget.Award_Title_42_SL_ST_Budget__c;
                    sAwardSum = sAwardSum + budget.Award_S_Award_Budget__c;
                }
                Document__c tempControlBudget = new Document__c();

                tempControlBudget.Id = controlId;
                tempControlBudget.Award_Title_42_SL_ST_Budget_Allocated__c = budgetSumsByControlId == null || !budgetSumsByControlId.containsKey(controlId) ? title42Sum : (Decimal) budgetSumsByControlId.get(controlId).get('title42Sum');
                tempControlBudget.Award_S_Award_Budget_Allocated__c = budgetSumsByControlId == null || !budgetSumsByControlId.containsKey(controlId) ? sAwardSum : (Decimal) budgetSumsByControlId.get(controlId).get('sAwardSum');

                controlBudgetUpdateList.add(tempControlBudget);
            }

            if (!controlBudgetUpdateList.isEmpty()) {
                update controlBudgetUpdateList;
            }

            hasBeenCalculated = true;
        }
    }

    public static void setTotalBudget(List<Document__c> budgets) {
        for (Document__c budget : budgets) {
            Decimal sAwardAmount = budget.Award_S_Award_Budget__c == null ? 0 : budget.Award_S_Award_Budget__c;
            Decimal title42Amount = budget.Award_Title_42_SL_ST_Budget__c == null ? 0 : budget.Award_Title_42_SL_ST_Budget__c;
            budget.Award_Total_Budget__c = sAwardAmount + title42Amount;
        }
    }
}