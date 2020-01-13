@istest
public class FormPageController_Test {

    @isTest
    static void testGetFormRTs(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
         u.Session_Token__c = '123ABC';
        update u;
        
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = [select id from PermissionSet where Label like '%BAPForms User%' limit 1].ID, AssigneeID = u.Id);
        try{
            insert psa;
        }
        catch (Exception e){
            system.debug(e.getMessage());
        }
        
        system.assert(FormPageController.getFormRTs('123ABC').size() > 0);
    }
     
    @isTest
    static void testInsertNewForms(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
        User u2 = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        u.Lan_ID__c = 'thetest';
        update u;

        //siteUser
        User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
     
        Forms__c testForm = new Forms__c();
        testForm.Unauthenticated_Owner__c = u.Id;
        testForm.approval_step__c = 'Form Prepared for you by test';
        testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].id;
        insert testForm;
              
        Forms__c form = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].ID, uSU.id, uAU.id);     

          Forms__c xform;
    
        try{
            xform = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Forms__c' AND name = 'Sample Record Type' limit 1].ID, uSU.id, uAU.id);
            }
            catch(exception ex){
                system.debug(ex.getMessage());  
              }
        String supportInfo = FormPageController.formSupportInfo(string.valueof(xForm.ID), 'Sample Record Type');
        Forms__c yform;
        try{
            yform = FormPageController.insertNewForms('xyz', [select id from RecordType where sObjectType = 'Forms__c' AND name = 'Sample Record Type' limit 1].ID, uSU.id, uAU.id);
            }
             catch(exception ex){
            system.debug(ex.getMessage());  
              }
              
        if(xform.id != null) {FormPageController.submitForApproval(xform.ID, '123ABC'); }  
        FormPageController.submitForApproval(form.ID, '123ABC');         
        FormPageController.findExistingForms('xyz');
        FormPageController.findExistingForms('123ABC');
        FormPageController.viewForm(form.ID, uSU.id);
        FormPageController.viewForm(testForm.ID, uSU.id);
        FormPageController.saveForm(form, '123ABC');
        FormPageController.saveForm(yform, '123ABC');
        FormPageController.getFormName(form.ID, '123ABC');
        FormPageController.deleteForm(form.ID, '123ABC');
        FormPageController.getFandP_FormRTs();
        FormPageController.getSiteUserID();
        FormPageController.getAPIUserID();
        FormPageController.removeFormShare(xform.ID, uSU.id);
        FormPageController.recallApproval(form.ID, '123ABC'); 
    }    
    
    @isTest
    static void testErrorDML(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
         User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
         u.Session_Token__c = '123ABC';
        update u;  
        
        //siteUser
        User uSU = [select id from User where isActive = true AND id != :u.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :uSU.id limit 1];

        
        try{
          Forms__c zform = FormPageController.insertNewForms('123ABC', [select id from RecordType where sObjectType = 'Account' limit 1].ID, uSU.id, uAU.id);
          }
        catch(exception ex){
            system.debug(ex.getMessage());  
          }
      
      }
      
      @isTest
        static void testAttachmentMethods(){
            insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
            
            User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
            u.Lan_ID__c = 'thetest';
            u.Session_Token__c = '123abc';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
         
            Forms__c testForm = new Forms__c();
            testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].id;
            testForm.Unauthenticated_Owner__c = u.Id;
            insert testForm;
            
            //create test data: file
            ID formID = testForm.id;
            String fileName = 'testFile.txt';
            String base64Data = 'testdata';
            String contentType = 'text/plain';
            
            String attID = FormPageController.uploadFile(formID, fileName, base64Data, contentType);            
            FormPageController.getListOfAttachments(formID);
            FormPageController.deleteFormAttachment(attID);
            
            string sID = '123abc';
            FormPageController.cloneForm(sID,FormID);
            id attChunkid;
            FormPageController.saveChunk(formID,'att',base64Data,contentType,'');
            id att2 = FormPageController.saveTheFile(formID,'att',base64Data,contentType);
            FormPageController.saveChunk(formID,'att',base64Data,contentType,att2);
            
            
            //test files
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

            ContentVersion cv = new ContentVersion();
            cv.title = 'test content trigger';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;          
            insert cv;         
    
            ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];
    
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=formID;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=testcontent.ContentDocumentId;
    
            insert contentlink;
                    
            FormPageController.getListOfFiles(formID); 
            
      }
      
      @isTest
        static void testApprovalRecall(){
            insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
            
            User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
            User u2 = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' and id != :u.id limit 1];
            u.Lan_ID__c = 'thetest';
            u.Session_Token__c = '123ABC';
            u.Supervisor__c = u2.id;
            u.Supervisor_2__c = u2.id;
            update u;
            
            //siteUser
            User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];
        
            //apiUser
            User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];
                       
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
         
            Forms__c testForm = new Forms__c();
            testForm.RecordTypeID = [select id from RecordType where sObjectType = 'Forms__c' AND name = 'Sample Record Type' limit 1].id;
            testForm.Unauthenticated_Owner__c = u.Id;
            insert testForm;
            
            id formID = testForm.id;
            String rtID = [Select Id, developername From RecordType Where sObjectType = 'Line_Item__c' AND developername = 'Form_Sample_Record_Type_Line_Item'].Id;
            Line_Item__c litem = FormPageController.insertLineItem('123ABC', 'Sample Record Type', formID, uSU.ID, uAU.ID, rtID);
            
            FormPageController.submitForApproval(formID, '123ABC');
            FormPageController.recallApproval(formID, '123ABC');
      }      
     
      @isTest
      static void testLineItems(){
        
      String liRT = FormPageController.isLineItemEnabled('no Record Type');
      liRT = FormPageController.isLineItemEnabled('Sample Record Type');
    
      String rtID = [Select Id, developername From RecordType Where sObjectType = 'Line_Item__c' AND developername = 'Form_Sample_Record_Type_Line_Item'].Id;

       insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
        User u2 = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' and id != :u.id limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        u.Lan_ID__c = 'thetest';
        update u;

        //siteUser
        User uSU = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' AND id != :u.id AND id != :u2.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c;
        Forms__c theForm = FormPageController.insertNewForms('123ABC', [select id, developerName from RecordType where sObjectType = 'Forms__c' ORDER BY createddate limit 1].ID, uSU.id, uAU.id);
            
            List<Line_Item__c> liList = FormPageController.getListOfLineItems(theForm.ID, 'formName');
            liList = FormPageController.getListOfLineItems(theForm.ID, null);
                   
            Line_Item__c litem = FormPageController.insertLineItem('456def', 'Sample Record Type', theForm.ID, uSU.ID, uAU.ID, rtID);
            litem = FormPageController.insertLineItem('123ABC', 'Sample Record Type', theForm.ID, uSU.ID, uAU.ID, null);
            litem = FormPageController.insertLineItem('123ABC', 'no Record Type', theForm.ID, null, null, rtID);
            litem = FormPageController.insertLineItem('123ABC', 'Sample Record Type', theForm.ID, uSU.ID, uAU.ID, rtID);
            
            String d1 = 'Name';
            string d2 = 'CreatedByID';
            string d3 = 'LastModifiedById';
            string d4 = 'OwnerID';
            string d5 = 'RecordTypeID';
            List<Line_Item__c> litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID, rtID);
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID, null);
            
            d5 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID, rtID);
            
            d4 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID, rtID);
            
            d3 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID, rtID);
            
            d2 = null;
            litems = FormPageController.getLineItemData(d1, d2, d3, d4, d5, theForm.ID, rtID);
            
            List<string> displays = FormPageController.getLineItemDisplayFields(rtID);
            List<string> datas = FormPageController.getLineItemDataFields(rtID);
            Line_Item__c litem2 = FormPageController.getLineItem(litem.ID);
            string msg =  FormPageController.deleteLineItem(litem.ID, 'x');
            
            Line_Item__c litem3 = new Line_Item__c (recordtypeid = rtID, related_Form__c = theForm.id);
            insert litem3;
            UtilityMethods.addFormShare(theForm.ID, uSU.id);
            UtilityMethods.removeFormShare(theForm.ID, uSU.id);
            
            FormPageController.getLineItemLabel('Sample Record Type');
            
            FormPageController.cloneForm('123ABC',theForm.ID);
            
            FormPageController.getLineItemLink('OGE-450');
            
     }
    
    @isTest
    static void testOGEForms1(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        // create test data     
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
            
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Session_Token__c = '123ABC', lan_id__c = 'smith123');
        insert u;

        User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
              email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',supervisors__c='Sally Lee');
        insert u2;
        
        User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
              email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u3;
        
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account HQ = new account(name='acme hq');
        insert HQ;
        
        Account a = new account (name='acme', parentid=hq.id);
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c;
        insert c2;
        
        hq.Assistant_Deputy_Ethics_Official_1__c=c2.id;
        hq.Deputy_Ethics_Official__c=c2.id;
        update hq;
        
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
        
        // test w/o line items but 'yes' responses
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, Reporting_Status__c = 'Annual', RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        form.response_1__c = 'yes';
        form.response_2__c = 'yes';
        form.response_3__c = 'yes';
        form.response_4__c = 'yes';
        form.response_5__c = 'yes';
        insert form;        
        FormPageController.submitForApproval(form.id, '123ABC' );
        
        //test with no line items but 'no' responses
        Forms__c form2 = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, Reporting_Status__c = 'Annual', RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        form2.response_1__c = 'no';
        form2.response_2__c = 'no';
        form2.response_3__c = 'no';
        form2.response_4__c = 'no';
        form2.response_5__c = 'no';
        insert form2;
        
        id RT1 = [select id, developerName from recordtype where developerName = 'OGE_450_Assets_Income_Line_Item' limit 1].id; 
        id RT2 = [select id, developerName from recordtype where developerName = 'OGE_450_Liabilities_Line_Item' limit 1].id;
        id RT3 = [select id, developerName from recordtype where developerName = 'OGE_450_Outside_Positions_Line_Item' limit 1].id;
        id RT4 = [select id, developerName from recordtype where developerName = 'OGE_450_Agreements_or_Arrangements_Line_Item' limit 1].id;
        id RT5 = [select id, developerName from recordtype where developerName = 'OGE_450_Part_5_Gifts_and_Travel_Reimbursements_Line_Item' limit 1].id;
        
        line_item__c li1 = new line_item__c(recordtypeid = RT1,Related_Form__c = form2.id, Item_Description__c = 'test');
        insert li1;
        line_item__c li2 = new line_item__c(recordtypeid = RT2,Related_Form__c = form2.id, Name_of_Creditor__c = 'test');
        insert li2;
        line_item__c li3 = new line_item__c(recordtypeid = RT3,Related_Form__c = form2.id, Organization__c = 'test');
        insert li3;
        line_item__c li4 = new line_item__c(recordtypeid = RT4,Related_Form__c = form2.id, Entity__c = 'test');
        insert li4;
        line_item__c li5 = new line_item__c(recordtypeid = RT5,Related_Form__c = form2.id, Source__c ='test');
        insert li5;        
        FormPageController.submitForApproval(form2.id, '123ABC' );
    }
    
    @isTest
    static void testOGEForms2(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        // create test data     
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
            
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Session_Token__c = '123ABC', lan_id__c = 'smith123');
        insert u;

        User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
              email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',supervisors__c='Sally Lee');
        insert u2;
        
        User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
              email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u3;
        
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account HQ = new account(name='acme hq');
        insert HQ;
        
        Account a = new account (name='acme', parentid=hq.id);
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c;
        insert c2;
        
        hq.Assistant_Deputy_Ethics_Official_1__c=c2.id;
        hq.Deputy_Ethics_Official__c=c2.id;
        update hq;
        
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
        
        //test with no line items and 'no' responses
        Forms__c form3 = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        form3.response_1__c = 'no';
        form3.response_2__c = 'no';
        form3.response_3__c = 'no';
        form3.response_4__c = 'no';
        form3.response_5__c = 'no';
        form3.Employee_s_Signature__c = TRUE;
        insert form3;
        FormPageController.submitForApproval(form3.id, '123ABC' );
        
        //test with no line items and 'no' responses, but no signature
        Forms__c form4 = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        form4.response_1__c = 'no';
        form4.response_2__c = 'no';
        form4.response_3__c = 'no';
        form4.response_4__c = 'no';
        form4.response_5__c = 'no';
        insert form4;
        FormPageController.submitForApproval(form4.id, '123ABC' );
    }
    
    @isTest
    static void testOrders(){
        
        String rtID = [Select Id, developername From RecordType Where sObjectType = 'Order_Request__c' AND developername = 'Purchase_Card_Order_Request'].Id;

        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        User u = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' limit 1];
        User u2 = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' and id != :u.id limit 1];
        User u3 = [select id from User where isActive = true and Profile.Name = 'System Administrator' limit 1];
        u.Session_Token__c = '123ABC';
        u.Supervisor__c = u2.id;
        u.Supervisor_2__c = u2.id;
        u.Lan_ID__c = 'thetest';
        update u;

        //siteUser
        User uSU = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' AND id != :u.id AND id != :u2.id limit 1];
        
        //apiUser
        User uAU = [select id from User where isActive = true and Profile.Name = 'EPA Starter' and UserRole.Name = 'EPA Enterprise' AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

        contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
        insert c; 

        Order_Request__c ord3 = FormPageController.insertNewOrders('123ABC', rtID, uSU.id, uAU.id);
        ord3.Card_Holder__c = u3.id;
        ord3.Approving_Official__c = u3.id;
        
        ord3.JWOD_Programs_NB_NISH__c = false;
        ord3.GSA_GSA_Advantage_General_Services__c = true;
        update ord3;
        FormPageController.insertLineItemForOrder('123ABC', ord3.id, uSU.id, uAU.id);
        FormPageController.insertLineItemForOrder('321CBA', ord3.id, uSU.id, uAU.id);
        
        FormPageController.submitForApprovalForOrder(ord3.id, '123ABC');
        FormPageController.recallApprovalForOrder(ord3.id, '123ABC');           
    }
    
    @isTest
    static void testOHRForms(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        
        // create test data     
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
            
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US', Session_Token__c = '123ABC', lan_id__c = 'smith123');
        insert u;

        User u2 = new User(FirstName='Dave', LastName='Jones', profileID=p.id, Username='test2@fake.ccc', 
              email='test@fake.ccc', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',supervisors__c='Sally Lee');
        insert u2;
        
        User u3 = new User(FirstName='Sally', LastName='Lee', profileID=p.id, Username='test3@fake.ccc', 
              email='test@fake.ccc', Alias='testU3', CommunityNickname='testU3', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u3;
        
        // inserting records for using Contact fields for Approval process (Lan_ID__c fields having matching values on User & Contact records)
        Account HQ = new account(name='acme hq');
        insert HQ;
        
        Account a = new account (name='acme', parentid=hq.id);
        insert a;
        Contact c = new contact (lastname ='smith', accountid=a.id, lan_id__c='smith123');
        Contact c2 = new contact (lastname ='jones', accountid=a.id, lan_id__c='jones123');
        insert c;
        insert c2;
        
        u.Supervisor__c = u2.ID;
        u.lan_id__c = c.lan_id__c;
        u.delegatedapproverid = u2.id;
        update u;
        c.Supervisor__c = u2.ID;
        c.user__c = u.id;
        update c;        
        
        u2.Supervisor__c = u3.ID;
        u2.lan_id__c = c2.lan_id__c;
        update u2;
        c2.Supervisor__c = u3.id;
        c2.user__c = u2.id;
        update c2;
        
        // test OHR form
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, prepare_Form_for__c = c2.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'HR_System_Access_Request'].ID);
        insert form;        
        FormPageController.submitForApproval(form.id, '123ABC' );        
    }

}