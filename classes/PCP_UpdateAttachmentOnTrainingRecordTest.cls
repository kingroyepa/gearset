/**********************************************************************
Name: PCP_UpdateAttachmentOnTrainingRecordTest
======================================================
======================================================
Purpose: PCP Application.Tests the PCP_UpdateAttachmentOnTrainingRecord class.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR 		  DATE 		 DETAIL 			 FEATURES/CSR/TTP
1.0 	Mounika Suram 02/14/2019 INITIAL DEVELOPMENT CSR:FTTA Application
***********************************************************************/
@isTest
public class PCP_UpdateAttachmentOnTrainingRecordTest {
	Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
	@isTest
    static void testBatch(){
        Test.startTest();
        Id jobId = Database.executeBatch(new PCP_UpdateAttachmentOnTrainingRecords());
        Test.stopTest();
    }
    @testSetup
    static void createTraining(){
        Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
        List<Line_Item__C> trainings = new List<Line_Item__C>();
        for(Integer i = 1;i<=8;i++){
            trainings.add(new Line_Item__C(RecordTypeId=trainingRecordTypeId,Course_Title__c= 'PCard Agency Supplemental Training'));
            
        }
       
        insert trainings;
    }
}