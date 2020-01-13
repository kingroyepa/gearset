/* Author:       John Jenkins
 * Email:        jjenkins@innovateteam.com
 * 
 * Apex Class:    LineItemsGrid_e450_Controller
 * 
 * Description:   A test class to validate the LineItemsGrid_e450_Controller;
 *           
 * 
 */
@isTest
public class LineItemsGrid_e450_Controller_Test {
    
    @isTest
    static void testController_t1User(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
        
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
        a.Assistant_Deputy_Ethics_Official_1__c=c.id;
        a.Deputy_Ethics_Official__c=c.id;
        update a;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        insert form;
        
        line_item__c li1 = new line_item__c(Item_Description__c='test', Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Assets_Income_Line_Item'].ID);
        insert li1;
        
        system.runas(u) {
            Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid_e450_assets_income')); 
            System.currentPageReference().getParameters().put('sID', '12345');
            System.currentPageReference().getParameters().put('formID', form.id);
            System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
            System.currentPageReference().getHeaders().put('sID', '12345');
            System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
            System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
            LineItemsGrid_e450_Controller controller = new LineItemsGrid_e450_Controller();
            controller.t1user = true;
            controller.validateOrRedirect();
            controller.saveAndReturn(); 
            controller.go();
            
            System.currentPageReference().getParameters().put('liType', 'liabilities');
            controller.fetchTableData();
            
            System.currentPageReference().getParameters().put('liType', 'outside_positions');
            controller.fetchTableData();
            
            System.currentPageReference().getParameters().put('liType', 'agreement_arrangement');
            controller.fetchTableData();
            
            System.currentPageReference().getParameters().put('liType', 'gifts_travel');
            controller.fetchTableData();
            
            form.approval_step__c = 'Approved';
            update form;
            controller.fetchTableData();
            
         }// end runAs(u)
    }
    
    @isTest
    static void testController_NOTt1User(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA Starter'];
        
        User u = [select id, Lan_ID__c, FirstName, LastName from User where isActive = true AND profileid = :p.id limit 1];
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
        a.Assistant_Deputy_Ethics_Official_1__c=c.id;
        a.Deputy_Ethics_Official__c=c.id;
        update a;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        insert form;
        
        line_item__c li1 = new line_item__c(Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Assets_Income_Line_Item'].ID);
        insert li1;
        
         System.runAs(u){
             Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid_e450_liabilities')); 
             System.currentPageReference().getParameters().put('sID', '12345'); 
             System.currentPageReference().getParameters().put('formID', form.id);
             System.currentPageReference().getHeaders().put('Host', 'epaoei');
             System.currentPageReference().getHeaders().put('sID', '12345');
             System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
             System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
            
             LineItemsGrid_e450_Controller controller = new LineItemsGrid_e450_Controller();
             controller.lineToDelete = [select id from Line_Item__c where related_form__c =: form.Id order by createddate desc limit 1].id;
             controller.deleteRow();
             controller.getLineItemRTs();
             
             System.currentPageReference().getParameters().put('liType', 'agreement_arrangement');
             controller.fetchTableData();
             controller.lineItemCollection = controller.queryDBForFields(form.id);
             system.debug('lineItemCollection: '+controller.lineItemCollection);
             controller.saveTable();
             controller.go();
             
         } // end runAs(u)
    }
    
    @isTest
    static void testController_InvalidUser(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
        
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
        system.runas(u) {
        Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid_e450_liabilities')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        LineItemsGrid_e450_Controller controller = new LineItemsGrid_e450_Controller();
        controller.validateOrRedirect();
        }
    }
    
    @isTest
    static void controllerTest2(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
        
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
        a.Assistant_Deputy_Ethics_Official_1__c=c.id;
        a.Deputy_Ethics_Official__c=c.id;
        update a;
        
        Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
        insert form;
        
        system.runas(u) {
            Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid_e450_assets_income')); 
            System.currentPageReference().getParameters().put('sID', '12345');
            System.currentPageReference().getParameters().put('formID', form.id);
            System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
            System.currentPageReference().getHeaders().put('sID', '12345');
            System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
            System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
            LineItemsGrid_e450_Controller controller = new LineItemsGrid_e450_Controller();
            controller.addRow();
            } 
    }    
    
    @isTest
    static void testController_errorMessages(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = true); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA Starter'];        
        
        User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
                    email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
                    LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        insert u;
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        u.Lan_ID__c = 'testLan';
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
        a.Assistant_Deputy_Ethics_Official_1__c=c.id;
        a.Deputy_Ethics_Official__c=c.id;
        update a;
        
        system.runas(u) {
            Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid_e450_assets_income')); 
            System.currentPageReference().getParameters().put('sID', '12345');
            System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
            System.currentPageReference().getHeaders().put('sID', '12345');
            System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
            System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
            LineItemsGrid_e450_Controller controller = new LineItemsGrid_e450_Controller();
            
            Forms__c form = new Forms__c(Unauthenticated_Owner__c = u.Id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'OGE_450'].ID);
            insert form;
            
            line_item__c li1 = new line_item__c(Related_Form__c = form.id, ownerid = u.id, RecordtypeId = [select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Assets_Income_Line_Item'].ID);
            insert li1;
            
            Test.setCurrentPageReference(new PageReference('Page.LineItemsGrid_e450_liabilities')); 
            System.currentPageReference().getParameters().put('liType', 'liabilities');
            controller.validateOrRedirect();
            controller.msgOff=false;
            controller.newLineItemRT=[select id from RecordType where sObjectType = 'line_item__c' and DeveloperName = 'OGE_450_Liabilities_Line_Item'].ID;
            controller.addRow();
            controller.deleteRow();
            controller.saveAndReturn();
            controller.saveTable();
                        
         }// end runAs(u)
    }
       
}