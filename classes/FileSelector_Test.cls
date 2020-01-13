@IsTest
private class FileSelector_Test {
    public static Id fileSelectorRt = Schema.SObjectType.Metadata__c.getRecordTypeInfosByName().get('File Selector').getRecordTypeId();
    public static string TEST_TRACK = 'Development';


    @IsTest
    static void testBehavior() {

        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'test2345', Email='standarduser@testorg.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId = p.Id,
                TimeZoneSidKey='America/Los_Angeles',
                UserName='test72547@test.org');
        insert u;

        List<String> sObj = new List<String>();
        sObj.add('Candidate_Application__c');


        Candidate_Application__c request = new Candidate_Application__c();
        request.Intended_Track__c = TEST_TRACK;
        request.First_Line_Supervisor__c = u.Id;
        request.Second_Line_Supervisor__c = u.Id;
        // Mounika Suram 8/10/2018 Corrected the RecordTypeID
        request.RecordTypeId = [select id,developerName from RecordType where SobjectType='Candidate_Application__c'  and developername='Letter_of_Intent_LOI'].id;
        insert request;
        System.debug('Status ' + request.Id + ' & Status '+ request.Intended_Track__c);

        TQBRequestHandler.addRelatedQuestions(new List<Candidate_Application__c>{request});
        //TQBRequestHandler.createRequestResponses(null,null);
        // Validate if questoin responses have been updated with relavent questions.
        List<Question_Response__c> newRecords = [Select Id,Question__c from Question_Response__c where Candidate_Application__r.Id =:request.Id and Candidate_Application__r.Intended_Track__c=:TEST_TRACK ];
        System.debug('newRecords'+newRecords);
        // Mounika Suram 8/10/2018 Added the Status__c to the soql
        List<Questions__c> relatedQuestions = [Select id,Question__c from Questions__c where Status__c = 'Active'and Track__c =:TEST_TRACK];        System.debug('relatedQuestions'+relatedQuestions);
        System.assertEquals(newRecords.size(),relatedQuestions.size());


        List<Id> mdList = new List<Id>();
        mdList.add(request.id);

        Metadata__c c = new Metadata__c();
            c.RecordTypeId = fileSelectorRt;
            c.Parent__c = 'Test';
            c.Filename__c = 'Test.pdf';
            c.Name = 'Test';
            c.Original_SF_ID__c = '1234';
            insert c;

        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'test-'+request.Id + '.pdf';
        contentVersion.PathOnClient = contentVersion.Title;
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob;
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        //content.LinkedEntityId=sub.id;
        insert contentVersion;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=request.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: contentVersion.id].contentdocumentid;
        contentlink.ShareType = 'V';
        //test.starttest();
        //system.runAs(u) {

            insert contentlink;

            FileSelector_Controller.getAttachedFiles(mdList);
            FileSelector_Controller.getAttachedFiles2(mdList,sObj);
            String j = '["'+ contentlink.contentdocumentid +'"]';
            FileSelector_Controller.saveFileList(j, 'Test__c','Test');

        //}
        //test.StopTest();

        FileSelector_Controller.getPreselectedFiles(mdList);
        FileSelector_Controller.resetListAction(u.Id);



    }


}