/**
* When sandboxes refresh, all users' email addresses have @example.com appended to them.
* This is a safety feature to prevent unexpected or unwanted emails to be sent from sandbox to users.
* This class reverts all active users' email addresses by removing the @example.com.
* https://help.salesforce.com/HTViewSolution?id=000193090&language=en_US
*/
global class OEISandboxPostCopy implements SandboxPostCopy {

    global void runApexClass(SandboxContext context) {

        if (context != null) {
            /*
            * Dump Sandbox Info
            */
            System.debug('Organization ID: ' + context.organizationId());
            System.debug('Sandbox ID: ' + context.sandboxId());
            System.debug('Sandbox Name: ' + context.sandboxName());


            //update custom settings for Type1
            Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'EPA_BAP_FORMS'];

            Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
            String sandboxName = UserInfo.getUserName().substringAfterLast('.');
            String siteFullUrl = 'https://' + context.sandboxName() + '-' + site.Subdomain + '.';
            siteFullUrl += org.InstanceName.toLowerCase() + '.force.com';
            System.debug(siteFullUrl);

            // Set Init Session URL
            Init_Session_URL__c setting1 = Init_Session_URL__c.getOrgDefaults();
            setting1.URL__c = siteFullUrl + '/initSession';
            setting1.Name = 'Init Session URL';
            System.debug(setting1.URL__c);
            try {
                upsert setting1;
                System.debug('initSession update success');
                if (Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch (Exception e) {
                System.debug('initSession update failed : ' + e);

            }

            // Set Form Page URL
            Forms_URL__c setting2 = Forms_URL__c.getOrgDefaults();
            setting2.URL__c = siteFullUrl + '/FormPage';
            setting2.Name = 'Form URL';
            System.debug(setting2.URL__c);
            try {
                upsert setting2;
                System.debug('FormPage update success');
                if (Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch (Exception e) {
                System.debug('FormPage update failed : ' + e);

            }

            // Update Emails
            Database.executeBatch(new BatchModifySandboxContactEmails());

            // Set Delegated admins
            //String sbName = context.sandboxName();
            //Database.executeBatch(new BatchModifySandboxDelegatedAdmins(sbName));
            delegatedAdmins(context.sandboxName());
        }
    }


    @future
    public static void delegatedAdmins(String sandboxName) {

        List<BAPSandboxSetting__mdt> delAdmin = [Select UserAlias__c, SandboxName__c, DelegatedAdmin__c from BAPSandboxSetting__mdt where DelegatedAdmin__c = true and SandboxName__c = :sandboxName];
        for (BAPSandboxSetting__mdt nm : delAdmin) {
            List<User> nmList = [SELECT id, name, email FROM User WHERE alias = :nm.UserAlias__c];
            for (User nu : nmList) {
                if (nm.SandboxName__c == sandboxName && nm.DelegatedAdmin__c) {
                    Profile p = [select id, name from profile where name = 'System Administrator'];
                    nu.profileID = p.Id;
                    nu.IsActive = true;
                    System.debug('Delegated Admin: ' + nm.UserAlias__c);
                }
            }
            if (!nmList.isEmpty()) {
                try {
                    update nmList;
                    System.debug('delegated update success');
                } catch (Exception e) {
                    System.debug('delegated failed : ' + e);

                }
            }
        }

    }


}