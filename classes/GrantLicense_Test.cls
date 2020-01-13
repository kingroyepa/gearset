@isTest(Seealldata=true)
private class  GrantLicense_Test{
    @isTest
    static void testBAPProvisioningTriggers(){
        // Using EPA Full to avoid the Validation rule where Stater cannot edit other starter users
        Profile p = [select id, name from profile where name = 'EPA Full'];        
        // Create Users
        List<User> insertUserList = new List<User>();

        // Test Active User
        User u1 = new User(FirstName='Bob', LastName='Smith1', profileID=p.id, Username='test1@fake.ccc1',
                email='test@fake.ccc1', Alias='aaa1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',isactive=true);
        insertUserList.add(u1);

        insert insertUserList;

        //System.runAs(u){
        // Create Org
        Account a = new account (name='acme1');
        insert a;
        //Create Contact, and link it to the User above - Also sets to active via the contact record - for trigger coverage
        Contact c = new contact (lastname ='Smith', accountid=a.id, lan_id__c='smith1231', Status__c='Active',User__c=u1.Id);
        insert c;
        // Create Form
        Forms__c form = new Forms__c( Form_status__c='Approved',Name__c='TEST',Form_Type__c='Permission Set',Technical_Contact__c = c.Id, Submitted_on_Behalf_Of__c = c.Id, Permission_Set_Name__c = 'BAP Support', Public_Group__c='BAP Support', Unauthenticated_Owner__c = u1.Id, Approver_1__c = u1.Id,RecordtypeId = [select id from RecordType where sObjectType = 'Forms__c' and DeveloperName = 'BAP_User_Provisioning'].ID);
        insert form;
        form.Unauthenticated_Owner__c = u1.Id;
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(form.id);
        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(u1.Id);
        
        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1);
        
        update form; 

        // Test the Permission Set Assigning class
        GrantLicense.AssignPermissionSet(c.Id, 'API User', 'BAP Support');  
       // ItemsToApprove.WrapperClass();
    }
    @isTest
    static void testBAPProvisioningUnfreeze(){
        // Using EPA Full to avoid the Validation rule where Stater cannot edit other starter users
        Profile p = [select id, name from profile where name = 'EPA Full'];
        // Create Users
        List<User> insertUserList = new List<User>();

        // Test Active User
        User u1 = new User(FirstName='Bob', LastName='Smith1', profileID=p.id, Username='test1@fake.ccc1',
                email='test@fake.ccc1', Alias='aaa1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',isactive=false);
        insertUserList.add(u1);

        insert insertUserList;

        UserLogin frzId = (UserLogin) [SELECT Id,isfrozen FROM UserLogin WHERE UserID=:u1.id LIMIT 1];
            frzId.IsFrozen = true;
            update frzId;

        // Create Org
        Account a = new account (name='acme1');
        insert a;
        //Create Contact, and link it to the User above - Also sets to active via the contact record - for trigger coverage
        Contact c = new contact (lastname ='Smith', accountid=a.id, lan_id__c='smith1231', Status__c='Active',User__c=u1.Id);
        insert c;

        GrantLicense.AssignPermissionSet(c.Id, 'API User', 'BAP Support');
    }

    @isTest
    static void testBAPProvisioningActivate(){
        // Using EPA Full to avoid the Validation rule where Stater cannot edit other starter users
        Profile p = [select id, name from profile where name = 'EPA Full'];
        // Create Users
        List<User> insertUserList = new List<User>();

        // Test Active User
        User u1 = new User(FirstName='Bob', LastName='Smith1', profileID=p.id, Username='test1@fake.ccc1',
                email='test@fake.ccc1', Alias='aaa1', CommunityNickname='testU1', TimeZoneSidKey= 'America/Los_Angeles',
                LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US',isactive=false);
        insertUserList.add(u1);

        insert insertUserList;

        // Create Org
        Account a = new account (name='acme1');
        insert a;
        //Create Contact, and link it to the User above - Also sets to active via the contact record - for trigger coverage
        Contact c = new contact (lastname ='Smith', accountid=a.id, lan_id__c='smith1231', Status__c='Inactive',User__c=u1.Id);
        insert c;

        GrantLicense.AssignPermissionSet(c.Id, 'API User', 'BAP Support');

    }
}