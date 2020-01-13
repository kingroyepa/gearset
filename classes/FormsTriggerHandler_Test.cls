@istest
public class FormsTriggerHandler_Test {

    @isTest(seeAllData=true)
    static void testTriggerAA(){
        
        //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
            
            User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
                  email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u3;
            
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account a = new account (name='acme');
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123', email='test@fake.ccc');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123', email='test@fake.ccc');
        insert c;
        insert c2;
        
        a.Senior_IT_Leader__c = c2.id;
        a.Local_SIO__c = c2.id;
        update a;
        
        u.Supervisor__c = u2.ID;
        u.lan_id__c = c.lan_id__c;
        u.delegatedapproverid = u2.id;
        update u;
        c.Supervisor__c = u2.ID;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        update c2;
        
     //Reassignment Tests
        // reassignment update
        Forms__c form = new Forms__c(Approval_Routing_Options__c='Region 1', user_supervisor__c = u2.id, approver_1__c = u2.id, approver_2__c = u2.id, approver_3__c = u2.id, Application_Owner__c = c.id, Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        insert form;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit the approval request for the Form 
        Approval.ProcessResult result = Approval.process(req1);
        update form;
    
        ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
            FROM ProcessInstanceWorkItem
            WHERE ProcessInstance.TargetObjectId = :form.ID limit 1];
        
        Pitem.ActorID = u3.id;
        Pitem.OriginalActorId = u2.id;
        update Pitem;
    
