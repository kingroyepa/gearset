//5-17-2018 - Test class edited to no longer user "the current user" as the main user for a record - Trellis Sherman GDIT

@isTest
public class TestPurchaseCardRecordTypeForm {
    @isTest static void TestCreationOfPurchaseCardRecordTypeForm(){
        
        //insert user
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
        
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
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
        
        ID pcPermissionSetId = [select id, label from permissionset where label = 'Purchase Card Team' limit 1].id;
        
        system.runAs(u){
        insert new PermissionSetAssignment(AssigneeId=u.id,PermissionSetID=pcPermissionSetId);
        }
        
        Forms__c myPurchaseCard = new Forms__c();
        myPurchaseCard.Service_Comp_Date_MM_YYYY__c = '12/2003';
        myPurchaseCard.Approver_1__c = u.Id;
        myPurchaseCard.Approver_2__c = u.id;
        myPurchaseCard.Unauthenticated_Owner__c = u.id;
        myPurchaseCard.Account_Type__c = 'COOP';
        myPurchaseCard.Email_Address__c = 'Test=User@test.com';
        myPurchaseCard.Cardholder_AO_Name__c = testContact.Id;
        
        //Trellis 3.6.18
        RecordType RT = [select id, name from recordtype where name like 'Purchase Card:%' limit 1];
        myPurchaseCard.RecordTypeId = RT.Id;
        
        insert myPurchaseCard;
    }
    
    @isTest static void TestCreationOfPurchaseCardRecordTypeFormNoCardHolderChosen(){
        //insert user
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
        
        Account testAccount = new Account(Name='Test Account');
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('General Accounts').getRecordTypeId();
        insert testAccount;
        
        Contact testContact = new Contact();
        testContact.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('EPA Person').getRecordTypeId();
        testContact.Salutation = 'Prof.';
        testContact.LastName = 'Pudding';
        testContact.AccountId = testAccount.Id;
        testContact.User__c = u.Id;
        testContact.Email = 'Test=User2@test.com';
        testContact.LAN_ID__c = 'thetest';
        insert testContact;
       
        
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); 
        
        ID pcPermissionSetId = [select id, label from permissionset where label = 'Purchase Card Team' limit 1].id;
        system.runAs(u){
            insert new PermissionSetAssignment(AssigneeId=u.id,PermissionSetID=pcPermissionSetId);
        }
        
        Forms__c myPurchaseCard = new Forms__c();
        myPurchaseCard.Service_Comp_Date_MM_YYYY__c = '12/2003';
        myPurchaseCard.Approver_1__c = userinfo.getUserId();
        myPurchaseCard.Approver_2__c = userinfo.getUserId();
        myPurchaseCard.Unauthenticated_Owner__c = u.id;
        myPurchaseCard.Account_Type__c = 'COOP';
        myPurchaseCard.Cardholder_AO_Name__c = null;
        myPurchaseCard.Email_Address__c = 'Test=User2@test.com';
        
        //3.6.18 Trellis Sherman
        RecordType RT = [select id, name from recordtype where name like 'Purchase Card:%' limit 1];
        myPurchaseCard.RecordTypeId = RT.Id;
        insert myPurchaseCard;
    }


}