/**********************************************************************
Name: SBX_PostCopyManager
======================================================
======================================================
Purpose:
-------
sf-sandbox-post-copy framework based on https://github.com/GSA/sf-sandbox-post-copy
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
@isTest
public with sharing class SBX_PostCopyManagerTest {

	static testMethod void testRunApexClass_InitiateSandboxRefresh_VerifyPostCopyLogsWereCreated(){
		SBX_PostCopyManager manager = new SBX_PostCopyManager();
		/**
		* The following sandboxpostcopy test takes these params: apex class name, org Id, sandbox Id, and sandboxName.
		* The org Id and sandbox Id can be any valid object Id... As of 4/27/16 I've seen example of passing Account Ids
		* 	into these two parameters and the test working as expected
		*/
		Test.testSandboxPostCopyScript(manager, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'test');
		List<Metadata__c> logList = [SELECT Id FROM Metadata__c LIMIT 2];
		System.assertNotEquals(0, logList.size());
	}
}