        form.Finalize_Approval_Reassignment__c = true;
        update form; 
        
    }   
    
    @isTest(seeAllData=true)
    static void testTriggerA(){
        
        //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
            
            User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
                  email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u3;
            
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account a = new account (name='acme');
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c;
        insert c2;
        
        a.Senior_IT_Leader__c = c2.id;
        a.Local_SIO__c = c2.id;
        update a;
        
        u.Supervisor__c = u2.ID;
        u.lan_id__c = c.lan_id__c;
        u.delegatedapproverid = u2.id;
        update u;
        c.Supervisor__c = u2.ID;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        update c2;
        
     //Reassignment Tests
        // reassignment update
        Forms__c form = new Forms__c(approver_1__c = u2.id, approver_2__c = u2.id, approver_3__c = u2.id, Application_Owner__c = c.id, Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'Application_Review_Process_Tool'].ID);
        insert form;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit the approval request for the Form 
        Approval.ProcessResult result = Approval.process(req1);
        update form;
    
        ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
            FROM ProcessInstanceWorkItem
            WHERE ProcessInstance.TargetObjectId = :form.ID limit 1];
        
        Pitem.ActorID = u3.id;
        Pitem.OriginalActorId = u2.id;
        update Pitem;
    
        form.Finalize_Approval_Reassignment__c = true;
        update form; 
        
        // reassign to Group
        
        Pitem = [SELECT ActorID, OriginalActorId 
            FROM ProcessInstanceWorkItem
            WHERE ProcessInstance.TargetObjectId = :form.ID limit 1];
        list<group> g = [select id from group limit 2];
        Pitem.ActorID = g[0].id;
        Pitem.OriginalActorId = g[1].id;
        update Pitem;
    
        form.Finalize_Approval_Reassignment__c = true;
        update form; 
        
    }   
    
    @isTest(seeAllData=true)
    static void testTriggerB(){
        
        //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
                  email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u2;
            
            User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
                  email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u3;
            
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account a = new account (name='acme');
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c;
        insert c2;
        
        a.Senior_IT_Leader__c = c2.id;
        a.Local_SIO__c = c2.id;
        update a;
        
        u.Supervisor__c = u2.ID;
        u.lan_id__c = c.lan_id__c;
        u.delegatedapproverid = u2.id;
        update u;
        c.Supervisor__c = u2.ID;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        update c2;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        Line_Item__c litem = new Line_Item__c(related_Form__c = form.id, RecordtypeId = [select id from RecordType where sObjectType = 'Line_Item__c' and DeveloperName = 'Form_Sample_Record_Type_Line_Item'].ID);
        insert litem;
        system.assertEquals(u2.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        form.Unauthenticated_Owner__c = u2.id;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
       
        update form;
        system.assertEquals(u2.ID, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
        form.Finalize_Approval_Reassignment__c = true;
        update form; 
        
    }   

    @isTest
    static void testTriggerC(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
    }    
    
    @isTest
    static void testTriggerD(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
            
            User uMgr = new User(FirstName='Rob', LastName='Jones', Lan_ID__c = 'thetest1', profileID=p.id, Username='test1@fake.ccc', 
                  email='test@fake.ccc', Alias='testU1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert uMgr;
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Time_Keeper__c = null);
            insert u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Approved', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        
        //add attachments
        Attachment Att = new Attachment();
        Att.Name='Unit Test 1';
        Att.Description='Unit Test 1';
        Att.Body=Blob.valueOf('Unit Test 1');
        Att.ParentID=form.id;
        insert Att;
        
        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);
        
        Forms__c formLicUser = new Forms__c(RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        try{insert formLicUser;}catch (Exception e){}
        
    }          

    @isTest
    static void testTriggerK(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            
            account parent = new account(name='acme', pmo_rhro__c = u.id, lookup_tags__c = 'HR Org, Top Level');
            insert parent;
            account a = new account(name='acme-box', parent=parent);
            insert a;
            
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', user__c = u.id, accountid = a.id);
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'HR_System_Access_Request'].ID);
        //had to use below line to deploy ARPTool to production (oge-450 not in prod yet)
        //Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);        
    }        
   
    @isTest(seeAllData=true)
    static void testTriggerM(){
        //insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
            
            User uMgr = new User(FirstName='Rob', LastName='Jones', Lan_ID__c = 'thetest1', profileID=p.id, Username='test1@fake.ccc', 
                  email='test@fake.ccc', Alias='testU1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert uMgr;
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetester', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Time_Keeper__c = null);
            insert u;
    
            contact c = new contact(FirstName='Robert', LastName='Smith', Lan_ID__c = 'thetester', user__c = u.id);
            insert c;
            
        Forms__c form2 = new Forms__c(ownerid = u.id, Unauthenticated_Owner__c = u.Id, approval_step__c = 'Approved', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form2;
        Approval.ProcessSubmitRequest req2 = new Approval.ProcessSubmitRequest();
        
    }   
    
    @isTest(seeAllData=true)
    static void testTriggerM2(){
        //insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
            
            User uMgr = new User(FirstName='Rob', LastName='Jones', Lan_ID__c = 'thetest1', profileID=p.id, Username='test1@fake.ccc', 
                  email='test@fake.ccc', Alias='testU1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert uMgr;
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetester', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Time_Keeper__c = null);
            insert u;
    
            contact c = new contact(FirstName='Robert', LastName='Smith', Lan_ID__c = 'thetester', user__c = u.id);
            insert c;
                    
        //Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Approved', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        Forms__c form = new Forms__c(ownerid = u.id, Unauthenticated_Owner__c = u.Id, user_supervisor__c = uMgr.id, Approval_Routing_Options__c = 'Region 1', approval_step__c = 'Submitted', RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        insert form;
        
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u.Id); 
        Approval.ProcessResult result = Approval.process(req1);
        
        form.Finalize_Approval_Reassignment__c = true;
        update form;
        
    }
    
    @isTest
    static void testTriggerN(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            
            Id OrgRtID = Schema.SObjectType.account.getRecordTypeInfosByName().get('HR Org').getRecordTypeId();
            account a = new account(name='AO-sub', recordtypeid=OrgRtID);
            insert a;
            
            account a2 = new account(name='AO', recordtypeid=OrgRtID);
            insert a2;
            
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', user__c = u.id, accountid=a.id);
            insert c;
            
            a.parentid=a2.id;
            update a;
            
            a2.Assistant_Deputy_Ethics_Official_1__c=c.id;
            a2.Deputy_Ethics_Official__c=c.id;
            update a2;
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        //had to use below line to deploy ARPTool to production (oge-450 not in prod yet)
        //Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);        
    }   
 
  @isTest
    static void testTriggerO(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            
            Id OrgRtID = Schema.SObjectType.account.getRecordTypeInfosByName().get('HR Org').getRecordTypeId();
            account a = new account(name='AO-sub', recordtypeid=OrgRtID);
            insert a;
            
            account a2 = new account(name='AO', recordtypeid=OrgRtID);
            insert a2;
            
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', user__c = u.id, accountid=a.id);
            insert c;
            
            a.parentid=a2.id;
            update a;
            
            a2.Assistant_Deputy_Ethics_Official_1__c=c.id;
            a2.Deputy_Ethics_Official__c=c.id;
            update a2;
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        //had to use below line to deploy ARPTool to production (oge-450 not in prod yet)
        //Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);        
    }
    
    @isTest
    static void testTriggerE(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', profileID=p.id, Username='test@fake.ccc', 
                  email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                  LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            
            account parent = new account(name='acme', pmo_rhro__c = u.id, lookup_tags__c = 'HR Org, Top Level');
            insert parent;
            account a = new account(name='acme-box', parent=parent);
            insert a;
            
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest', user__c = u.id, accountid = a.id);
            insert c;
            
                    
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'SF_182'].ID);
        //had to use below line to deploy ARPTool to production (oge-450 not in prod yet)
        //Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, approval_step__c = 'Form Prepared for you by test', prepare_form_for__c = c.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'EPA_100'].ID);
        insert form;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();

        // Submit the approval request for the account
        try{Approval.ProcessResult result = Approval.process(req1);}catch (Exception e){}
        
        form.Unauthenticated_Owner__c = null;
        update form;
        system.assertEquals(null, [select User_Supervisor__c from Forms__c where id = :form.ID].User_Supervisor__c);        
    }
     
}