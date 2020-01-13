@isTest
public class RulesOfBehaviorResetTest {
    static testMethod void myunit(){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,Agree_To_Rules_of_Behavior__c = true,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='STTA11@test.org');
            insert u;
        
        Test.StartTest();
        system.runAs(u){
           RulesOfBehaviorReset obj = new RulesOfBehaviorReset();
            DataBase.executeBatch(obj); 
        }
        Test.stopTest();
    }
        static testMethod void myunit1(){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,Agree_To_Rules_of_Behavior__c = true,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='STTA11@test.org');
            insert u;
        
        Test.StartTest();
        system.runAs(u){
        RulesOfBehaviorReset sh1 = new RulesOfBehaviorReset();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        }
        Test.stopTest();
    }
}