/**
 * Test methods for testing the LineItemTriggerHelper class.
 */

@IsTest
public class LineItemTriggerHelper_Test {
    @IsTest
    public static void testLineItemCalculationInsert() {
        Document__c document = new Document__c();
        document.Op_Plan__c = 1000;
        document.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Document - Contract').getRecordTypeId();
        insert document;

        EPA_Agreement__c contract = new EPA_Agreement__c();
        contract.Contract_Ceiling__c = 10000;
        contract.RecordTypeId = Schema.SObjectType.EPA_Agreement__c.getRecordTypeInfosByName().get('DCR - Contract Vehicle').getRecordTypeId();
        insert contract;

        EPA_Order__c order = new EPA_Order__c();
        order.Order_Ceiling__c = 10000;
        order.Contract_Vehicle2__c = contract.Id;
        insert order;

        Line_Item__c lineItem = new Line_Item__c();
        lineItem.DCR_Document__c = document.Id;
        lineItem.Order_Record__c = order.Id;
        lineItem.Vehicle_Record2__c = contract.Id;
        lineItem.RecordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('DCR Contract Line Item').getRecordTypeId();
        lineItem.Amount__c = 500;

        Test.startTest();
        insert lineItem;
        Test.stopTest();

        Document__c updatedDocument = [
                SELECT Id, Line_Item_Total__c
                FROM Document__c
                WHERE Id = :document.Id
        ];

        EPA_Agreement__c updatedContract = [
                SELECT Id, Line_Item_Total__c
                FROM EPA_Agreement__c
                WHERE Id = :contract.Id
        ];

        EPA_Order__c updatedOrder = [
                SELECT Id, Line_Item_Total__c
                FROM EPA_Order__c
                WHERE Id = :order.Id
        ];

        System.assertEquals(lineItem.Amount__c, updatedDocument.Line_Item_Total__c, 'Line Item and Document totals should be the same.');
        System.assertEquals(lineItem.Amount__c, updatedContract.Line_Item_Total__c, 'Line Item and Contract totals should be the same.');
        System.assertEquals(lineItem.Amount__c, updatedOrder.Line_Item_Total__c, 'Line Item and Order totals should be the same.');
    }
    
    @IsTest
    public static void testLineItemCalculationUpdate() {
        Document__c document = new Document__c();
        document.Op_Plan__c = 1000;
        document.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Document - Contract').getRecordTypeId();
        insert document;

        EPA_Agreement__c contract = new EPA_Agreement__c();
        contract.Contract_Ceiling__c = 10000;
        contract.RecordTypeId = Schema.SObjectType.EPA_Agreement__c.getRecordTypeInfosByName().get('DCR - Contract Vehicle').getRecordTypeId();
        insert contract;

        EPA_Order__c order = new EPA_Order__c();
        order.Order_Ceiling__c = 10000;
        order.Contract_Vehicle2__c = contract.Id;
        insert order;

        Line_Item__c lineItem = new Line_Item__c();
        lineItem.DCR_Document__c = document.Id;
        lineItem.Order_Record__c = order.Id;
        lineItem.Vehicle_Record2__c = contract.Id;
        lineItem.RecordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('DCR Contract Line Item').getRecordTypeId();
        lineItem.Amount__c = 500;
        insert lineItem;

        Test.startTest();
        lineItem.Amount__c = 1000;
        update lineItem;
        Test.stopTest();

        Document__c updatedDocument = [
                SELECT Id, Line_Item_Total__c
                FROM Document__c
                WHERE Id = :document.Id
        ];

        EPA_Agreement__c updatedContract = [
                SELECT Id, Line_Item_Total__c
                FROM EPA_Agreement__c
                WHERE Id = :contract.Id
        ];

        EPA_Order__c updatedOrder = [
                SELECT Id, Line_Item_Total__c
                FROM EPA_Order__c
                WHERE Id = :order.Id
        ];

        System.assertEquals(lineItem.Amount__c, updatedDocument.Line_Item_Total__c, 'Line Item and Document totals should be the same.');
        System.assertEquals(lineItem.Amount__c, updatedContract.Line_Item_Total__c, 'Line Item and Contract totals should be the same.');
        System.assertEquals(lineItem.Amount__c, updatedOrder.Line_Item_Total__c, 'Line Item and Order totals should be the same.');
    }
    
    @IsTest
    public static void testLineItemCalculationDelete() {
        Document__c document = new Document__c();
        document.Op_Plan__c = 1000;
        document.RecordTypeId = Schema.SObjectType.Document__c.getRecordTypeInfosByName().get('Document - Contract').getRecordTypeId();
        insert document;

        EPA_Agreement__c contract = new EPA_Agreement__c();
        contract.Contract_Ceiling__c = 10000;
        contract.RecordTypeId = Schema.SObjectType.EPA_Agreement__c.getRecordTypeInfosByName().get('DCR - Contract Vehicle').getRecordTypeId();
        insert contract;

        EPA_Order__c order = new EPA_Order__c();
        order.Order_Ceiling__c = 10000;
        order.Contract_Vehicle2__c = contract.Id;
        insert order;

        Line_Item__c lineItem = new Line_Item__c();
        lineItem.DCR_Document__c = document.Id;
        lineItem.Order_Record__c = order.Id;
        lineItem.Vehicle_Record2__c = contract.Id;
        lineItem.RecordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('DCR Contract Line Item').getRecordTypeId();
        lineItem.Amount__c = 500;
        insert lineItem;
        
        Line_Item__c secondLineItem = new Line_Item__c();
        secondLineItem.DCR_Document__c = document.Id;
        secondLineItem.Order_Record__c = order.Id;
        secondLineItem.Vehicle_Record2__c = contract.Id;
        secondLineItem.RecordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('DCR Contract Line Item').getRecordTypeId();
        secondLineItem.Amount__c = 500;
        insert secondLineItem;

        Test.startTest();
        delete secondLineItem;
        Test.stopTest();

        Document__c updatedDocument = [
                SELECT Id, Line_Item_Total__c
                FROM Document__c
                WHERE Id = :document.Id
        ];

        EPA_Agreement__c updatedContract = [
                SELECT Id, Line_Item_Total__c
                FROM EPA_Agreement__c
                WHERE Id = :contract.Id
        ];

        EPA_Order__c updatedOrder = [
                SELECT Id, Line_Item_Total__c
                FROM EPA_Order__c
                WHERE Id = :order.Id
        ];

        System.assertEquals(lineItem.Amount__c, updatedDocument.Line_Item_Total__c, 'Line Item and Document totals should be the same.');
        System.assertEquals(lineItem.Amount__c, updatedContract.Line_Item_Total__c, 'Line Item and Contract totals should be the same.');
        System.assertEquals(lineItem.Amount__c, updatedOrder.Line_Item_Total__c, 'Line Item and Order totals should be the same.');
    }
    
}