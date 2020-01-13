/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_CylinderTotalsTest
*    Test Class for ORDGAS_CylinderTotals
**/

@isTest
public class ORDGAS_CylinderTotalsTest{
    private static Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
    private static Id recordTypeIdVendor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GAS Vendors').getRecordTypeId();
    private static Id recordTypeIdeOrderAdmin = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Admin').getRecordTypeId();
    private static Id recordTypeIdOrderRequest = Schema.SObjectType.Order_Request__C.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();
    private static Id recordTypeIdeOrderItem = Schema.SObjectType.eOrder_Item__c.getRecordTypeInfosByName().get('GAS eOrder Item').getRecordTypeId();
    static testMethod void PositiveTests(){
        User u =[select id from user where UserName='GAS1@test.org'];
        system.runas(u){
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
            Order_Request__c request =new Order_Request__c();
            request.Stage__c = 'New Order';
            request.RecordTypeId=recordTypeIdOrderRequest;
            insert request;
            eOrders__c eorder = new eOrders__c();
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Draft';
            eorder.Total_Quantity__c = 1.0;
            eorder.RecordTypeId = recordTypeIdeOrderAdmin;
            insert eorder;
            eOrder_Item__c item = new eOrder_Item__c ();
            //item.Product__c = product.Id;
            item.Quantity__c = 1.0;
            item.Status__c = 'Added to Order';
            item.eOrder__c  = eorder.Id;
            item.Order_Request__c = request.id;
            item.RecordTypeId = recordTypeIdeOrderItem;
            //item.Total_Price__c = 1000.0;
            Insert item;
            Line_Item__c lineItem = new Line_Item__c();
            //lineItem.Product__c = eorderItem.Product__c;
            lineItem.Status__c='Open';
            //lineItem.Item_Price__c = eorderItem.Item_Price__c;
            //lineItem.Order_Request__c = eorderItem.Order_Request__c;
            lineItem.eOrder_Item__c = item.id;
            lineItem.eOrder__c = eOrder.id;
            lineItem.RecordTypeId = recordTypeId;
            insert lineItem;
            lineItem.Serial_Number__c  = '2121214';
            lineItem.Serial_Number_Confirmation__c  = '1214';
            test.StartTest();
            update lineItem;
            test.StopTest();
        }
        
    }
    static testMethod void requestPopulatedTests(){
        User u =[select id from user where UserName='GAS1@test.org'];
        system.runas(u){
            account acc= new account();
            acc.name = 'Conde Nast';
            acc.Active__c = TRUE;
            acc.RecordTypeId = recordTypeIdVendor;
            insert acc;
            Order_Request__c request =new Order_Request__c();
            request.Stage__c = 'New Order';
            request.RecordTypeId=recordTypeIdOrderRequest;
            insert request;
            eOrders__c eorder = new eOrders__c();
            eorder.Description__c = 'test';
            eorder.Order_Amount__c= 50.0;
            eorder.Status__c  = 'Draft';
            eorder.Total_Quantity__c = 2.0;
            eorder.RecordTypeId = recordTypeIdeOrderAdmin;
            insert eorder;
            eOrder_Item__c item = new eOrder_Item__c ();
            item.Quantity__c = 2.0;
            item.Status__c = 'Added to Order';
            item.eOrder__c  = eorder.Id;
            item.Order_Request__c = request.id;
            Insert item;
            Line_Item__c lineItem = new Line_Item__c();
            lineItem.Status__c='Open';
            lineItem.eOrder_Item__c = item.id;
            lineItem.eOrder__c = eOrder.id;
            lineItem.RecordTypeId = recordTypeId;
            insert lineItem;
            lineItem.Serial_Number__c  = '2121214';
            lineItem.Serial_Number_Confirmation__c  = '1214';
            
            Line_Item__c lineItem2 = new Line_Item__c();
            lineItem2.Status__c='Open';
            lineItem2.eOrder_Item__c = item.id;
            lineItem2.eOrder__c = eOrder.id;
            lineItem2.RecordTypeId = recordTypeId;
            insert lineItem2;
            
            test.StartTest();
            update lineItem;
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
        UserName='GAS1@test.org');
        insert u;

        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'GAS_Application_Admin'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
    }
}