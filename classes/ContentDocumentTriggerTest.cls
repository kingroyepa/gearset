/**********************************************************************
Name: ContentDocumentTriggerTest()
======================================================
======================================================
Purpose: Tests the ContentDocumentTrigger class.
-------
======================================================
======================================================
History
-------
VERSION 	AUTHOR 	DATE 		DETAIL 				FEATURES/CSR/TTP
1.0 - Mounika Suram 03/14/2019 INITIAL DEVELOPMENT CSR:PCP
***********************************************************************/
@isTest
public class ContentDocumentTriggerTest {
    @isTest static void testDelete(){
        Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
        Line_item__c training = new Line_Item__c();
        training.RecordTypeId = trainingRecordTypeId;
        training.Course_Title__c = 'PCard Agency Supplemental Training';
        insert training;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'test',
            PathOnClient = 'test_contentdocumet.jpg',
            VersionData = Blob.valueOf('Test Content document'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
       
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = training.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        delete documents;
    }
}