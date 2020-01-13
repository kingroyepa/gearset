@isTest(SeeAllData=true)
public class TQB_GeneratePdfControllerTest {
    private static Id recordTypeId = Schema.SObjectType.Candidate_Application__c.getRecordTypeInfosByName().get('Candidate Application').getRecordTypeId();
    public static string TEST_TRACK = 'Development';

    @istest
    static void afterInsert(){
            test.StartTest();
            Profile p = [select id, name from profile where name = 'System Administrator'];
            User u = new User(FirstName='test', LastName='User', profileID=p.id, Username='test@userdomain.abc',
                    email='test@userdomain.abc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;

            Candidate_Application__c request = new Candidate_Application__c();
            request.Intended_Track__c = TEST_TRACK;
            request.First_Line_Supervisor__c = u.Id;
            request.Second_Line_Supervisor__c = u.Id;
            // Mounika Suram 8/10/2018 Corrected the RecordTypeID
            request.RecordTypeId = [select id,developerName from RecordType where SobjectType='Candidate_Application__c'  and developername='Letter_of_Intent_LOI'].id;
            insert request;

            System.debug('Status ' + request.Id + ' & Status '+ request.Intended_Track__c);


            ApexPages.CurrentPage().getParameters().put('id',request.id);
            Apexpages.StandardController sc = new Apexpages.StandardController(request);
            TQB_GeneratePdfController ext = new TQB_GeneratePdfController(sc);
            ext.redirectToPDFPage();
            ext.saveAttachment();
            ext.saveAttachment();
            test.StopTest();
        }

}