@isTest
public class initSession_Reports_Test {

    @isTest
    static void testController(){
        insert new Reports_URL__c(name='Report URL', URL__c = 'https://oeiodsta-oeiodstadev.cs33.force.com/reports/ReportPage'); // URL from Custom Setting
        initSession_Reports controller = new initSession_Reports();
        controller.uID = [select id from User where isActive = true limit 1].ID;
        controller.onLoad();
    }
    
    @isTest
    static void testControllerB(){
        insert new Reports_URL__c(name='Report URL', URL__c = 'https://oeiodsta-oeiodstadev.cs33.force.com/reports/ReportPage'); // URL from Custom Setting
        initSession_Reports controller = new initSession_Reports();
        
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
    
    controller.onLoad();
        
    }
}