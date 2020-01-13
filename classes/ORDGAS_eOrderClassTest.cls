/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_eOrderClassTest
*    Test Class for ORDGAS_eOrderClassTest
**/

@isTest
Public Class ORDGAS_eOrderClassTest{
    private static Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
    private static Id recordTypeIdVendor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GAS Vendors').getRecordTypeId();
    private static Id recordTypeIdeOrderAdmin = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Admin').getRecordTypeId();
    private static Id recordTypeIdeOrderReturn = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Return').getRecordTypeId();
    private static Id recordTypeIdOrderRequest = Schema.SObjectType.Order_Request__C.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();
    private static Id recordTypeIdeOrderItem = Schema.SObjectType.eOrder_Item__c.getRecordTypeInfosByName().get('GAS eOrder Item').getRecordTypeId();
    private static Id recordTypeIdReturn =Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders Return').getRecordTypeId();
     private static Id recordTypeIdProduct =Schema.SObjectType.EPA_Product__c.getRecordTypeInfosByName().get('GAS Order Product').getRecordTypeId();
    static testMethod void afterInsert(){
        
        User u =[select id from user where UserName='GAS2@test.org'];
        system.runAs(u){
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
            
            // Mounika Suram 10/15/2018 Updated the test code for the added feature in ORDGAS_eorder
            Order_Request__c order = [select id, Requester_Org__c from order_request__c where recordTypeId = :recordTypeIdOrderRequest order by Name limit 1];
            Account org= [Select id, name from Account where name =:order.Requester_Org__c];
            
            EPA_Product__c product =new EPA_Product__c ();
            product.recordTypeId =recordTypeIdProduct;
            product.Product_Name__c = 'test';
            product.Product_Code__c = 'TT';
            product.List_Price__c = 5.00;
            product.Active__c = TRUE;
            product.Vendor__c = acc.id;
            insert Product;
            
            eOrders__c eorder = new eOrders__c();
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Draft';
            eorder.RecordTypeId = recordTypeIdeOrderAdmin;
            eorder.Vendor_Name__c = acc.Id;
            eorder.Organization_Name__c = org.Id;
            
            eOrder_Item__c item = new eOrder_Item__c ();
            item.recordTypeId =recordTypeIdeOrderItem;
            item.Product__c = product.Id;
            item.Quantity__c = 400.0;
            item.Status__c = 'Request Approved';
            item.product__c = product.Id;
            item.Order_Request__c= order.Id;        
            test.StartTest();
            Insert item;
            insert eorder;
            test.StopTest();
        }
        
    }
    static testMethod void NegativeTest(){
        try {
            map<Id,eOrders__c> eOrderOldMap = new map<Id,eOrders__c> ();
            //id testId = 'Test';
             User u =[select id from user where UserName='GAS2@test.org'];
       			system.runAs(u){
            
                    
                    account acc= new account();
                    acc.name = 'Conde Nast';
                    acc.Active__c = TRUE;
                    acc.RecordTypeId = recordTypeIdVendor;
                    insert acc;
                    account acc1 = new Account(name='Vermonte', Active__C = true,RecordTypeId = recordTypeIdVendor);
                    insert acc1;
                     // Mounika Suram 10/15/2018 Updated the test code for the added feature in ORDGAS_eorder
                    Order_Request__c order = [select id, Requester_Org__c from order_request__c where recordTypeId = :recordTypeIdOrderRequest order by Name limit 1];
                    Account org= [Select id, name from Account where name =:order.Requester_Org__c];
                    
                    EPA_Product__c product =new EPA_Product__c ();
                    product.recordTypeId =recordTypeIdProduct;
                    product.Product_Name__c = 'test';
                    product.Product_Code__c = 'TT';
                    product.List_Price__c = 5.00;
                    product.Active__c = TRUE;
                    product.Vendor__c = acc.Id;
                    insert Product;
                    
                    eOrders__c eorder = new eOrders__c();
                    eorder.Description__c = 'test';
                    eorder.RecordTypeId = recordTypeIdeOrderAdmin;
                    eorder.Order_Amount__c= 50.0;
                    eorder.Status__c  = 'Activated';
                    eorder.Vendor_Name__c = acc1.Id;
                    eorder.Organization_Name__c = acc1.Id;
                    insert eorder;
                    
                    eorders__c eorder1 = new eorders__c();
                    eorder1.Description__c = 'test';
                    eorder1.Order_Amount__c= 50.0;
                    eorder1.Status__c  = 'Activated';
                    eorder.Status__c  = null;
                    update eorder;
                    
                    eOrderOldMap.put(eorder.Id,eorder1);
                    
                    eOrder_Item__c item = new eOrder_Item__c ();
                    //item.Product__c = product.Id;
                    item.recordTypeId =recordTypeIdeOrderItem;
                    item.Quantity__c = 400.0;
                    item.Status__c = 'Added to Order';
                    item.eOrder__c  = eorder.Id;
                    item.product__c = product.Id;
                    item.Order_Request__c= order.Id; 
                    test.StartTest();
                    ORDGAS_eOrderClass.ActivatedStatus(eorder,eOrderOldMap);
                    test.StopTest();
                   }
            }
            Catch(Exception Ex){
                    System.assert(Ex.getMessage().Contains('eOrder cannot be created. The chosen Vendor and Organization has no open Order Requests associated with it'));
                }
         
    	
    }
    static testMethod void afterUpdateTrigger(){
        User u =[select id from user where UserName='GAS2@test.org'];
       		system.runAs(u){
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
            EPA_Product__c product =new EPA_Product__c ();
            product.recordTypeId =recordTypeIdProduct;
            product.Product_Name__c = 'test';
            product.Product_Code__c = 'TT';
            product.List_Price__c = 5.00;
            product.Active__c = TRUE;
            product.Vendor__c = acc.id;
            insert Product;
                
            eOrders__c eorder = new eOrders__c();
            eorder.RecordTypeId = recordTypeIdeOrderAdmin;
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Activated';
            eorder.Vendor_Name__c = acc.Id;
            insert eorder;
                
            eOrder_Item__c item = new eOrder_Item__c ();
          	item.recordTypeId =recordTypeIdeOrderItem;
            item.Product__c = product.Id;
            item.eOrder__c = eorder.id;
            item.Quantity__c = 400.0;
            item.Status__c = 'Order Placed';
            Insert item;
            // Mounika Suram 10/15/2018 Updated the test code for the added feature in ORDGAS_eorder
            eorder.Status__c  = 'Order Placed';
            test.StartTest();
            update eorder;
            test.StopTest();
        }
        
    }
    static testMethod void afterInsertTrigger(){
       User u =[select id from user where UserName='GAS2@test.org'];
       		system.runAs(u){
            
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
            
            // Mounika Suram 10/15/2018 Updated the test code for the added feature in ORDGAS_eorder
            Order_Request__c order = [select id, Requester_Org__c from order_request__c where recordTypeId = :recordTypeIdOrderRequest order by Name limit 1];
            Account org= [Select id, name from Account where name =:order.Requester_Org__c];
            
            EPA_Product__c product =new EPA_Product__c ();
            product.recordTypeId =recordTypeIdProduct;
            product.Product_Name__c = 'test';
            product.Product_Code__c = 'TT';
            product.List_Price__c = 5.00;
            product.Active__c = TRUE;
            product.Vendor__c = acc.id;
            insert Product;
            eOrder_Item__c item = new eOrder_Item__c ();
            item.recordTypeId =recordTypeIdeOrderItem;
            item.Product__c = product.Id;
            item.Quantity__c = 400.0;
            item.Status__c = 'Request Approved';
            //item.eOrder__c = eorder.id; 
            item.Order_Request__c= order.Id;  
            Insert item;
                
            eOrders__c eorder = new eOrders__c();
            eorder.RecordTypeId = recordTypeIdeOrderAdmin;
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Draft';
            eorder.Vendor_Name__c = acc.Id;
            eorder.Organization_Name__c = org.Id;
            insert eorder;
            
            test.StartTest();
            eorder.Status__c  = 'Order Placed';
            update eorder;
            eorder.Status__c  = 'Full Order Received';
            update eorder;
            test.StopTest();
        
    	}
    }
    
    static testMethod void afterInsertReturnTrigger(){
     User u =[select id from user where UserName='GAS2@test.org'];
       		system.runAs(u){                
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
             // Mounika Suram 10/15/2018 Updated the test code for the added feature in ORDGAS_eorder
            Order_Request__c order = [select id, Requester_Org__c from order_request__c where recordTypeId = :recordTypeIdOrderRequest order by Name limit 1];
            Account org= [Select id, name from Account where name =:order.Requester_Org__c];
            
            EPA_Product__c product =new EPA_Product__c ();
            product.recordTypeId =recordTypeIdProduct;
            product.Product_Name__c = 'test';
            product.Product_Code__c = 'TT';
            product.List_Price__c = 5.00;
            product.Active__c = TRUE;
            product.Vendor__c = acc.id;
            insert Product;
            
            eOrders__c eorder = new eOrders__c();
            eorder.RecordTypeId = recordTypeIdeOrderReturn;
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Order Placed';
            eorder.Vendor_Name__c = acc.Id;
            eorder.Organization_Name__c = org.Id;
            
            eOrder_Item__c item = new eOrder_Item__c ();
            item.recordTypeId =recordTypeIdeOrderItem;
            item.Product__c = product.Id;
            item.Quantity__c = 400.0;
            item.Status__c = 'Added to Order';
            item.eOrder__c = eorder.id; 
            item.Order_Request__c= order.Id;   
            
            Line_Item__c  line = new Line_Item__c ();
            line.recordTypeId=recordTypeIdReturn;
            line.Product__c = product.Id;
            line.Quantity__c = 400.0;
            line.Status__c = 'Cylinder Return Request';
            line.eOrder_Return__c = eorder.id; 
            line.Order_Request__c= order.Id; 
            Insert line;
            test.StartTest();
            insert eorder;
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
        UserName='GAS2@test.org');
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