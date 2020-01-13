//5-17-2018 - Test class edited to no longer user "the current user" as the main user for a record - Trellis Sherman GDIT

@isTest
public class PCformEnterApprovalProcess_Test {
    
    public static testMethod void PCformEnterApprovalProcessTest1()
    {
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
            Supervisor__c = Userinfo.getUserId(),
            Session_Token__c = '123ABC',
            Session_IP__c = '111-111-1111',
            Session_Environment__c = 'chrome',
            Session_Timestamp__c = datetime.now().addMinutes(-1),
            Lan_ID__c = 'thetest'
        );
        
        insert u;
        
        //account creation
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        //contact creation
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.Email = 'Test=User@test.com';
        testContact.LAN_ID__c = 'thetest';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        

        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        //form creation
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = UserInfo.getUserId();
        testForm.Approver_2__c = UserInfo.getUserId();
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Unauthenticated_Owner__c = u.id;
        testForm.Account_Type__c ='CO';
        upsert testForm;
        
        //retrieving one line item record
        Line_Item__c testItem = [select id from Line_Item__c where Related_Form__c =: testForm.id limit 1];
        ContentVersion file = new ContentVersion();
        file.PathOnClient = 'null';
        file.VersionData = Blob.valueOf('Cheese');
        file.Title = 'EPA';
        insert file;
        
        //link the line item record to a file
        ContentDocument doc = [select id from ContentDocument limit 1];        
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = doc.id;
        cdl.LinkedEntityId = testItem.Id;
        cdl.ShareType = 'V';
        upsert cdl;
        
        
        
        Test.startTest();
        
        //submit the record for approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Automatically Submitted');
        req1.setObjectId(testForm.id);
        req1.setProcessDefinitionNameOrId('Purchase_Card_Approval3');
        req1.setSubmitterID(u.Id);
        try
        {
            //try to approve this record
            Approval.ProcessResult result = Approval.process(req1);
            System.assert(false);
        }catch(Exception E)
        {
            
            System.assert(true);
            
        }
        Test.stopTest();
    }
    
    
    public static testMethod void PCformEnterApprovalProcessTest2()
    {
        //create User
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'Test',
            LastName = 'User2',
            Email = 'Test=User2@test.com',
            Username = 'Test=User2@tetest.com',
            CompanyName = 'TEST',
            Title = 'Test',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Supervisor__c = Userinfo.getUserId(),
            Session_Token__c = '123ABC',
            Session_IP__c = '111-111-1111',
            Session_Environment__c = 'chrome',
            Session_Timestamp__c = datetime.now().addMinutes(-1),
            Lan_ID__c = 'thetest'
        );
        
        insert u;
        
        //account creation
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        //contact creation
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.Email = 'Test=User2@test.com';
        testContact.LAN_ID__c = 'thetest';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = UserInfo.getUserId();
        insert testContact;
        
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        //creating the form
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = UserInfo.getUserId();
        testForm.Approver_2__c = UserInfo.getUserId();
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Unauthenticated_Owner__c = u.id;
        testForm.Account_Type__c ='CO';
        upsert testForm;
        
        
        Test.startTest();
        
        //try to submit the record for approval
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Automatically Submitted');
        req1.setObjectId(testForm.id);
        req1.setProcessDefinitionNameOrId('Purchase_Card_Approval3');
        req1.setSubmitterID(u.Id);
        try
        {
            Approval.ProcessResult result = Approval.process(req1);
            system.debug('res: '+result);
            System.assert(false);
        }catch(Exception E)
        {
            System.assert(true);
        }
        Test.stopTest();
    }
}