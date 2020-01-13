//5-17-2018 - Test class edited to no longer user "the current user" as the main user for a record - Trellis Sherman GDIT

@isTest
public class tctoCreateLineItems_Test {
    
    public static testMethod void createTimeEntriesTest()
    {
        //Vars
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        List<Line_Item__c> timeEntryResults;
        
        //create User
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'Test=User@test.com',
            Username = 'Test=User@tetest.com',
            CompanyName = 'TEST',
            Title = 'Test',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Supervisor__c = currentUserID,
            Session_Token__c = '123ABC',
            Session_IP__c = '111-111-1111',
            Session_Environment__c = 'chrome',
            Session_Timestamp__c = datetime.now().addMinutes(-1),
            Lan_ID__c = 'thetest'
        );
        
        insert u;
        
        //update test user information
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        //create contact record for test user
        contact c = new contact(FirstName='Test', LastName='User', Lan_ID__c = 'thetest');
        insert c;
        
        Test.startTest();
        
        //Filling Out TCTO Form to create Time Entries
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testform.Hidden_Able_to_Create_Time_Entries__c = true;
        
        upsert testForm;
        
        //There should only be one form with 5 days
        updatedForm = [select id, recordtypeID,Number_of_Days_TCTO__c,Start_Date_TCTO__c,End_Date_TCTO__c from FORMS__C where ID =: testForm.Id limit 1];
        System.assertEquals(5, updatedForm.Number_of_Days_TCTO__c);
        
        //There shoudld be five Time Entries forms related to the form
        //
        //03-23-18, This is commented out since the process builder will be inactive when migrated, uncomment the below code once the process builder is active
        //
       // timeEntryResults = [select id, Related_Form__c from Line_Item__c where Related_Form__c =: updatedForm.Id];
       // System.assertEquals(5, timeEntryResults.size());
        
        Test.stopTest();
        
    }
}