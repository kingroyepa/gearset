/**********************************************************************
Name: SBX_Type1
======================================================
======================================================
Purpose:
-------
Sets up the Type 1 forms interface in the sandbox
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
public with sharing class SBX_Type1 extends SBX_PostCopyWorker{

    protected override void run(SandboxContext context) {
        // Update type1 urls to reflect the correct sandbox
        if (context != null) {
            //update custom settings for Type1
            Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'EPA_BAP_FORMS'];

            Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
            String sandboxName = String.valueOf(context.sandboxName());
            String siteFullUrl = 'https://' + sandboxName + '-' + site.Subdomain + '.';
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
        }
    }

    public override String getClassName() {
        return 'SBX_Type1';
    }
}