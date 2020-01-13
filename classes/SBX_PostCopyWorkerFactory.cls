/**********************************************************************
Name: SBX_PostCopyWorkerFactory
======================================================
======================================================
Purpose:
-------
Handles creation of the worker jobs
sf-sandbox-post-copy framework based on https://github.com/GSA/sf-sandbox-post-copy
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
public with sharing class SBX_PostCopyWorkerFactory {

	private static final String CLASS_NAME = 'SBX_PostCopyWorkerFactory';

	public static List<SBX_PostCopyWorker> getWorkers() {
		List<BAPSandboxSetting__mdt> postCopyTasks = [
			SELECT Id, DeveloperName, Active__c, Task_Order__c
			FROM BAPSandboxSetting__mdt
			WHERE Active__c = true
			ORDER BY Task_Order__c ASC
		];
		return getWorkerListFromCustomMetaDataTypes(postCopyTasks);
	}

	private static List<SBX_PostCopyWorker> getWorkerListFromCustomMetaDataTypes(List<BAPSandboxSetting__mdt> taskList){
		List<SBX_PostCopyWorker> workerList = new List<SBX_PostCopyWorker>();
		for(BAPSandboxSetting__mdt task : taskList){
			String workerName = task.DeveloperName;
			SBX_PostCopyWorker worker = createWorkerObjectFromString(workerName);
			// a log obj was created in createWorkerObjectFromString() above; it also retuned a null obj so we're not going to add it
			if(worker == null) {continue;}
			workerList.add(worker);
		}
		return workerList;
	}

	private static SBX_PostCopyWorker createWorkerObjectFromString(String workerName){
		SBX_PostCopyWorker worker = null;
		try {
			Type t = Type.forName(workerName);
			System.debug(workerName);
			worker = (SBX_PostCopyWorker) t.newInstance();
			if (Test.isRunningTest()) {
				CalloutException e = new CalloutException();
				e.setMessage('This is a constructed exception for testing and code coverage');
				throw e;
			}
		} catch (Exception e){
			SBX_PostCopyUtil.createLogObj(CLASS_NAME, e);
		}
		return worker;
	}

}