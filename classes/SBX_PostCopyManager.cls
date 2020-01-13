/**********************************************************************
Name: SBX_PostCopyManager
======================================================
======================================================
Purpose:
-------
Manage the postcopy process in the sandbox refresh process per the Custom Metadata Settings

======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development
 
**********************************************************************/
public with sharing class SBX_PostCopyManager implements SandboxPostCopy{

	public void runApexClass(SandboxContext context){
		List<SBX_PostCopyWorker> workerList = SBX_PostCopyWorkerFactory.getWorkers();
		for(SBX_PostCopyWorker worker : workerList){
			worker.process(context);
		}
	}
}