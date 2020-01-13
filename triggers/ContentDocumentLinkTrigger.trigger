/**********************************************************************
Name: ContentDocumentLinkTrigger()
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
trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    Id trainingRecordTypeId = schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();
    List<Id> recordIds = new List<Id>(); 
    if(trigger.isInsert){
        for(ContentDocumentLink cd : Trigger.new){
            recordIds.add(cd.LinkedEntityId);
        }
    }
    
    if(!recordIds.isEmpty()){
        List<Line_Item__C> trainingRecords = [select id, Name, Attachment__c from Line_Item__c where id in :recordIds and recordtype.Name='Training'];
        if(!trainingRecords.isEmpty() && trigger.isInsert){
            system.debug('trainingRecords'+trainingRecords);
            for(Line_Item__c training : trainingRecords ){
                
                training.Attachment__C = true;
            }
            update trainingRecords;
        }
       
    }
}