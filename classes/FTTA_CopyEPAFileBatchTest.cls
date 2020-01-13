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
@isTest
public class FTTA_CopyEPAFileBatchTest {
    private static id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
	@isTest
    static void testBatch(){
        Test.startTest();
        Id jobId = Database.executeBatch(new FTTA_CopyEPAFileBatch());
        Test.stopTest();
    }
    @testSetup
    static void createAgreements(){
        List<EPA_Agreement__C> agreements = new List<EPA_Agreement__C>();
        for(Integer i = 1;i<=8;i++){
            agreements.add(new EPA_Agreement__C(RecordTypeId=agreementRecordTypeId,title__c='test'+i) );
        }
       
        insert agreements;
    }
    
}