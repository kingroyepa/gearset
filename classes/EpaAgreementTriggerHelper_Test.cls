@IsTest
public with sharing class EpaAgreementTriggerHelper_Test {

    @IsTest
    public static void calculateMasterContractTotals() {
        EPA_Agreement__c masterContract = new EPA_Agreement__c();
        masterContract.Contract_Ceiling__c = 100000;
        masterContract.RecordTypeId = Schema.SObjectType.EPA_Agreement__c.getRecordTypeInfosByName().get('DCR - Contract Vehicle').getRecordTypeId();
        insert masterContract;

        EPA_Agreement__c contract = new EPA_Agreement__c();
        contract.Contract_Ceiling__c = 10000;
        contract.Master_Contract__c = masterContract.Id;
        contract.RecordTypeId = Schema.SObjectType.EPA_Agreement__c.getRecordTypeInfosByName().get('DCR - Contract Vehicle Funding Period').getRecordTypeId();
        contract.Total_Ordered__c = 5000;
        insert contract;

        Line_Item__c lineItem = new Line_Item__c();
        lineItem.Vehicle_Record2__c = contract.Id;
        lineItem.RecordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('DCR Contract Line Item').getRecordTypeId();
        lineItem.Amount__c = 500;

        Test.startTest();
        insert lineItem;
        Test.stopTest();

        EPA_Agreement__c updatedMasterContract = [
                SELECT Id, Line_Item_Total__c, Total_Ordered__c
                FROM EPA_Agreement__c
                WHERE Id = :masterContract.Id
                LIMIT 1
        ];

        System.assertEquals(lineItem.Amount__c, updatedMasterContract.Line_Item_Total__c);
        System.assertEquals(contract.Total_Ordered__c, updatedMasterContract.Total_Ordered__c);
    }
}