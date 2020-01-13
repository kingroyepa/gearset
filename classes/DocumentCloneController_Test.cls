@IsTest
public with sharing class DocumentCloneController_Test {
    @IsTest
    public static void testDocumentClone() {
        Id documentRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Document__c' AND Name = 'Document - Other' LIMIT 1].Id;
        Account account = new Account(Name = 'TestAccount');
        insert account;
        Document__c document = new Document__c(RecordTypeId = documentRecordTypeId);
        insert document;
        Line_Item__c lineItem = new Line_Item__c(DCR_Document__c = document.Id, Amount__c = 500);
        insert lineItem;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(document);
        DocumentCloneController controller = new DocumentCloneController(sc);
        controller.cloneDocument();
        Test.stopTest();

        List<Document__c> insertedDocuments = [SELECT Id FROM Document__c];
        System.assertEquals(2, insertedDocuments.size(), 'Should have 2 documents inserted.');

        List<Line_Item__c> insertedLineItems = [SELECT Id FROM Line_Item__c];
        System.assertEquals(2, insertedLineItems.size(), 'Should have 2 line items inserted.');
    }

    @IsTest
    public static void testFailedDocumentClone() {
        Id documentRecordTypeId = [SELECT Id FROM RecordType WHERE SobjectType = 'Document__c' AND Name = 'Document - Other' LIMIT 1].Id;
        Account account = new Account(Name = 'TestAccount');
        insert account;
        // Not inserting the document so there's no Id to test catching a failure.
        Document__c document = new Document__c(RecordTypeId = documentRecordTypeId);

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(document);
        DocumentCloneController controller = new DocumentCloneController(sc);
        controller.cloneDocument();
        Test.stopTest();
    }
}