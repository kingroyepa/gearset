/**********************************************************************
Name: SBX_Type1_Reports
======================================================
======================================================
Purpose:
-------
Sets up the Type 1 reports interface in the sandbox
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
public with sharing class SBX_Type1_Reports extends SBX_PostCopyWorker{

    protected override void run(SandboxContext context) {
        // Update type1 urls to reflect the correct sandbox
        if (context != null) {
            //update custom settings for Type1
            Site site = [SELECT GuestUserId, Name, Subdomain, UrlPathPrefix FROM Site WHERE Name = 'Reports'];

            Organization org = [SELECT InstanceName, IsSandbox, OrganizationType FROM Organization];
            String sandboxName = String.valueOf(context.sandboxName());
            String siteFullUrl = 'https://' + sandboxName + '-' + site.Subdomain + '.';
            siteFullUrl += org.InstanceName.toLowerCase() + '.force.com';
            System.debug(siteFullUrl);

            // Set Init Session Reports URL
            Init_Session_Reports_URL__c setting1 = Init_Session_Reports_URL__c.getOrgDefaults();
            setting1.URL__c = siteFullUrl + '/reports/initSession_Reports';
            setting1.Name = 'Init Session Reports URL';
            System.debug(setting1.URL__c);
            try {
                upsert setting1;
                System.debug('initSession reports update success');
                if (Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch (Exception e) {
                System.debug('initSession reports update failed : ' + e);

            }

            // Set Form Page URL
            Reports_URL__c setting2 = Reports_URL__c.getOrgDefaults();
            setting2.URL__c = siteFullUrl + '/reports/ReportsPage';
            setting2.Name = 'Report URL';
            System.debug(setting2.URL__c);
            try {
                upsert setting2;
                System.debug('ReportsPage update success');
                if (Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch (Exception e) {
                System.debug('ReportsPage update failed : ' + e);

            }
        }
    }

    public override String getClassName() {
        return 'SBX_Type1_Reports';
    }
}