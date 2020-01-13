@isTest(SeeAllData=true)
public class TQBRequestHandler_Test {

    public static string TEST_TRACK = 'Development';
    public static Id loiRt = [select id from recordtype where developerName='Letter_of_Intent_LOI'].Id;
    public static Id candidateRt = [select id from recordtype where developerName='Candidate_Package'].Id;

    //Candidate_Application__c
    @isTest
    public static void testInsertQuestionsToRequest(){
        // Insert a new request.
        // // Mounika Suram 8/10/2018 Updated the profile to System Administrator.
        Profile p = [select id, name from profile where name = 'System Administrator'];                
        User u = new User(FirstName='test', LastName='User', profileID=p.id, Username='test@userdomain.abc', 
                    email='test@userdomain.abc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        
        Candidate_Application__c request1 = new Candidate_Application__c();
        request1.Intended_Track__c = TEST_TRACK;
        request1.First_Line_Supervisor__c = u.Id;
        request1.Second_Line_Supervisor__c = u.Id;
        // Mounika Suram 8/10/2018 Corrected the RecordTypeID
        request1.RecordTypeId = [select id,developerName from RecordType where SobjectType='Candidate_Application__c'  and developername='Letter_of_Intent_LOI'].id;
        system.runas(u) {
            test.StartTest();
            insert request1;
            System.debug('Status ' + request1.Id + ' & Status ' + request1.Intended_Track__c);


            TQBRequestHandler.addRelatedQuestions(new List<Candidate_Application__c>{
                    request1
            });
            TQBRequestHandler.createRequestResponses(null, null);
            // Validate if question responses have been updated with relevant questions.
            List<Question_Response__c> newRecords = [Select Id,Question__c from Question_Response__c where Candidate_Application__r.Id = :request1.Id and Candidate_Application__r.Intended_Track__c = :TEST_TRACK];
            System.debug('newRecords' + newRecords);
            // Mounika Suram 8/10/2018 Added the Status__c to the soql
            List<Questions__c> relatedQuestions = [Select id,Question__c from Questions__c where Status__c = 'Active'and Track__c = :TEST_TRACK]; System.debug('relatedQuestions' + relatedQuestions);
            System.assertEquals(newRecords.size(), relatedQuestions.size());

            // Add Attachment
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'test-' + request1.Id + '.pdf';
            contentVersion.PathOnClient = contentVersion.Title;
            Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
            contentVersion.VersionData = bodyBlob;
            contentVersion.IsMajorVersion = false;
            contentVersion.origin = 'H';
            insert contentVersion;
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :contentVersion.Id];

            ContentDocumentLink contentlink = new ContentDocumentLink();
            contentlink.LinkedEntityId = request1.id;
            contentlink.ShareType = 'V';
            contentlink.ContentDocumentId = testcontent.ContentDocumentId;
            insert contentlink;

            // Submit for approval - with attachment
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(request1.id);
            // Submit on behalf of a specific submitter
            req1.setSubmitterId(u.Id);
            // Submit the approval request for the account
            Approval.ProcessResult result = Approval.process(req1);
            update request1;
            delete contentlink;
            test.StopTest();
        }
    }

    @istest
    public static void testSupervisorTriggers(){
        // TEST 2
        Profile p = [select id, name from profile where name = 'System Administrator'];
        User u = new User(FirstName='test', LastName='User', profileID=p.id, Username='test@userdomain.abc',
                email='test@userdomain.abc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;

        System.debug('Begin Test - Supervisors');
        Candidate_Application__c request2 = new Candidate_Application__c();
        request2.RecordTypeId = candidateRt;
        request2.Intended_Track__c = TEST_TRACK;
        request2.First_Line_Supervisor__c = u.Id;
        //request2.Second_Line_Supervisor__c = u.Id;
        system.runas(u) {
            test.StartTest();
            try{
            insert request2;

            // Submit for approval - with attachment
            Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
            req2.setComments('Submitting request2 for approval.');
            req2.setObjectId(request2.id);
            // Submit on behalf of a specific submitter
            req2.setSubmitterId(u.Id);
            // Submit the approval request for the account
            Approval.ProcessResult result2 = Approval.process(req2);
            update request2;
            } catch (Exception ee){}
            test.StopTest();
        }
    }


    @istest
    public static void testOtherTriggers(){
        // TEST 2
        Profile p = [select id, name from profile where name = 'System Administrator'];
        User u = new User(FirstName='test', LastName='User', profileID=p.id, Username='test@userdomain.abc',
                email='test@userdomain.abc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;

        System.debug('Begin Test - Other');
        Candidate_Application__c request2 = new Candidate_Application__c();
        request2.RecordTypeId = candidateRt;
        request2.Intended_Track__c = TEST_TRACK;
        request2.First_Line_Supervisor__c = u.Id;
        request2.Second_Line_Supervisor__c = u.Id;
        system.runas(u) {
            test.StartTest();
            try {
                insert request2;

                // Submit for approval - with attachment
                Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
                req2.setComments('Submitting request2 for approval.');
                req2.setObjectId(request2.id);
                // Submit on behalf of a specific submitter
                req2.setSubmitterId(u.Id);
                // Submit the approval request for the account
                Approval.ProcessResult result2 = Approval.process(req2);

                update request2;
            } catch (Exception ee){}
            test.StopTest();
        }
    }

}