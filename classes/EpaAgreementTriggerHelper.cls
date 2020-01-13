public class EpaAgreementTriggerHelper {
    public static Map<Id, RecordType> dcrAgreemenRecordTypesByIds = new Map<Id, RecordType>([
            SELECT Id, Name
            FROM RecordType
            WHERE SobjectType = 'EPA_Agreement__c'
            AND Name IN ('DCR - Contract Vehicle','DCR - Contract Vehicle Funding Period','DCR - Grant','DCR - IA','DCR Contract Line Item')
    ]);

    public static void updateMasterContractLineItemTotal(List<EPA_Agreement__c> contracts) {
        List<Id> masterContractIds = new List<Id>();
        
        for (EPA_Agreement__c contract : contracts) {
            if (String.isNotBlank(contract.Master_Contract__c) && dcrAgreemenRecordTypesByIds.containsKey(contract.RecordTypeId)) {
                masterContractIds.add(contract.Master_Contract__c);
            }
        }
        
        if (!masterContractIds.isEmpty()) {
            List<EPA_Agreement__c> updatedContracts = calculateLineItemTotalsFromContracts(masterContractIds);
            
            update updatedContracts;
        }
    }
    
    private static List<EPA_Agreement__c> calculateLineItemTotalsFromContracts(List<Id> contractIds) {
        List<EPA_Agreement__c> contractsToUpdate = new List<EPA_Agreement__c>();
        
        AggregateResult[] queryResults = [
            SELECT Master_Contract__c, SUM(Line_Item_Total__c) lineItemTotals, SUM(Total_Ordered__c) orderTotals
            FROM EPA_Agreement__c
            WHERE Master_Contract__c IN :contractIds
            GROUP BY Master_Contract__c
        ];
        
        for (AggregateResult result : queryResults) {
            EPA_Agreement__c tempContract = new EPA_Agreement__c();
            tempContract.Id = (Id) result.get('Master_Contract__c');
            tempContract.Line_Item_Total__c = (Decimal) result.get('lineItemTotals');
            tempContract.Total_Ordered__c = (Decimal) result.get('orderTotals');
            
            contractsToUpdate.add(tempContract);
        }
        
        return contractsToUpdate;
    }
}