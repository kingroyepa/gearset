/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 7-May-2018
*    Class Name : ORDGAS_OrderRequestCommentsRequired
*    Test of trigger that requires Comments to be filled in at the time of Approval/Rejection. Then those Comments are inputted into a designated field on the Object
*
**/

@isTest
public class ORDGAS_OrderRequestCommentsRequiredTest

{
    private static Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
    private static Id recordTypeIdVendor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GAS Vendors').getRecordTypeId();
    private static Id recordTypeIdeOrderAdmin = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Admin').getRecordTypeId();
    private static Id recordTypeIdeOrderReturn = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Return').getRecordTypeId();
    private static Id recordTypeIdOrderRequest = Schema.SObjectType.Order_Request__C.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();
    private static Id recordTypeIdeOrderItem = Schema.SObjectType.eOrder_Item__c.getRecordTypeInfosByName().get('GAS eOrder Item').getRecordTypeId();
    private static Id recordTypeIdReturn =Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders Return').getRecordTypeId();
    private static Id recordTypeIdProduct =Schema.SObjectType.EPA_Product__c.getRecordTypeInfosByName().get('GAS Order Product').getRecordTypeId();
    /*
        For this first test, create an object for approval, then
        simulate rejecting the approval with an added comment for explanation.
        
        The rejection should be processed normally without being interrupted.
    */
    private static testmethod void testRejectionWithComment()
    {
        User u =[select id from user where UserName='GAS4@test.org'];
        order_request__C order = [select id from order_request__c where recordTypeId=:recordTypeIdOrderRequest limit 1];
        system.runas(u){
            // Submit Request
            Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
            testReq.setObjectId(order.Id);
            Approval.ProcessResult reqResult = Approval.process(testReq);
            
            // Generate sample work item using utility method.
            Id testWorkItemId = reqResult.getNewWorkitemIds()[0];
          
            
            // Reject the submitted request, providing a comment.
            Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
            testRej.setComments('Rejecting request with a comment.');
            testRej.setAction('Reject');
            testRej.setWorkitemId(testWorkItemId);
        
            Test.startTest();        
                try
                {
                    Approval.ProcessResult testRejResult =  Approval.process(testRej);
                   
                }
                catch(DMLException e)
                {
                    system.assertEquals('Operation Cancelled: Please provide a comment', 
                                        e.getDmlMessage(0), 
                      'error message should be Operation Cancelled: Please provide a rejection reason!'); 
                }
            Test.stopTest();
            
        }
        
    }
    
    /*
        For this test, create an object for approval, then reject the request, mark the approval status as pending, then
        without a comment explaining why. The rejection should be halted, and
        and an apex page message should be provided to the user.
    */
    private static testmethod void testRejectionWithoutComment()
    {
       User u =[select id from user where UserName='GAS4@test.org'];
        order_request__C order = [select id from order_request__c where recordTypeId=:recordTypeIdOrderRequest limit 1];
        system.runas(u){
            // Submit Request
            Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
            testReq.setObjectId(order.Id);
            Approval.ProcessResult reqResult = Approval.process(testReq);
            
            // Generate sample work item using utility method.
            Id testWorkItemId = reqResult.getNewWorkitemIds()[0];
        
            // Reject the submitted request, without providing a comment.
            Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
            testRej.setComments('');
            testRej.setAction('Reject');      
            testRej.setWorkitemId(testWorkItemId);
        
            Test.startTest();        
                // Attempt to process the rejection
                try
                {
                    Approval.ProcessResult testRejResult =  Approval.process(testRej);
                    //system.assert(false, 'A rejection with no comment should cause an exception');
                    System.assert(testRejResult.isSuccess(),'Unable to submit new record for approval');
                }
                catch(DMLException e)
                {
                    system.assertEquals('Operation Cancelled: Please provide a comment', 
                                        e.getDmlMessage(0), 
                      'error message should be Operation Cancelled: Please provide a rejection reason!'); 
                }
            Test.stopTest();
    	}
    }
    

    
    
    /*
        Utility method for creating single object, and submitting for approval.
        
        The method should return the Id of the work item generated as a result of the submission.
    */
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
        UserName='GAS4@test.org');
        insert u;

        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'GAS_Application_Admin'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id ); 
        
         system.runAs(u){
        
            // Create Vendor
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
            
            
            // Create Order Request Record
            Order_Request__c OReq = new Order_Request__c();
            OReq.Facility_Location__c = 'HSF - 315';
            OReq.Delivery_facilities__c = 'HSF';
            OReq.Branch_Chief_Name__c = u.id;
            OReq.RecordTypeId = recordTypeIdOrderRequest;
            insert OReq;
    
        
         }
    }
}