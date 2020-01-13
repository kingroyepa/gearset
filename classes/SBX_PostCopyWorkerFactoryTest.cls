/**********************************************************************
Name: SBX_PostCopyWorkerFactoryTest
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
 
**********************************************************************
*
*	WARNING: Custom Metadata Types cannot be created in a test class, so we need to depend on having existing metadata available.
*	The Custom Metadata Type we're using is called a Post Copy Task (PCT). This is used to identify the names of classes that should be
*	executed after a refresh. The named classes implement a custom type called SBX_PostCopyWorker (Post Copy Worker or PWC). These tests
*	need to verify the following:
*		1. Need at least two PCTs
*		2. One PCT can create a valid PCW - this means a PCT has the name of a class that implements PCW
*		3. One PCT needs to be invalid and not able to create a PCW - the name of the PCT does not match an existing class name
*/
@isTest
public with sharing class SBX_PostCopyWorkerFactoryTest {

	/**
	*	See warning at top
	*/
	static testMethod void testGetWorkers_GetPostCopyWorkers_VerifySomeExist(){
		List<SBX_PostCopyWorker> workerList = SBX_PostCopyWorkerFactory.getWorkers();
		System.assertNotEquals(0, workerList.size());
	}

	/**
	*	See warning at top
	*/
	static testMethod void testGetWorkers_GetPCWsAndPCTs_VerifyCountDoesntMatch(){
		List<BAPSandboxSetting__mdt> pctList = [SELECT Id FROM BAPSandboxSetting__mdt];
		List<SBX_PostCopyWorker> workerList = SBX_PostCopyWorkerFactory.getWorkers();
		System.assertNotEquals(pctList.size(), workerList.size());
	}

}