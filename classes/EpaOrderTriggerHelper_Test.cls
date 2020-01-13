@IsTest
public class EpaOrderTriggerHelper_Test {
    @IsTest
    public static void testOrderCalculations() {
        EPA_Agreement__c contract = new EPA_Agreement__c();
        contract.Contract_Ceiling__c = 100000;
        contract.RecordTypeId = Schema.SObjectType.EPA_Agreement__c.getRecordTypeInfosByName().get('DCR - Contract Vehicle').getRecordTypeId();
        insert contract;

        EPA_Order__c order = new EPA_Order__c();
        order.Contract_Vehicle2__c = contract.Id;
        order.RecordTypeId = Schema.SObjectType.EPA_Order__c.getRecordTypeInfosByName().get('DCR Order').getRecordTypeId();
        insert order;

        Test.startTest();
        EPA_Order__c tempOrder = new EPA_Order__c();
        tempOrder.Order_Ceiling__c = 10000;
        update order;
        Test.stopTest();

        EPA_Agreement__c updatedContract = [
                SELECT Id, Total_Ordered__c
                FROM EPA_Agreement__c
                WHERE Id = :contract.Id
                LIMIT 1
        ];

        System.assertEquals(order.Order_Ceiling__c, updatedContract.Total_Ordered__c);
    }

}