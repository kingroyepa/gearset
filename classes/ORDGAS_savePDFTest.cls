/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_savePDFTest
*    Test Class for ORDGAS_savePDF
**/
@isTest
Public Class ORDGAS_savePDFTest{
    private static Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
    private static Id recordTypeIdVendor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GAS Vendors').getRecordTypeId();
    private static Id recordTypeIdeOrderAdmin = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Admin').getRecordTypeId();
    private static Id recordTypeIdeOrderReturn = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Return').getRecordTypeId();
    private static Id recordTypeIdOrderRequest = Schema.SObjectType.Order_Request__C.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();
    private static Id recordTypeIdeOrderItem = Schema.SObjectType.eOrder_Item__c.getRecordTypeInfosByName().get('GAS eOrder Item').getRecordTypeId();
    private static Id recordTypeIdReturn =Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders Return').getRecordTypeId();
    private static Id recordTypeIdProduct =Schema.SObjectType.EPA_Product__c.getRecordTypeInfosByName().get('GAS Order Product').getRecordTypeId();
    static testMethod void afterInsert(){
        User u =[select id from user where UserName='GAS5@test.org'];
        system.runas(u){
            test.StartTest();
            eOrders__c eorder = new eOrders__c();
            eorder.RecordTypeId=recordTypeIdeOrderAdmin;
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Draft';
            insert eorder;      
            ApexPages.CurrentPage().getParameters().put('id',eorder.id);
            Apexpages.StandardController sc = new Apexpages.StandardController(eorder);
            ORDGAS_savePDF ext = new ORDGAS_savePDF(sc);
            ext.saveAttachement();
             
            /*ContentVersion contentVersion = new ContentVersion(); 
            contentVersion.Title = 'Test ContentVersion File - '; 
            contentVersion.PathOnClient = contentVersion.Title; 
            Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
            contentVersion.VersionData = bodyBlob; 
            contentVersion.IsMajorVersion = false;
            contentVersion.origin = 'H';
            //contentVersion.ContentDocumentId = contentVersionId; 
            
              */
        }
    }
    static testMethod void afterUpdate(){
         User u =[select id from user where UserName='GAS5@test.org'];
        system.runas(u){
        eOrders__c eorder = new eOrders__c();
        eorder.RecordTypeId=recordTypeIdeOrderAdmin;
        eorder.Description__c = 'test';
        eorder.Order_Amount__c= 50.0;
        eorder.Status__c  = 'Draft';
        insert eorder;      
        ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'Quote_'+eorder.Id + '.pdf'; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        insert contentVersion;
        test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',eorder.id);
        Apexpages.StandardController sc = new Apexpages.StandardController(eorder);
        ORDGAS_savePDF ext = new ORDGAS_savePDF(sc);
        ext.saveAttachement();
        ext.redirectToPDFPage();
        }
    }
    static testMethod void negativeTesting(){
        User u =[select id from user where UserName='GAS5@test.org'];
        system.runas(u){
        eOrders__c eorder = new eOrders__c();
        eorder.RecordTypeId=recordTypeIdeOrderAdmin;
        eorder.Description__c = 'test';
        eorder.Order_Amount__c= 50.0;
        eorder.Status__c  = 'Draft';
        insert eorder;
       eOrders__c eorder1 = [select id, name,RecordTypeId,Description__c,Order_Amount__c,Status__c, order_number__c from eOrders__c where id =:eorder.Id];
        ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'Quot.pdf'; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        insert contentVersion;
        test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',eorder1.id);
        Apexpages.StandardController sc = new Apexpages.StandardController(eorder1);
        ORDGAS_savePDF ext = new ORDGAS_savePDF(sc);
        ext.saveAttachement();
        ext.redirectToPDFPage();
        }
    }
      @TestSetup
    private static void setup()
    {
        // Create a sample form statement object and then submit it for approval.
            
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		
        // Create User Record
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='GAS5@test.org');
        insert u;

        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'GAS_Application_Admin'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
    }
}