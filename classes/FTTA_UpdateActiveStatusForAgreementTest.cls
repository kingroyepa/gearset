/**********************************************************************
Name: FTTA_UpdateActiveStatusForAgreementTest
======================================================
======================================================
Purpose: 
-------
======================================================
======================================================
History
-------
VERSION AUTHOR 		  DATE 		 DETAIL 			 FEATURES/CSR/TTP
1.0 	Mounika Suram 04/5/2019 INITIAL DEVELOPMENT CSR:FTTA Application
***********************************************************************/
@isTest
public class FTTA_UpdateActiveStatusForAgreementTest {
private static id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
	@isTest
    static void testBatch(){
        Test.startTest();
        Id jobId = Database.executeBatch(new FTTA_UpdateActiveStatusForAgreement());
        Test.stopTest();
    }
    @testSetup
    static void createAgreements(){
        List<EPA_Agreement__C> agreements = new List<EPA_Agreement__C>();
        for(Integer i = 1;i<=8;i++){
            agreements.add(new EPA_Agreement__C(RecordTypeId=agreementRecordTypeId,active__C=false,title__c='test'+i) );
        }
       
        insert agreements;
    }
}