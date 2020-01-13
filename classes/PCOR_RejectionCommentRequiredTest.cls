/**********************************************************************
Name: PCOR_RejectionCommentRequiredTest()
======================================================
======================================================
Purpose:
-------
To test PCOR_RejectionCommentRequired trigger
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0    Mounika Suram 8/2/2018 Initial development  PCOR
  1.0  Mounika Suram 8/6/2018  Updated the test cases   PCOR
  1.0  Mounika Suram 10/7/2018  Updated the test cases   PCOR
**********************************************************************/

@IsTest
private class PCOR_RejectionCommentRequiredTest {

    // get the purchase order request record type
    private static RecordType purchaseOrderRecordType = [select id from RecordType where developername='Purchase_Card_Order_Request'];
    // get the the line items record type
    private static RecordType purchaseItemRecordType = [select id from RecordType where developername='PCOR_Items'];


    
    private static testmethod void testRejectionWithComment()
    {
       
        Id testWorkItemId = generateAndSubmitObject();

        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('Rejecting request with a comment.');
        testRej.setAction  ('Reject');
        testRej.setWorkitemId(testWorkItemId);

        Test.startTest();
        try
        {
            Approval.ProcessResult testRejResult =  Approval.process(testRej);
            System.assert(testRejResult.isSuccess(),'Unable to submit new record for approval');
        }
        catch(DMLException e)
        {
            system.assertEquals('Operation Cancelled: Please provide a rejection reason.',
                    e.getDmlMessage(0),
                    'error message should be Operation Cancelled: Please provide a rejection reason.');
        }
        Test.stopTest();
    }

    
    private static testmethod void testRejectionWithoutComment()
    {
      
        Id testWorkItemId = generateAndSubmitObject();

        Approval.ProcessWorkitemRequest testRej = new Approval.ProcessWorkitemRequest();
        testRej.setComments('');
        testRej.setAction  ('Reject');
        testRej.setWorkitemId(testWorkItemId);

        Test.startTest();
        
        try
        {
            Approval.ProcessResult testRejResult =  Approval.process(testRej);
            //system.assert(false, 'A rejection with no comment should cause an exception');
        }
        catch(DMLException e)
        {
            system.assertEquals('Operation Cancelled: Please provide a rejection reason.',
                    e.getDmlMessage(0),
                    'error message should be Operation Cancelled: Please provide a rejection reason.');
        }
        Test.stopTest();
    }

    
    private static testmethod void testApprovalWithoutComment()
    {
        
        Id testWorkItemId = generateAndSubmitObject();

       
        Approval.ProcessWorkitemRequest testApp = new Approval.ProcessWorkitemRequest();
        testApp.setComments('');
        testApp.setAction('Approve');
        testApp.setWorkitemId(testWorkItemId);
        testApp.setComments('');
        testApp.setAction('Approve');
        testApp.setWorkitemId(testWorkItemId);
        testApp.setComments('');
        testApp.setAction('Approve');
        testApp.setWorkitemId(testWorkItemId);

        Test.startTest();
       
        Approval.ProcessResult testAppResult =  Approval.process(testApp);
        Test.stopTest();

       
        System.assert(testAppResult.isSuccess(),
                'Approvals that do not include comments should still be permitted');
        System.assertEquals('Pending', testAppResult.getInstanceStatus(),
                'All approvals should be successful and result in an instance status of Approved');
    }
    
    private static testmethod void testApprovalWithoutLineItems(){
         User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];

        
        Order_Request__c testOrder = new Order_Request__c();
        testOrder.RecordTypeId= purchaseOrderRecordType.id;
        testOrder.EPA_Store_Stock_Supply__c=true;
        testOrder.Card_Holder__c=u.id;
        testOrder.Approving_Official__c=u.id;
        testOrder.FCO__c=u.id;
        //testOrder.Request_Status__c='Awaiting Funding';
        insert testOrder;
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(testOrder.Id);
        try
        {
         Test.startTest();
        Approval.ProcessResult reqResult = Approval.process(testReq);
        Approval.ProcessWorkitemRequest testapr = new Approval.ProcessWorkitemRequest();
        testapr.setComments('');
        testapr.setAction  ('Approve');
        testapr.setWorkitemId(reqResult.getNewWorkitemIds()[0]);
       
        
            Approval.ProcessResult testappResult =  Approval.process(testapr);
            //system.assert(false, 'A rejection with no comment should cause an exception');
        }
        catch(DMLException e)
        {
            system.assertEquals('Operation Cancelled: Please add items for the purchase order request and try again.',
                    e.getDmlMessage(0),
                    'error message should be Operation Cancelled: Please add items for the purchase order request and try again.');
        }
        Test.stopTest();
        
       
    }

    private static testmethod void testApprovalwithoutFundingItems()
    {
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
        
        Id testWorkItemId = generateAndSubmitObject();

        
        Approval.ProcessWorkitemRequest testReq = new Approval.ProcessWorkitemRequest();
        testReq.setComments('Approving the request.');
        testReq.setAction  ('Approve');
        testReq.setWorkitemId(testWorkItemId);
        testReq.setNextApproverIds(new ID[]{u.id});
        
        Approval.ProcessResult result2 =  Approval.process(testReq);
        
        Approval.ProcessWorkitemRequest testReq1 = new Approval.ProcessWorkitemRequest();
        testReq1.setComments('Approving the request.');
        testReq1.setAction  ('Approve');
        testReq1.setWorkitemId(result2.getNewWorkitemIds()[0]);
        testReq1.setNextApproverIds(new ID[]{u.id});
        
        Approval.ProcessResult result3 =  Approval.process(testReq1);
        
        Approval.ProcessWorkitemRequest testReq2 = new Approval.ProcessWorkitemRequest();
        testReq2.setComments('Approving the request.');
        testReq2.setAction  ('Approve');
        testReq2.setWorkitemId(result3.getNewWorkitemIds()[0]);
        testReq2.setNextApproverIds(new ID[]{u.id});
        
        Test.startTest();
        try
        {
            Approval.ProcessResult result4 =  Approval.process(testReq2);
            system.assert(false, 'A rejection with no comment should cause an exception');
        }
        catch(DMLException e)
        {
            system.assertEquals('Operation Cancelled: Please add atleast one funding item.',
                    e.getDmlMessage(0),
                    'error message should be Operation Cancelled: Please add atleast one funding item.');
        }
        Test.stopTest();
        

    }
    
    private static Id generateAndSubmitObject()
    {
        
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];

        
        Order_Request__c testOrder = new Order_Request__c();
        testOrder.RecordTypeId= purchaseOrderRecordType.id;
        testOrder.Card_Holder__c=u.id;
        testOrder.Approving_Official__c=u.id;
        testOrder.FCO__c=u.id;
        insert testOrder;

        
        Line_Item__c li= new Line_Item__c();
        li.RecordTypeId=purchaseItemRecordType.id;
        li.PCOR_Order_Request__c=testOrder.id;
		
        insert li;
        
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(testOrder.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);

        System.assert(reqResult.isSuccess(),'Unable to submit new order for approval');

        return reqResult.getNewWorkitemIds()[0];
    }
}