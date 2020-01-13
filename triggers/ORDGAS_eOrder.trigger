/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_eOrder
*    On record creation, this trigger attaches eOrdet Items who have a related Vendor
*    On record update, this trigger checks status and creates related Cylinders (Line Items)
**/

trigger ORDGAS_eOrder on eOrders__c (after delete, after insert, after undelete, after update, before delete, before insert, before update){

    //Gets GAS eOrder RecordTypes
    Id recordTypeId = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Admin').getRecordTypeId();
    Id recordTypeIdReturn = Schema.SObjectType.eOrders__c.getRecordTypeInfosByName().get('GAS eOrder Return').getRecordTypeId();  

    if (Trigger.isBefore){
        
    } else {
        
        if (Trigger.isInsert){
         
        //Creation of eOrder Admin Record
        if(trigger.New[0].RecordTypeId == recordTypeId){
            eOrders__c eorderIns = new eOrders__c();
            if(trigger.new[0].Vendor_Name__c != null && trigger.new[0].Organization_Name__c != null){
                // Mounika Suram 10/15/2018 Added the functionality to filter the eorder items by organization and vendor.
                String orgName = [select id, name from Account where id =:trigger.new[0].Organization_Name__c].Name;
               
                Id vendor  = trigger.new[0].Vendor_Name__c;

                //Queries Approved eOrderItems 
                List<eOrder_Item__c> eorderitems_to_update = [SELECT Id,eOrder__c,Status__c,
                        Total_Price__c, Quantity__c, Vendor_Name__c, Product__r.Vendor__r.Id , Order_Request__r.Requester_Org__c FROM eOrder_Item__c
                WHERE eOrder__c = null AND Status__c = 'Request Approved' AND Product__r.Vendor__r.Id =: vendor AND Order_Request__r.Requester_Org__c =:orgName];
				
                Decimal dec = 0.0;
                Double quan = 0;          
                for (eOrder_Item__c eorder_item: eorderitems_to_update){
                    dec += eorder_item.Total_Price__c;
                    quan += eorder_item.Quantity__c;
                    eorder_item.Status__c = 'Added to Order';
                    eorder_item.Vendor_Name__c = eorder_item.Product__r.Vendor__r.Id;
                    eorder_item.eOrder__c = Trigger.New[0].Id;
                    
                }
                eorderIns = [Select id,Order_Amount__c,Total_Quantity__c from eOrders__c where id=:Trigger.new[0].id];
                //Gets eOrder Totals
                eorderIns.Order_Amount__c = dec;
                eorderIns.Total_Quantity__c  = quan;
                
                update eorderIns;
                If(!eorderitems_to_update.isEmpty()){
                    update eorderitems_to_update;
                }else{
                    trigger.New[0].addError('eOrder cannot be created. The chosen Vendor and Organization has no open Order Requests associated with it.');
                }
            }
            
          } 
           
           
           //Attaches Cylinders to Return eOrders
           if(trigger.New[0].RecordTypeId == recordTypeIdReturn){
                eOrders__c eorderIns = new eOrders__c();
                if(trigger.new[0].Vendor_Name__c != null && trigger.new[0].Organization_Name__c != null){
                     // Mounika Suram 10/15/2018 Added the functionality to filter the eorder items by organization and vendor.
               		 String orgName = [select id, name from Account where id =:trigger.new[0].Organization_Name__c].Name;
                    Id vendor  = trigger.new[0].Vendor_Name__c;
                    //Queries Cylinders (LineItems) ready for pick-up
                    List<Line_Item__c> lineitems_to_update = [SELECT Id,eOrder_Return__c, Status__c FROM Line_Item__c WHERE Status__c = 'Cylinder Return Request' AND Product__r.Vendor__r.Id =: vendor AND Order_Request__r.Requester_Org__c =:orgName ];
                    //Loops through Cylinders (LineItems)        
                    for (Line_Item__c line_item: lineitems_to_update){
                        line_item.Status__c = 'Cylinder Return Confirmed';
                        line_item.eOrder_Return__c= Trigger.New[0].Id;
                    }
                    if(!lineitems_to_update.IsEmpty()){
                        update lineitems_to_update;
                    }else{
                        trigger.New[0].addError('eOrder cannot be created. The chosen Vendor has no open Cylinder Return Requests associated with it.');
                    }
                }
               
           }
            
            
            
        }
         //Creates Cylinders (Line Items) when status is Updated
         if (Trigger.isUpdate){
            if(Trigger.IsAfter ){
                if(trigger.new[0].RecordTypeId == recordTypeId){
                    ORDGAS_eOrderClass.ActivatedStatus(trigger.new[0], Trigger.oldMap);
                }
                if(trigger.new[0].status__c == 'Order Placed' && trigger.old[0].status__c != trigger.new[0].status__c ){
                    List<eorder_item__c> eOrderItemsToUpdated = new List<eorder_item__c>();
                    for(eorder_item__c eorderItems : [SELECT Id,eOrder__c,Status__c, Total_Price__c, Quantity__c, Vendor_Name__c, Product__r.Vendor__r.Id FROM eOrder_Item__c WHERE eOrder__c =: trigger.new[0].Id]){
                        eorderItems.status__c= 'Order Placed';
                        eOrderItemsToUpdated.add(eorderItems);
                        
                    }
                    if(!eOrderItemsToUpdated.IsEmpty()){
                        update eOrderItemsToUpdated;
                    }
                }
            }
            
         }
    }
}