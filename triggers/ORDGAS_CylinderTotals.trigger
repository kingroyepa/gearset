/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-June-2018
*    Class Name : ORDGAS_CylinderTotals
*    On record update, this trigger checks status and updates related Cylinders (Line Items)
**/

trigger ORDGAS_CylinderTotals on Line_Item__c(after Update) {
    //Gets related RecordTypes for GAS Cylinders
    Id recordTypeId = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders').getRecordTypeId();
    Id recordTypeIdReturn = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('GAS Cylinders Return').getRecordTypeId();
    
    //When Cylinders are related to an Order Request
    if(trigger.New[0].Order_Request__c !=null  && (trigger.New[0].RecordTypeId == recordTypeId || trigger.New[0].RecordTypeId == recordTypeIdReturn)){
        List<eOrder_Item__c> items = [SELECT id,Quantity__c from eOrder_Item__c where Order_Request__c =: trigger.New[0].Order_Request__c and Quantity__c != 0 ];
        Decimal total = 0;
        //Total Number of Expected GAS Cylinders
        for(eOrder_Item__c item : items){
            total = total+item.Quantity__c;
        }
        integer count = [SELECT COUNT() from Line_Item__c where Order_Request__c =: trigger.New[0].Order_Request__c and (RecordTypeId =:recordTypeId OR RecordTypeId =:recordTypeIdReturn)];
        Order_Request__c orderRequest = [Select id,Stage__c,Total_Quantity__c from Order_Request__c where id =: trigger.New[0].Order_Request__c];
        orderRequest.Total_Quantity__c = total;
        //Actual Total Number of GAS Cylinders
        integer totalQuantity = Integer.ValueOf(total);
        //If Actual Total is less than Expected Total Number of GAS Cylinders
        if(totalQuantity > count){
            orderRequest.Stage__c = 'Partial Order Received';
            
        }
        if(totalQuantity == count){
            Integer closedCylinders = [SELECT COUNT() from Line_Item__c where Order_Request__c =: trigger.New[0].Order_Request__c and (Status__c = 'Closed' OR Status__c = 'Cylinder Return Request' OR Status__c = 'Cylinder Return Confirmed') and (RecordTypeId =:recordTypeId OR RecordTypeId =:recordTypeIdReturn)];
            //If Actual Total is Closed (or higher status) and is equal to the Expected Total Number of GAS Cylinders
            if(closedCylinders == totalQuantity){
                orderRequest.Stage__c = 'Order Fulfilled';
                List<eOrder_Item__c> eorderItems = [SELECT id,X1900_63__c , X1900_63_Generated_Date__c  from eOrder_Item__c where Order_Request__c =: trigger.New[0].Order_Request__c  ];
                for( eOrder_Item__c eorderitem : eorderItems){
                    eorderitem.X1900_63__c = true;
                    eorderitem.X1900_63_Generated_Date__c = system.today();
                }
                update eorderItems;
                
            }else{
            //If Actual Total is Closed (or higher status) and is NOT equal to the Expected Total Number of GAS Cylinders
                orderRequest.Stage__c = 'Full Order Received';
            }
        }
        update orderRequest;

        
    } 
    //Relates Cylinders to an Order Request when Serial Number is entered
    else if(trigger.New[0].Serial_Number__c != null && trigger.Old[0].Serial_Number__c == null && trigger.New[0].eOrder_Item__c != null ){
        eOrder_Item__c item = [SELECT id,Quantity__c,Order_Request__c,Order_Request__r.Ownerid from eOrder_Item__c where id =:trigger.New[0].eOrder_Item__c];
        Line_Item__c lineItem = [select id , Order_Request__c from Line_Item__c where id =:trigger.New[0].id];
        lineItem.Order_Request__c = item.Order_Request__c;
        lineItem.Captured_Date__c = system.today();
        lineItem.Ownerid = item.Order_Request__r.Ownerid;
        update lineItem;
        
    }
    //Updates Cylinders recordtype, status, and re-calculates totals when Serial Number is confirmed
    if(trigger.New[0].Serial_Number_Confirmation__c !=null && trigger.Old[0].Serial_Number_Confirmation__c == null ){
        Line_Item__c lineItem = [select id , Order_Request__c from Line_Item__c where id =:trigger.New[0].id];
        lineItem.Status__c = 'Closed' ;
        lineItem.Received_Date__c = system.today();
        lineItem.RecordTypeId = recordTypeIdReturn;
        update lineItem ;
        Integer closedCylinders = [SELECT COUNT() from Line_Item__c where eOrder__c =: trigger.New[0].eOrder__c AND (Status__c = 'Closed' OR Status__c = 'Cylinder Return Request' OR Status__c = 'Cylinder Return Confirmed') AND (RecordTypeId =:recordTypeId OR RecordTypeId =:recordTypeIdReturn)];
        eOrders__c eorder = [Select id , Total_Quantity__c from eOrders__c where id =: trigger.New[0].eOrder__c];
        if(closedCylinders == integer.ValueOf(eorder.Total_Quantity__c)){
            eorder.Status__c = 'Order Closed';
            update eorder;
        }
        Integer closedCylindersForEItem = [SELECT COUNT() from Line_Item__c where eOrder_Item__c =: trigger.New[0].eOrder_Item__c AND (Status__c = 'Closed' OR Status__c = 'Cylinder Return Request' OR Status__c = 'Cylinder Return Confirmed') AND (RecordTypeId =:recordTypeId OR RecordTypeId =:recordTypeIdReturn)];
        eOrder_Item__c eorderitems = [SELECT id,Quantity__c from eOrder_Item__c where id =: trigger.New[0].eOrder_Item__c ];
        if(closedCylindersForEItem == integer.ValueOf(eorderitems.Quantity__c)){
            eorderitems.Status__c = 'Order Delivered';
            update eorderitems;
        }
    }
    
}