/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 10-August-2018
*    Class Name : ORDGAS_OrderRequest_TotalsTest
*    Test Class for ORDGAS_OrderRequest_Totals
**/

@isTest
Public Class ORDGAS_OrderRequest_TotalsTest{
	 private static Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
    private static Id recordTypeIdVendor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GAS Vendors').getRecordTypeId();
    private static Id recordTypeIdeOrderAdmin = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Admin').getRecordTypeId();
    private static Id recordTypeIdeOrderReturn = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Return').getRecordTypeId();
    private static Id recordTypeIdOrderRequest = Schema.SObjectType.Order_Request__C.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();
    private static Id recordTypeIdeOrderItem = Schema.SObjectType.eOrder_Item__c.getRecordTypeInfosByName().get('GAS eOrder Item').getRecordTypeId();
    private static Id recordTypeIdReturn =Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders Return').getRecordTypeId();
    private static Id recordTypeIdProduct =Schema.SObjectType.EPA_Product__c.getRecordTypeInfosByName().get('GAS Order Product').getRecordTypeId();
    
    static testMethod void afterUpdateTrigger(){
       
        
        User u =[select id from user where UserName='GAS3@test.org'];
        system.runAs(u){
            //Create Gas Organization
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
            
            //Create Product
            EPA_Product__c product =new EPA_Product__c ();
            product.recordTypeId =recordTypeIdProduct;
            product.Product_Name__c = 'test';
            product.Product_Code__c = 'TT';
            product.List_Price__c = 5.00;
            product.Active__c = TRUE;
            product.Vendor__c = acc.id;
            insert Product;
            
            //Create Order Request
            Order_Request__c orderreq = new Order_Request__c();
            orderreq.RecordTypeId = recordTypeIdOrderRequest;
            orderreq.Delivery_facilities__c = 'HSF';
            orderreq.Facility_Location__c = 'HSF - 209';
            orderreq.Delivery_Date__c = Date.newInstance(2019, 5, 22);
            orderreq.Branch_Chief_Name__c = u.id;
            insert orderreq;
            
            //Create eOrder Item
            eOrder_Item__c item = new eOrder_Item__c ();
           	item.recordTypeId =recordTypeIdeOrderItem;
            item.Product__c = product.Id;
            item.Order_Request__c = orderreq.id;
            item.Quantity__c = 4.0;
            Insert item;
            
            //Update Order Request
            orderreq.Stage__c  = 'Request Approved';
            
            test.StartTest();
            update orderreq;
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
        CompanyName='OEI',Department='OEI',
        TimeZoneSidKey='America/Los_Angeles',
        UserName='GAS3@test.org');
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