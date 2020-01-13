public class EpaOrderTriggerHelper {
    // Record type map for easy identification of DCR record types and Ids
    public static Map<Id, RecordType> dcrEpaOrderRecordTypesByIds = new Map<Id, RecordType>([
            SELECT Id, Name
            FROM RecordType
            WHERE SobjectType = 'EPA_Order__c'
            AND Name IN ('DCR Order')
    ]);

    public static void calculateOrderTotalsOnAgreements(List<EPA_Order__c> orders) {
        for (EPA_Order__c order : orders) {
            List<Id> contractIds = new List<Id>();

            if (String.isNotEmpty(order.Contract_Vehicle2__c) && dcrEpaOrderRecordTypesByIds.containsKey(order.RecordTypeId)) {
                contractIds.add(order.Contract_Vehicle2__c);
            }

            if (!contractIds.isEmpty()) {
                AggregateResult[] queryResults = [
                        SELECT Contract_Vehicle2__c, SUM(Order_Ceiling__c) totalAmount
                        FROM EPA_Order__c
                        WHERE Contract_Vehicle2__c IN :contractIds
                        GROUP BY Contract_Vehicle2__c
                ];

                List<EPA_Agreement__c> contracts = new List<EPA_Agreement__c>();
                for (AggregateResult result : queryResults) {
                    EPA_Agreement__c tempContract = new EPA_Agreement__c();
                    tempContract.Total_Ordered__c = (Decimal) result.get('totalAmount');
                    tempContract.Id = (Id) result.get('Contract_Vehicle2__c');

                    contracts.add(tempContract);
                }

                if (!contracts.isEmpty()) {
                    update contracts;
                }
            }
        }
    }
}