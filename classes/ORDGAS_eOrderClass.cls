/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORGGAS_eOrderClass
*    On record update, this trigger checks status and creates related Cylinders (Line Items)
**/

public without sharing class ORDGAS_eOrderClass{
    public static void ActivatedStatus(eOrders__c eOrder, map<id,eOrders__c> eOrderOldMap){
        if((eOrder.Status__c == 'Full Order Received' || eOrder.Status__c == 'Partial Order Received') &&  eOrder.Status__c != eOrderOldMap.get(eOrder.Id).Status__c  ){
            Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
            List<eOrder_Item__c> eOrderItemUpdate = new List<eOrder_Item__c>();
            List<Line_Item__c> itemToInsert = new List<Line_Item__c>();
            List<eOrder_Item__c> eOrderItemList  = [SELECT eOrder__c,Order_Request__r.Ownerid,Id,Item_Price__c,Name,Order_Request__c,OwnerId,Product_Active__c,
                                                    Product_Code__c,Product_Description__c,Product_Type__c,Product_Vendor__c,Product__c,
                                                    Quantity__c,Status__c,Total_Price__c FROM eOrder_Item__c where Status__c = 'Order Placed' AND eOrder__c =:eOrder.id ];
            for(eOrder_Item__c eorderItem : eOrderItemList){
                eorderItem.Status__c = 'Order Received';
                eOrderItemUpdate.add(eorderItem);
                for(integer i = 0;i<eorderItem.Quantity__c ; i++){
                    
                    Line_Item__c lineItem = getLineItems();
                    lineItem.Product__c = eorderItem.Product__c;
                    lineItem.Status__c= 'Open';
                    lineItem.Item_Price__c = eorderItem.Item_Price__c;
                    //lineItem.Order_Request__c = eorderItem.Order_Request__c;
                    lineItem.eOrder_Item__c = eorderItem.id;
                    lineItem.eOrder__c = eOrder.id;
                    //lineItem.Ownerid = eorderItem.Order_Request__r.Ownerid;
                    lineItem.Ownerid = eOrder.Ownerid;
                    lineItem.RecordTypeId = recordTypeId;
                    itemToInsert.add(lineItem);
                }
                
            }
            if(!eOrderItemUpdate.IsEmpty()){
                Database.update(eOrderItemUpdate);
            }
            if(!itemToInsert.IsEmpty()){
                Database.SaveResult[] savedResults = Database.insert(itemToInsert, false);
                Boolean someFailure = false;
                for (Database.SaveResult sr : savedResults) 
                {
                    if(sr.isSuccess())
                    {
                        System.debug('All Cylinder records inserted successfully');
                    }                   
                }
            }
        }
    }
    public static Line_Item__c getLineItems(){
        Line_Item__c lineItem = new Line_Item__c();
        return lineItem;
        
    }
}