/**********************************************************************
Name: ContentDocumentTrigger()
======================================================
======================================================
Purpose: Updates the attachment field on the training Line item
-------
======================================================
======================================================
History
-------
VERSION 	AUTHOR 	DATE 		DETAIL 				FEATURES/CSR/TTP
1.0 - Mounika Suram 03/13/2019 INITIAL DEVELOPMENT CSR:PCP
***********************************************************************/
trigger ContentDocumentTrigger on ContentDocument (before delete) {

    Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
    List<Id> recordIds = new List<Id>(); 
    if(trigger.isDelete){
        Set<Id> contentDocumentIds = trigger.oldMap.keyset();
        List<ContentDocumentLink> trainingDocLinks = [select id, LinkedEntityId,ContentDocumentId from 
                                                      ContentDocumentLink where ContentDocumentId IN :contentDocumentIds];
        
        if(!trainingDocLinks.isEmpty()){
            for(contentDocumentLink cdl : trainingDocLinks){
                recordIds.add(cdl.LinkedEntityId);
            }
        }
        if(!recordIds.isEmpty()){
            List<Line_Item__C> trainingRecords = [select id, Name, Attachment__c from Line_Item__c where id in :recordIds and recordtype.Name='Training'];
            if(!trainingRecords.isEmpty() && trigger.isDelete){
            for(Line_Item__c training : trainingRecords ){
                List<ContentDocumentLink> docs = [select id from ContentDocumentLink where LinkedEntityId=:training.Id];
                system.debug('docs'+docs);
                if(docs.size()<=1){
                training.Attachment__C = false;
                }
            }
            update trainingRecords;
        	}
        }
	}
}