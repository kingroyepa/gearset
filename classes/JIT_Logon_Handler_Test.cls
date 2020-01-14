/*
* @author Roy King
* @Name: JIT_Logon_Handler_TEST
* @description Class to unfreeze user accounts upon logon, if acct is 'activated'
* @date Created at 1/10/2020
*/
@isTest
public with sharing class JIT_Logon_Handler_Test {
    static testMethod void testCreateAndUpdateUser() {
        Profile p = [select id, name from profile where name = 'EPA Starter'];
        List<User> insertUserList = new List<User>();

        // Test Active User
        User u1 = new User(FirstName='Bob', LastName='Smith1', profileID=p.id, Username='test1@fake.ccc1',
                email='test@fake.ccc1', Alias='testU1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',isactive=true);
        insert(u1);

        // freeze user test
        UserLogin frzId = (UserLogin) [SELECT Id,isfrozen FROM UserLogin WHERE UserID=:u1.id LIMIT 1];
        frzId.IsFrozen = true;
        update frzId;

        JIT_Logon_Handler handler = new JIT_Logon_Handler();

        Auth.UserData sampleData = new Auth.UserData('testNewId', 'testNewFirst', 'testNewLast','testNewFirst testNewLast', 'testnewuser@example.org', null, 'testnewuserlong', 'en_US', 'facebook',null, new Map<String, String>{});

        handler.updateUser(u1.id,null,null,null, '', null,null);

        User updatedUser = [SELECT userName, email, firstName, lastName, alias FROM user WHERE id=:u1.id];

        handler.createUser(null,null,null, '', null,null);

    }
}