/**********************************************************************
Name: FTTA_UpdateActiveStatusForAgreement
======================================================
======================================================
Purpose: 
-------
======================================================
======================================================
History
-------
VERSION AUTHOR 		  DATE 		 DETAIL 			 FEATURES/CSR/TTP
1.0 	Mounika Suram 04/3/2019 INITIAL DEVELOPMENT CSR:FTTA Application
***********************************************************************/
public class FTTA_UpdateActiveStatusForAgreement implements Database.Batchable<sObject> {
 	Private String ageementRTName='FTTA_EPA_Agreement';
    Private String licenseRTName='FTTA_License';

    public final String query = 'select id,Name,active__C,recordType.DeveloperName from epa_Agreement__c where recordType.developerName =:ageementRTName OR recordType.developerName =:licenseRTName';
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<EPA_Agreement__C> scope){
        for (EPA_Agreement__C agreement:scope){
            agreement.active__C =true;
        }
        update scope;
    }
    public void finish(Database.BatchableContext BC){}

}