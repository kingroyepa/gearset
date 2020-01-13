/**********************************************************************
Name: FTTA_CopyEPAFileBatch
======================================================
======================================================
Purpose: FTTA Application. This batch script runs one time for copying the values from 
the EPA file# formula to the EPA File #(text) which is created for the sequencing of the agreement,amendment and license.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR 		  DATE 		 DETAIL 			 FEATURES/CSR/TTP
1.0 	Mounika Suram 02/13/2019 INITIAL DEVELOPMENT CSR:FTTA Application
***********************************************************************/
public class FTTA_CopyEPAFileBatch implements Database.Batchable<sObject> {
    public final String query = 'select id,Name,EPA_File__c,EPA_File_2__c from EPA_Agreement__C where EPA_File_2__c = null';
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<EPA_Agreement__C> scope){
        for (EPA_Agreement__C agreement:scope){
            agreement.EPA_File_2__c =agreement.EPA_File__c;
        }
        update scope;
    }
    public void finish(Database.BatchableContext BC){}
}