@isTest
public class BAP_OCAPPM_Data_PageController2_Test {

    @isTest
    static void testController_t1User(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
        
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
        Test.setCurrentPageReference(new PageReference('Page.BAP_OCAPPM_Data')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getHeaders().put('Host', 'oeiodsta');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        BAP_OCAPPM_Data_PageController2 controller = new BAP_OCAPPM_Data_PageController2();
        controller.validateOrRedirect();
        controller.save();       
        controller.cancel();
        controller.sortOrderASC=true;
        controller.getissues();
        controller.sortByCustomerInquiryInput();
        controller.sortByInquiryDate();
        controller.sortByInquiryCategory();
        controller.sortBySMEResponse();
        controller.sortByStatus();
        controller.sortByRPIO();
         }
    }
    
    @isTest
    static void testController_NOTt1User(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        User u = [select id, Lan_ID__c, FirstName, LastName from User where isActive = true limit 1];
        u.Session_Token__c = '12345';
        u.Session_IP__c = '111-111-1111';
        u.Session_Environment__c = 'chrome';
        u.Session_Timestamp__c = datetime.now().addMinutes(-1);
        update u;
        
        Account a = new Account(name = 'acme');
        insert a;
        Contact c = new Contact(accountid = a.id, lastname = 'jones', Lan_ID__c = u.Lan_ID__c);
        insert c;
        
     System.runAs(u){
        Test.setCurrentPageReference(new PageReference('Page.BAP_OCAPPM_Data')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        System.currentPageReference().getHeaders().put('Host', 'epaoei');
        System.currentPageReference().getHeaders().put('sID', '12345');
        System.currentPageReference().getHeaders().put('X-Salesforce-SIP', '111-111-1111');
        System.currentPageReference().getHeaders().put('User-Agent', 'chrome');
        BAP_OCAPPM_Data_PageController2 controller = new BAP_OCAPPM_Data_PageController2();
 
        controller.save();
        controller.cancel();
        controller.download();
        controller.sortOrderASC=false;
        controller.getissues();
        controller.sortByCustomerInquiryInput();
        controller.sortByInquiryDate();
        controller.sortByInquiryCategory();
        controller.sortBySMEResponse();
        controller.sortByStatus();
        controller.sortByRPIO();
        
        } // end runAs(u)
    }  
    
    @isTest
    static void testController_InvalidUser(){
        insert new Contact_Approvers__c(name='Use Contact Fields', Use_Contact__c = false); // checkbox from "Contact Approvers" Custom Setting
        Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
        
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
        Test.setCurrentPageReference(new PageReference('Page.BAP_OCAPPM_Data')); 
        System.currentPageReference().getParameters().put('sID', '12345');
        BAP_OCAPPM_Data_PageController2 controller = new BAP_OCAPPM_Data_PageController2();
        controller.validateOrRedirect();
        }
    }    
        
}