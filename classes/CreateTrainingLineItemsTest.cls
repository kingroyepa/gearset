@isTest
public with sharing class CreateTrainingLineItemsTest {
    static testMethod void myunit(){
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
        testContact.User__c = u.Id;
        insert testContact;
                
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        //creation of the form
        Forms__c testForm = new Forms__c();
        testForm.RecordTypeId = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('Purchase Card: New Purchase Card').getRecordTypeId();
        testForm.Cardholder_AO_Name__c = testContact.Id;
        testForm.Service_Comp_Date_MM_YYYY__c = '11/2005';
        testForm.Approver_1__c = U.Id;
        testForm.Approver_2__c = U.Id;
        testForm.Monthly_Purchase_Limit__c = 7000.00;
        testForm.Single_Purchase_Limit__c = 3500.00;
        testForm.Account_Type__c ='CO';
        testForm.Unauthenticated_Owner__c = u.id;
        testForm.exists__c=false;
        insert testForm;


        List<Forms__c> formsList = new List<Forms__c>();
        formsList.add(testForm);
        
        Test.StartTest();
        system.runAs(u){
           CreateTrainingLineItems cb = new CreateTrainingLineItems();
            //ID batchprocessid = Database.executeBatch(obj,200);
            //ContactBatch cb = New ContactBatch();

            Database.QueryLocator ql = cb.start(null);
            cb.execute(null,formsList);
            cb.Finish(null);
            Id trainingRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
            cb.createLineItem('CitiManager Training',testForm,trainingRT);

        }
        Test.stopTest();
    }
    
}