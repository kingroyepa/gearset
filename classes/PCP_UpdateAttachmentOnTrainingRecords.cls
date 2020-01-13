/**********************************************************************
Name: PCP_UpdateAttachmentOnTrainingRecords
======================================================
======================================================
Purpose: PCP Application. This batch script runs one time for updating the value when there is content document attached to training.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR 		  DATE 		 DETAIL 			 FEATURES/CSR/TTP
1.0 	Mounika Suram 02/14/2019 INITIAL DEVELOPMENT CSR:PCP Application
***********************************************************************/
public class PCP_UpdateAttachmentOnTrainingRecords implements Database.Batchable<sObject> {
    Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
    public final String query = 'select id, Name, Attachment__c from Line_Item__c where recordtypeid=:trainingRecordTypeId';
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext BC, List<Line_Item__C> scope){
        for (Line_Item__C training:scope){
            List<ContentDocumentLink> docs = [select id from ContentDocumentLink where LinkedEntityId=:training.Id FOR Update];
            system.debug('docs'+docs);
            if(docs.size() >= 1){
                training.Attachment__C = true;
            }
            update scope;
        }
    }
    public void finish(Database.BatchableContext BC){}
}