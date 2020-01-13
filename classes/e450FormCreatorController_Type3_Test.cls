@istest
public class e450FormCreatorController_Type3_Test {

    @isTest
    static void testController(){
         insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        
                //Insert Test Data        
            Profile p = [select id, name from profile where name = 'EPA Starter'];        
                
            User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
            insert u;
            u.Session_Token__c = '12345';
            u.Session_IP__c = '111-111-1111';
            u.Session_Environment__c = 'test';
            u.Session_Timestamp__c = datetime.now().addMinutes(-1);
            u.Lan_ID__c = 'thetest';
            update u;
    
            contact c = new contact(FirstName='Bob', LastName='Smith', Lan_ID__c = 'thetest');
            insert c;
                
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'Sample_Record_Type'].ID);
        insert form;
        
        line_item__c li1 = new line_item__c(Item_Description__c='test', Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Assets_Income_Line_Item'].ID);
        insert li1;
        line_item__c li2 = new line_item__c(Item_Description__c='test', Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Liabilities_Line_Item'].ID);
        insert li2;
        line_item__c li3 = new line_item__c(Item_Description__c='test', Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Outside_Positions_Line_Item'].ID);
        insert li3;
        line_item__c li4 = new line_item__c(Item_Description__c='test', Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Agreements_or_Arrangements_Line_Item'].ID);
        insert li4;
        line_item__c li5 = new line_item__c(Item_Description__c='test', Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Part_5_Gifts_and_Travel_Reimbursements_Line_Item'].ID);
        insert li5;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(form);
        e450FormCreatorController_Type3 controller = new e450FormCreatorController_Type3(sc);
        Test.setCurrentPageReference(new PageReference('Page.e450SinglePageForm_Type3'));
         
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getParameters().put('Fid', form.id);
        
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        
       // controller.validateOrRedirect();           
    }
    
}