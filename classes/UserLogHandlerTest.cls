@isTest
public with sharing class UserLogHandlerTest {
    
    @testSetup static void setup() {
      Profile p = [select id, name from profile where name = 'EPA Starter'];        
      List<User> insertUserList = new List<User>();
        
	  // Test Active User
      User u1 = new User(FirstName='Bob', LastName='Smith1', profileID=p.id, Username='test1@fake.ccc1', 
              email='test@fake.ccc1', Alias='testU1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',isactive=true);
      insertUserList.add(u1);
      
      // Test Inactive user
      User u2 = new User(FirstName='Bob', LastName='Smith2', profileID=p.id, Username='test2@fake.ccc2', 
              email='test@fake.ccc2', Alias='testU2', CommunityNickname='testU2', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',isactive=false);
      insertUserList.add(u2);

      insert insertUserList;
    }

    static testmethod void testQueueable() {
        // query for test data to pass to queueable class
        List<user> uId = [select id from user where alias in ('TestU1','TestU2')];
        // Create our Queueable instance
        UserLogHandler updater = new UserLogHandler(uId, null, 'test');
        UserLogHandler updater2 = new UserLogHandler(uId,'Freeze', 'test');

        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(updater);
        System.enqueueJob(updater2);
        Test.stopTest();        
    }
}