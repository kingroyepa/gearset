/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_190063savePDFTest
*    Test Class for ORDGAS_190063savePDF
**/
@isTest
Public Class ORDGAS_190063savePDFTest{
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
        account acc= new account();
        acc.name = 'Conde Nast';
        acc.Active__c = TRUE;
        acc.RecordTypeId = recordTypeIdVendor;
        insert acc;
        eOrders__c eorder = new eOrders__c();
        eorder.RecordTypeId = recordTypeIdeOrderAdmin;    
        eorder.Description__c = 'test';
        eorder.Order_Amount__c= 50.0;
        eorder.Status__c  = 'Draft';
        insert eorder; 
            
        Order_Request__C request = [select id, name, Requester_Org__c from order_request__C where recordTypeId= :recordTypeIdOrderRequest limit 1];
        eorder_item__c item = new eorder_item__c(Status__c='Order Delivered',X1900_63__c=true,
                                                 Vendor_Name__c=acc.Id,eorder__c=eorder.Id,recordTypeId=recordTypeIdeOrderItem,order_request__c=request.Id);
        insert item;
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        Apexpages.StandardController sc = new Apexpages.StandardController(acc);
        ORDGAS_190063savePDF ext = new ORDGAS_190063savePDF(sc);
        ext.saveAttachement();
        ext.organizationName = request.Requester_Org__c;
        ext.getEordersForOrg();
        ext.Cancel();
        ext.redirectToPDFPage();
         
        /*ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'Test ContentVersion File - '; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        //contentVersion.ContentDocumentId = contentVersionId; 
        
          */
        test.StopTest();
        }
    }
    static testMethod void afterUpdate(){
         User u =[select id from user where UserName='GAS5@test.org'];
        system.runas(u){
        test.StartTest();
        account acc= new account();
        acc.name = 'Conde Nast';
        acc.Active__c = TRUE;
        acc.RecordTypeId = recordTypeIdVendor;
        insert acc;
        
        eOrders__c eorder = new eOrders__c();
        eorder.RecordTypeId = recordTypeIdeOrderAdmin;
        eorder.Description__c = 'test';
        eorder.Order_Amount__c= 50.0;
        eorder.Status__c  = 'Draft';
        insert eorder;
        
        ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'Quote_'+acc.Id + '.pdf'; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        insert contentVersion;
        //test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',acc.id);
        Apexpages.StandardController sc = new Apexpages.StandardController(acc);
        ORDGAS_190063savePDF ext = new ORDGAS_190063savePDF(sc);
        ext.saveAttachement();
        ext.getEordersForOrg();
        ext.Cancel();
        ext.redirectToPDFPage();
        test.StopTest();
        }
    }
    static testMethod void negativeTesting(){
         User u =[select id from user where UserName='GAS5@test.org'];
        system.runas(u){
        //test.StartTest();
        account acc= new account();
        acc.name = 'Conde Nast';
        acc.Active__c = TRUE;
        acc.RecordTypeId = recordTypeIdVendor;
        insert acc;
        eOrders__c eorder = new eOrders__c();
       	eorder.RecordTypeId = recordTypeIdeOrderAdmin;
        eorder.Description__c = 'test';
        eorder.Order_Amount__c= 50.0;
        eorder.Status__c  = 'Draft';
        //insert eorder;      
        ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'Quot.pdf'; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        insert contentVersion;
        test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id',null);
        Apexpages.StandardController sc = new Apexpages.StandardController(acc);
        ORDGAS_190063savePDF ext = new ORDGAS_190063savePDF(sc);
        ext.saveAttachement();
        ext.getEordersForOrg();
        ext.Cancel();
        ext.redirectToPDFPage();
        test.StopTest();
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
        system.runas(u){
            account a = new account();
            a.Name='OEI';
            insert a;
            Order_Request__c request =new Order_Request__c();
            request.Stage__c = 'New Order';
            request.RecordTypeId=recordTypeIdOrderRequest;
            insert request;
        }
    }
}