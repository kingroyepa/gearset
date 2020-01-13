@isTest(Seealldata=true)
 private class  RevokeLicense_Test{
  static testMethod void testRevokeSuccess(){

      // Using EPA Full to avoid the Validation rule where Stater cannot edit other starter users
      Profile p = [select id, name from profile where name = 'EPA Full'];
      // Create User
      User u = new User(FirstName='Bob', LastName='Smith', lan_ID__c='smith12311', profileID=p.id, Username='test@fake.prod',
              email='test@fake.ccc', Alias='testP', CommunityNickname='testU', TimeZoneSidKey= 'America/Los_Angeles',
              LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
      insert u;

      //System.runAs(u){
      // Create Org
      Account a = new account (name='acme2');
      insert a;
      //Create Contact, and link it to the User above - Also sets to active via the contact record - for trigger coverage
      Contact c = new contact (lastname ='Smith', accountid=a.id, lan_id__c='smith12311', Status__c='Active',User__c=u.Id);
      insert c;


      //test.startTest();
    GrantLicense.AssignPermissionSet(c.Id,'BAP Support','BAP Support');

    RevokeLicense.RemovePermissionSet(c.Id,'BAP Support','BAP Support');
      RevokeLicense.revoke(u.Id);
      //test.stopTest();

  }
    }