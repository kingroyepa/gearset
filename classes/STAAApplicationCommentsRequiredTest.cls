/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 7-May-2018
*    Class Name : STAAAplicationCommentsRequired
*    Test of trigger that requires Comments to be filled in at the time of Approval/Rejection. Then those Comments are inputted into a designated field on the Object
*
**/

@isTest
public class STAAApplicationCommentsRequiredTest

{
   public static Id staaRt = Schema.SObjectType.Cover_Form__c.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
   public static Id staaAuthorRt = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
   public static Id staaPubRt = Schema.SObjectType.Line_Item__C.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
    /*
        For this first test, create an object for approval, then
        simulate rejeting the approval with an added comment for explanation.
        
        The rejection should be processed normally without being interrupted.
    */
    private static testmethod void testRejectionWithComment()
    {
        User u =[select id from user where UserName='STAA21@test.org'];
        Cover_Form__c covF = [select id from cover_form__C where Laboratory_Office_Name__c ='Test' limit 1];
        system.runas(u){
        // Submit Request
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(covF.Id);
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
                system.debug('testRejResult'+testRejResult);
                System.assert(testRejResult.isSuccess());
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
        
        User u =[select id from user where UserName='STAA21@test.org'];
        Cover_Form__c covF = [select id from cover_form__C where Laboratory_Office_Name__c ='Test' limit 1];
        system.runas(u){
        // Submit Request
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(covF.Id);
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
                system.assert(false, 'A rejection with no comment should cause an exception');
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
        When an approval is approved instead of rejected, a comment is not required, 
        mark the approval status as pending, then ensure that this functionality still holds together.
    */
    private static testmethod void testApprovalWithoutComment()
    {
                User u =[select id from user where UserName='STAA21@test.org'];
        Cover_Form__c covF = [select id from cover_form__C where Laboratory_Office_Name__c ='Test' limit 1];
        system.runas(u){
        // Submit Request
        Approval.ProcessSubmitRequest testReq = new Approval.ProcessSubmitRequest();
        testReq.setObjectId(covF.Id);
        Approval.ProcessResult reqResult = Approval.process(testReq);
        // Generate sample work item using utility method.
        Id testWorkItemId = reqResult.getNewWorkitemIds()[0];
        
        // approve the submitted request, without providing a comment.
        Approval.ProcessWorkitemRequest testApp = new Approval.ProcessWorkitemRequest();
        testApp.setComments('');
        testApp.setAction('Approve');
        testApp.setWorkitemId(testWorkItemId);
    
        Test.startTest();        
            try
            {
                Approval.ProcessResult testRejResult =  Approval.process(testApp);
                system.assert(false, 'A approval with no comment should cause an exception');
            }
            catch(DMLException e)
            {
                system.assertEquals('Operation Cancelled: Please provide a comment', 
                                    e.getDmlMessage(0), 
                  'error message should be Operation Cancelled: Please provide a approval reason!'); 
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
        UserName='STAA21@test.org');
        insert u;

        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'STAA_Coordinator_Access'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        // Create Cover Form Record
        Cover_Form__c CForm = new Cover_Form__c();
        CForm.RecordTypeId=staaRt;
        CForm.Status__c='DRAFT';
        CForm.Laboratory_Office_Name__c='Test';
        CForm.Primary_Research_Category__c = 'Ecological Research';
        CForm.Nominating_Official__c = u.Id;
        CForm.STAA_Coordinator__c  = u.Id;
        CForm.Justification_1__c = 'N/A';
        CForm.Justification_2A__c = 'N/A';
        CForm.Justification_2B__c = 'N/A';
        CForm.Justification_2C__c = 'N/A';
        CForm.Justification_2D__c = 'N/A';
        CForm.Justification_2E__c = 'N/A';
        CForm.Justification_3A__c = 'N/A';
        CForm.Justification_3B__c = 'N/A';
        CForm.Eligibility_Criteria_1__c = TRUE;
        CForm.Eligibility_Criteria_2__c = TRUE;
        CForm.Eligibility_Criteria_3__c = TRUE;
        CForm.Eligibility_Criteria_4__c = TRUE;
        CForm.Citation__c = 'Test';
        

        // Create Contact Record
       // Contact con = [Select Id, of_Total_Effort__c, Do_You_have_Record_of_Agree__c,At_Time_Research_Was__c,Seperation_Date__c
                               // from Contact where Cover_Form__c =: CForm.Id];
        Contact con = new Contact();
        con.RecordTypeId=staaAuthorRt;
        con.LastName='test';
        con.Cover_Form__c=CForm.id;
        con.of_Total_Effort__c = 100;
        con.Do_You_have_Record_of_Agree__c = TRUE;
        con.At_Time_Research_Was__c = 'PHS Assigned to EPA';
        con.Seperation_Date__c = System.today();
        
        // Create Publication Record
        Line_Item__c pub = new Line_Item__c();
        pub.RecordTypeId=staaPubRt;
        pub.Publication_Title__c  = '1';
        pub.Publication_Date__c   = Date.newInstance(2018, 12, 9);
        pub.Journal_Publication_Method__c = '1';
        pub.Volume__c = '1';
        pub.Number__c = '1';
        pub.Pages__c = '1';
        pub.Impact_Factor__c = '1';
        pub.Cover_Form__C = CForm.Id;
        

        // Create Publication Attachment Record
        ContentVersion contentVersion_1 = new ContentVersion(
          Title = 'Test',
          PathOnClient = 'Test.jpg',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = true
        );
        
        system.runAs(u){
            insert CForm;
            insert con;
            insert pub;
            insert contentVersion_1;
            ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1]; 
            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = pub.id;
            contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
            contentlink.ShareType = 'V';
            insert contentlink; 
        }
    }
}