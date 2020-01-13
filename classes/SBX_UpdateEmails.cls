/**********************************************************************
Name: SBX_UpdateEmails
======================================================
======================================================
Purpose:
-------
Launched a batch script to update invalid email addresses based on custom metadata information
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/

public with sharing class SBX_UpdateEmails extends SBX_PostCopyWorker{

    protected override void run(SandboxContext context) {
        // Update Emails to make them valid
        // Requires running in batchable to allow for resetPW to work
        Database.executeBatch(new SBX_BatchModifySandboxContactEmails());
    }

    public override String getClassName() {
        return 'SBX_UpdateEmails';
    }
}