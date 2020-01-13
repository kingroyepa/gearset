//5-17-2018 - Test class edited to no longer user "the current user" as the main user for a record - Trellis Sherman GDIT

/* Author: 			Trellis Sherman
 * Email:  			trellis.sherman@csra.com
 * 
 * Apex Class:		LineItemsGridController
 * 
 * Description: 	A test class to validate the LineItemsGridController;
 * 					The successTest method() is the real test.
 * 					miscTest#1 - #3 are for testing error conditions
 * 
 */
@isTest
public class LineItemsGridController_Test {
    
    
    public static testMethod void successTest()
    {
        //variables
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        LineItemsGridController testClass;
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
        
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
        
        //creation of the form
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        testForm.Approval_Step__c = null;

        
        upsert testForm;
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid'));
        System.currentPageReference().getParameters().put('sid',u.Session_Token__c);
        System.currentPageReference().getParameters().put('formID',testForm.Id);
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '123ABC');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        testClass = new LineItemsGridController();
        testClass.fetchTableData();
        testClass.ValidateOrRedirect();
        testClass.addRow();
        System.assertEquals(6, [select id from Line_Item__c where related_form__c =: testForm.Id].size());
        testClass.lineToDelete = [select id from Line_Item__c where related_form__c =: testForm.Id order by createddate desc limit 1].id;
        testClass.deleteRow();
        System.assertEquals(5, [select id from Line_Item__c where related_form__c =: testForm.Id].size());
        testClass.saveTable();
        
        
        
		//Submitting TCTO Proposed Hours Form For Approval
            
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(testForm.id);
        req1.setSubmitterId(u.Id); 
        req1.setProcessDefinitionNameOrId('TCTO_Request_Proposed_Hours');
        req1.setSkipEntryCriteria(true);
        Approval.ProcessResult result = Approval.process(req1);
        
        System.assert(result.isSuccess());
        System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
        
        //Test readOnly Flag
        testClass.fetchTableData();
        System.assertEquals(true, testClass.readOnlyFlag);
        
