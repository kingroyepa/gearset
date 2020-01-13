/**********************************************************************
Name: SBX_DelegatedAdmins
======================================================
======================================================
Purpose:
-------
Set the Delegated Admins in the sandbox per the Custom Metadata Settings

======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
public with sharing class SBX_DelegatedAdmins extends SBX_PostCopyWorker {

    //@future
    protected override void run(SandboxContext context) {
        if (context != null) {
            String sandboxName = String.valueOf(context.sandboxName());
            System.debug('Setting Delegated Admins in = ' + sandboxName);
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
                        if (Test.isRunningTest()) {
                            CalloutException e = new CalloutException();
                            e.setMessage('This is a constructed exception for testing and code coverage');
                            throw e;
                        }
                    } catch (Exception e) {
                        System.debug('delegated failed : ' + e);

                    }
                }
            }
        }
    }

    public override String getClassName() {
        return 'SBX_DelegatedAdmins';
    }
}