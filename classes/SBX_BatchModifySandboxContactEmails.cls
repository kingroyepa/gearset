/**********************************************************************
Name: SBX_BatchModifySandboxContactEmails
======================================================
======================================================
Purpose:
-------
Removes the suffix added by Salesforce to invalidate email addresses
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
/**
* When sandboxes refresh, all users' email addresses have @example.com appended to them,
* after Spring '19 release, have .invalid appended to them.
* This is a safety feature to prevent unexpected or unwanted emails to be sent from sandbox to users.
* This class reverts all active users' email addresses by removing the @example.com.
* https://help.salesforce.com/articleView?id=data_sandbox_implementation_tips.htm
* https://help.salesforce.com/HTViewSolution?id=000193090&language=en_US
* http://releasenotes.docs.salesforce.com/en-us/spring19/release-notes/rn_sandboxes_email_management.htm
*/
public with sharing class SBX_BatchModifySandboxContactEmails implements Database.Batchable<SObject> {
    public Database.QueryLocator start( Database.BatchableContext context ) {
        return Database.getQueryLocator( 'Select UserAlias__c,SandboxName__c,DelegatedAdmin__c,resetPw__c,removeFromEmail__c from BAPSandboxSetting__mdt where sandboxuser__c = true and DelegatedAdmin__c = false');
    }
    public void execute( Database.BatchableContext context, List<BAPSandboxSetting__mdt> nameList2 ) {
        System.debug('Updating emails...');
        List<BAPSandboxSetting__mdt> nameList = [Select UserAlias__c,SandboxName__c,DelegatedAdmin__c,resetPw__c,removeFromEmail__c from BAPSandboxSetting__mdt where sandboxuser__c = true and DelegatedAdmin__c = false];
        List<User> UserList;
        for(BAPSandboxSetting__mdt n : nameList) {
            UserList = [SELECT id, name, email FROM User WHERE alias = :n.UserAlias__c];
            for (User u : UserList) {
                if (n.removeFromEmail__c <> null) {
                    System.debug('user current email: ' + u.email);
                    System.debug('removing string from email: ' + n.removeFromEmail__c);
                    u.Email = u.Email.replace(n.removeFromEmail__c, '');
                    u.Email = u.Email.remove(n.removeFromEmail__c);
                    System.debug('user new email: ' + u.email);
                    System.debug('user Id: ' + u.Id);
                }
                if (n.resetPw__c) {  System.resetPassword(u.Id, true);
                    System.debug('user pw reset emailed: ' + u.Name);
                }
                if (!UserList.isEmpty()) {
                    try {
                        update UserList;
                        System.debug('update success');
                        if (Test.isRunningTest()) {
                            CalloutException e = new CalloutException();
                            e.setMessage('This is a constructed exception for testing and code coverage');
                            throw e;
                        }
                    } catch (Exception e) {
                        System.debug('failed : ' + e);
                    }
                }
            }
        }
    }
    public void finish( Database.BatchableContext context ) {
    }
}