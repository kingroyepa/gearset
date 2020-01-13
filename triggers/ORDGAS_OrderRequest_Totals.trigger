/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 10-August-2018
*    Class Name : ORDGAS_OrderRequest_Totals
*    Calculates total quantity and dollar amount of all related eOrderItems for an approved Order Request
**/

trigger ORDGAS_OrderRequest_Totals on Order_Request__c (after delete, after insert, after undelete, after update, before delete, before insert, before update){

    //Gets GAS eOrder RecordTypes
    Id recordTypeId = Schema.SObjectType.Order_Request__c.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();
    if (Trigger.isBefore){
        
    } else {
        if (Trigger.isUpdate && Trigger.IsAfter && trigger.New[0].RecordTypeId == recordTypeId){
            Order_Request__c orderReq = new Order_Request__c();
            if(trigger.New[0].Stage__c == 'Request Approved'){
                Id OReqID  = trigger.new[0].id;
                //Queries Approved eOrderItems 
                List<eOrder_Item__c> eorderitems_to_update = [SELECT Id,Order_Request__c, Total_Price__c, Quantity__c FROM eOrder_Item__c WHERE Order_Request__r.Id =: OReqID];
                Decimal dec = 0.0;
                Double quan = 0;          
                for (eOrder_Item__c eorder_item: eorderitems_to_update){
                    dec += eorder_item.Total_Price__c;
                    quan += eorder_item.Quantity__c;                   
                }
                orderReq = [Select id,Order_Request_Total__c,Total_Quantity__c from Order_Request__c where id=:OReqID];
                //Gets eOrder Totals
                orderReq.Order_Request_Total__c = dec;
                orderReq.Total_Quantity__c  = quan;
                
                if(Trigger.New[0].Order_Request_Total__c != dec && Trigger.New[0].Total_Quantity__c != quan){
                update orderReq;
                }

            }
            
        }
    }
}