        // Approving TCTO Proposed Hours Form For Approval
        List<Id> newWorkItemIds = result.getNewWorkitemIds();
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        Approval.ProcessResult result2 =  Approval.process(req2);
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        System.assertEquals( 'Approved', result2.getInstanceStatus(), 'Instance Status'+result2.getInstanceStatus());
        
        
        //Set up parameters for Earned TCTO Form
        System.currentPageReference().getParameters().put('sid',u.Session_Token__c);
        System.currentPageReference().getParameters().put('formID',testForm.Id);
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '123ABC');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        testClass = new LineItemsGridController();
        testClass.fetchTableData();
        testClass.ValidateOrRedirect();
        testClass.addRow();
        System.assertEquals(6, [select id from Line_Item__c where related_form__c =: testForm.Id].size());
        testClass.lineToDelete = [select id from Line_Item__c where related_form__c =: testForm.Id order by createddate desc limit 1].id;
        testClass.deleteRow();
        System.assertEquals(5, [select id from Line_Item__c where related_form__c =: testForm.Id].size());
        testClass.saveTable();
        testClass.backToPage();
        
        
        
        //Submitting TCTO Form for approval
        
        req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(testForm.id);
        req1.setSubmitterId(u.Id); 
        req1.setProcessDefinitionNameOrId('TCTO_Request_Earned_Hours');
        req1.setSkipEntryCriteria(true);
        result = Approval.process(req1);
        
        System.assert(result.isSuccess());
        System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
        
        // Approving TCTO Form
        newWorkItemIds = result.getNewWorkitemIds();
        req2 = new Approval.ProcessWorkitemRequest();
        req2.setComments('Approving request.');
        req2.setAction('Approve');
        req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req2.setWorkitemId(newWorkItemIds.get(0));
        
        result2 =  Approval.process(req2);
        System.assert(result2.isSuccess(), 'Result Status:'+result2.isSuccess());
        System.assertEquals( 'Approved', result2.getInstanceStatus(), 'Instance Status'+result2.getInstanceStatus());
        Test.stopTest();
    }
    
    
    public static testMethod void miscTest0()
    {        
        //variables
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        LineItemsGridController testClass;
        PageReference testPage;
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
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
        contact c = new contact(FirstName='Test', LastName='User2', Lan_ID__c = 'thetest');
        insert c;
        
        //creation of the form
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;

        
        upsert testForm;
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid'));
        System.currentPageReference().getParameters().put('formID',testForm.Id);
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '123ABC');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        testClass = new LineItemsGridController();
        testClass.form = new Forms__c();
        testClass.addRow();
        testClass.deleteRow();
        testClass.saveTable();
        testClass.saveAndReturn();
        Test.stopTest();
    }
    
    public static testMethod void miscTest1()
    {        
        //variables
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        LineItemsGridController testClass;
        PageReference testPage;
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
        //create User
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'Test',
            LastName = 'User3',
            Email = 'Test=User3@test.com',
            Username = 'Test=User3@tetest.com',
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
        contact c = new contact(FirstName='Test', LastName='User3', Lan_ID__c = 'thetest');
        insert c;
        
        //creation of the form
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;

        
        upsert testForm;
        Test.startTest();
        testPage = Page.LineItemsGrid;
        Test.setCurrentPage(testPage);
        testClass = new LineItemsGridController();
        testClass.ValidateOrRedirect();
        testClass.setApiName();
        testClass.setFields();
        testClass.setNewLineItemRecordType();
        testClass.saveAndReturn();
        Test.stopTest();
    } 
    
    public static testMethod void miscTest2()
    {        
        //variables
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        LineItemsGridController testClass;
        PageReference testPage;
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
        //create User
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'Test',
            LastName = 'User4',
            Email = 'Test=User4@test.com',
            Username = 'Test=User4@tetest.com',
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
        contact c = new contact(FirstName='Test', LastName='User4', Lan_ID__c = 'thetest');
        insert c;
        
        //creation of the form
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;

        
        upsert testForm;
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid'));
        System.currentPageReference().getParameters().put('formID',null);
        System.currentPageReference().getParameters().put('sid',u.Session_Token__c);
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '123ABC');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        testClass = new LineItemsGridController();
        testClass.form = new Forms__c();
        testClass.ValidateOrRedirect();
        testClass.saveAndReturn();
        Test.stopTest();
    }
    
	public static testMethod void testErrorMessages()
    {   Id rt = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('TCTO New Time Item').getRecordTypeId();
     	ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
 		//create User
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'Test',
            LastName = 'User4',
            Email = 'Test=User4@test.com',
            Username = 'Test=User4@tetest.com',
            CompanyName = 'TEST',
            Title = 'Test',
            Alias = 'Test',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Supervisor__c = UserInfo.getUserId(),
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
        contact c = new contact(FirstName='Test', LastName='User4', Lan_ID__c = 'thetest');
        insert c;     
        Forms__c testForm = new Forms__c();
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        insert testForm;
        line_item__C l1 = new line_item__c(Related_Form__c=testForm.Id,RecordTypeId=rt);
        line_item__C l2 = new line_item__c(Related_Form__c=testForm.Id,RecordTypeId=rt);
        line_item__C l3 = new line_item__c(Related_Form__c=testForm.Id,RecordTypeId=rt);
        
        LineItemsGridController lc = new LineItemsGridController();
        lc.lineItemCollection.add(l1);
        lc.lineItemCollection.add(l2);
        lc.lineItemCollection.add(l3);
        insert lc.lineItemCollection;
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid'));
        System.currentPageReference().getParameters().put('formID',null);
        System.currentPageReference().getParameters().put('sid',u.Session_Token__c);
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '123ABC');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
     
        l1.Normal_Workday_Start_Time__c ='12:00 PM';
        l1.Normal_Workday_End_Time__c= '12:00 AM';
        
        lc.saveTable();
        lc.saveAndReturn();     
        l1.Normal_Workday_Start_Time__c ='11:30 AM';
        l1.Normal_Workday_End_Time__c= '11:00 AM';
        
        lc.saveTable();
        lc.saveAndReturn();
     	l1.Normal_Workday_Start_Time__c ='11:00 AM';
        l1.Normal_Workday_End_Time__c= '10:00 AM';
       
        lc.saveTable();
        lc.saveAndReturn();
     
     	l1.Travel_Time_Start_Picklist__c ='12:00 PM';
        l1.Travel_Time_End_Picklist__c= '12:00 AM';
        
        lc.saveTable();
        lc.saveAndReturn();     
        l1.Travel_Time_Start_Picklist__c ='11:30 AM';
        l1.Travel_Time_End_Picklist__c= '11:00 AM';
       
        lc.saveTable();
        lc.saveAndReturn();
     	l1.Travel_Time_Start_Picklist__c ='11:00 AM';
        l1.Travel_Time_End_Picklist__c= '10:00 AM';
       
        lc.saveTable();
        lc.saveAndReturn();
     
     	l1.Travel_Time_Start_Actual__c ='12:00 PM';
        l1.Travel_Time_End_Actual__c= '12:00 AM';
        
        lc.saveTable();
        lc.saveAndReturn();     
        l1.Travel_Time_Start_Actual__c ='11:30 AM';
        l1.Travel_Time_End_Actual__c= '11:00 AM';
        
        lc.saveTable();
        lc.saveAndReturn();
     	l1.Travel_Time_Start_Actual__c ='11:00 AM';
        l1.Travel_Time_End_Actual__c= '10:00 AM';
       
        lc.saveTable();
        lc.saveAndReturn();
        
        Test.stopTest();
        
    }  
    public static testMethod void submitTest()
    {
        //variables
        ID tctoFormID = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('TCTO Request').getRecordTypeID();
        ID currentUserID = UserInfo.getUserId();
        ID Time_Entry_RT1;
        ID Time_Entry_RT2;
        ID Time_Entry_RT3;
        ID Time_Entry_RT4;
        Forms__c testForm = new Forms__c();
        Forms__c updatedForm = new Forms__c();
        LineItemsGridController testClass;
        List<Line_Item__c> timeEntryResults;
        List<Line_Item__c> updatedTimeEntryResults;
        
        //create User
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            FirstName = 'Test',
            LastName = 'User5',
            Email = 'Test=User5@test.com',
            Username = 'Test=User5@tetest.com',
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
        contact c = new contact(FirstName='Test', LastName='User5', Lan_ID__c = 'thetest');
        insert c;
        
        //creation of the form
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.RecordTypeId = tctoFormID;
        testForm.User_Supervisor__c = currentUserID;
        testForm.Start_Date_TCTO__c = Date.today();
        testForm.End_Date_TCTO__c = Date.today() + 4;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.TCTO_Request_Type__c = 'Proposed Hours';
        testForm.Hidden_Able_to_Create_Time_Entries__c = true;
        testForm.Approval_Step__c = null;

        
        upsert testForm;
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid'));
        System.currentPageReference().getParameters().put('sid',u.Session_Token__c);
        System.currentPageReference().getParameters().put('formID',testForm.Id);
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '123ABC');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        testClass = new LineItemsGridController();
        testClass.fetchTableData();
        testClass.ValidateOrRedirect();
        testClass.addRow();
        System.assertEquals(6, [select id from Line_Item__c where related_form__c =: testForm.Id].size());
        testClass.lineToDelete = [select id from Line_Item__c where related_form__c =: testForm.Id order by createddate desc limit 1].id;
        testClass.deleteRow();
        System.assertEquals(5, [select id from Line_Item__c where related_form__c =: testForm.Id].size());
        testClass.saveTable();
        testClass.submitFormFromLineItem();
        testClass.submitFormFromLineItem();
        Test.stopTest();
    }

}