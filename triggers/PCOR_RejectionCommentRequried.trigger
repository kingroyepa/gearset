/**********************************************************************
Name: PCOR_ApprovalCommentRequried()
======================================================
======================================================
Purpose:
-------
To impose the comments required validation when the approvers are rejecting the request.
======================================================
======================================================
History
-------
VERSION AUTHOR 		   DATE 	DETAIL 							FEATURES/CSR/TTP
1.0    Mounika Suram 8/2/2018 Initial development				 PCOR
1.0	 Mounika Suram 9/11/2018 Updated Trigger with validation 	 PCOR
to check for funding items 
1.0    Mounika Suram 10/4/2018 Updated to check for line items 	 PCOR
1.0    Mounika Suram 7/23/2019 Added Amendments validation 	 	 PCOR
*******************************************************************/


trigger PCOR_RejectionCommentRequried on Order_Request__c (before update) {
    System.debug('In PCOR_RejectionCommentRequried');
    // get the purchase order request record type
    Id purchaseOrderRecordTypeId = [select id from RecordType where developername='Purchase_Card_Order_Request'].Id;
    //Id amendmentRecordTypeId = [select id from RecordType where developername='PCOR_Amendment'].Id;
    //stores the rejected orders
    Map<Id, Order_Request__c> rejectedOrders= new Map<Id, Order_Request__c>{};
        Map<Id, Order_Request__c> noFundingOrders= new Map<Id, Order_Request__c>{};
            List<Line_Item__C> pcorItems = new List<Line_Item__C>();
    if(trigger.isBefore && trigger.isUpdate){
        for(Order_Request__c order: trigger.new)
        {
            //Get the old record
            Order_Request__c oldOrder = System.Trigger.oldMap.get(order.Id);
            // check for the status change to 'Draft' which lists out the rejected orders
            if(order.RecordTypeId==purchaseOrderRecordTypeId ){
//            if(order.RecordTypeId==purchaseOrderRecordTypeId || order.RecordTypeId==amendmentRecordTypeId){
                Decimal totalAmount = 0.0;
                system.debug('is After and is Insert');
                pcorItems= [select id, Total__c from Line_Item__C where PCOR_Order_Request__c = :order.Id];
                if(!pcorItems.isEmpty()){
                    system.debug('Items'+pcorItems);
                    for(Line_item__C item : pcorItems ){
                        totalAmount += (item.Total__c <> null)? item.Total__c : 0.0;
                    }
                    order.Order_Request_Total__c = totalAmount;
                }
                if (oldOrder.Request_Status__c != 'Draft' && order.Request_Status__c == 'Draft' )
                {
                    rejectedOrders.put(order.Id, order);
                    System.debug('rejectedOrders'+rejectedOrders);
                }
                else if (oldOrder.Request_Status__c != 'Approved' && order.Request_Status__c == 'Approved')
                {
                    //Accounting_Line__c aL=new Accounting_Line__c();
                    Integer count = [select count() from Accounting_Line__c where Order_Request__c=:order.id];
                    System.debug('Accounting Line count'+count);
                    if(count == 0)
                    {
                        noFundingOrders.put(order.Id, order);
                        System.debug('noFundingOrders'+noFundingOrders);
                    }
                }
                else if (oldOrder.Request_Status__c != 'Awaiting Approval' && order.Request_Status__c == 'Awaiting Approval')
                {
                    System.debug('Pcor Items count'+pcorItems.size());
                    if(pcorItems.isEmpty())
                    {
                        order.addError('Operation Cancelled: Please add items for the purchase order request and try again.');                
                    }
                }
                else if (order.Request_Status__c == 'Awaiting Approval' && order.Assigned_to__c!=oldOrder.Assigned_to__c)// && order.Card_Holder__c==userinfo.getuserid()
                {
                    System.debug('Pcor Items count'+pcorItems.size());
                    if(!order.SAM_Link__c)
                    {
                        order.addError('Operation Cancelled: System for Award Management field is required.');                
                    }
                }
            }
        }
        
    }
    
    
    if (!rejectedOrders.isEmpty())
    {
        //get the most recent process instances related to the target object
        List<Id> processInstanceIds = new List<Id>{};
            
            for (Order_Request__c orders : [SELECT (SELECT ID
                                                    FROM ProcessInstances
                                                    ORDER BY CreatedDate DESC
                                                    LIMIT 1)
                                            FROM Order_Request__c
                                            WHERE ID IN :rejectedOrders.keySet()])
        {
            processInstanceIds.add(orders.ProcessInstances[0].Id);
        }
        
        // for each instance get the process step and comments
        for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                                   FROM ProcessInstance
                                   WHERE Id IN :processInstanceIds
                                   ORDER BY CreatedDate DESC])
        {
            if ((pi.Steps[0].Comments == null ||
                 pi.Steps[0].Comments.trim().length() == 0))
            {
                rejectedOrders.get(pi.TargetObjectId).addError(
                    'Operation Cancelled: Please provide a rejection reason.');
            }
        }
    }
    if (!noFundingOrders.isEmpty())
    {
        
        //get the most recent process instances related to the target object
        List<Id> processInstanceIds = new List<Id>{};
            
            for (Order_Request__c orders : [SELECT (SELECT ID
                                                    FROM ProcessInstances
                                                    ORDER BY CreatedDate DESC
                                                    LIMIT 1)
                                            FROM Order_Request__c
                                            WHERE ID IN :noFundingOrders.keySet()])
        {
            if(!orders.ProcessInstances.isEmpty())
                processInstanceIds.add(orders.ProcessInstances[0].Id);
            
        }
        if(!processInstanceIds.isEmpty()){
            // for each instance get the process step and comments
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                       (SELECT Id, StepStatus, Comments
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC])
            {
                System.debug('ProcessInstance'+pi);
                noFundingOrders.get(pi.TargetObjectId).addError(
                    'Operation Cancelled: Please add atleast one funding item.');
                
            }
        }
    }
}