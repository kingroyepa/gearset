/**********************************************************************
Name: ContentDocumentLinkTriggerTest()
======================================================
======================================================
Purpose: Tests the ContentDocumentLinkTrigger class.
-------
======================================================
======================================================
History
-------
VERSION 	AUTHOR 	DATE 		DETAIL 				FEATURES/CSR/TTP
1.0 - Mounika Suram 03/13/2019 INITIAL DEVELOPMENT CSR:PCP
***********************************************************************/
@isTest
public class ContentDocumentLinkTriggerTest {
    @isTest static void testInsert(){
        Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
        Line_item__c training = new Line_Item__c();
        training.RecordTypeId = trainingRecordTypeId;
        training.Course_Title__c = 'PCard Agency Supplemental Training';
        insert training;
        ContentVersion contentVersion = new ContentVersion(
            Title = 'test',
            PathOnClient = 'test_contentdocumentlink.jpg',
            VersionData = Blob.valueOf('Test Content document Link'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
       
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = training.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
    }
}