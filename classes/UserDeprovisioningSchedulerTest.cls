@isTest
public with sharing class UserDeprovisioningSchedulerTest {
    
    @testSetup static void setup() {
      Profile p = [select id, name from profile where name = 'EPA BAP Forms Profile'];        
                
      User u = new User(FirstName='Bob', LastName='Smith', profileID=p.id, Username='test@fake.ccc', 
              email='test@fake.ccc', Alias='testU', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
      insert u;
    }

     @isTest
    static void testController(){
      
        Test.startTest();
                //Insert Test Data        
       UserDeprovisioningScheduler sc = new UserDeprovisioningScheduler();
       String sch = '0 0 23 * * ?'; 
       system.schedule('UserDepprov', sch, sc);

        Test.stopTest();
    }
}