/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 11-June-2018
*    Class Name : ORDGAS_OrderRequestCommentsRequired
*    This trigger requires the Comments to be filled in at the time of Approval/Rejection. Then those Comments are input into a designated field on the Object
*
**/
trigger ORDGAS_OrderRequestCommentsRequired on Order_Request__c (before update) {
  Map<Id, Order_Request__c> orderrequestById = new Map<Id, Order_Request__c>{};


Id RecordTypeIdToFilterBy = Schema.SObjectType.Order_Request__c.getRecordTypeInfosByName().get('GAS Order Request').getRecordTypeId();

  for(Order_Request__c order_req: trigger.new){
    Order_Request__c oldOR = System.Trigger.oldMap.get(order_req.Id);
    if ((oldOR.Stage__c != 'New Order' && order_req.Stage__c == 'New Order') && order_req.RecordTypeId == RecordTypeIdToFilterBy){ 
      orderrequestById.put(order_req.Id, order_req);  
    }
  }
   
  if (!orderrequestById.isEmpty())  
  {
    // Get the most recent approval process instance for the object.
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    for (Order_Request__c covfrms : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM Order_Request__c
                                      WHERE ID IN :orderrequestById.keySet()])
    {
        processInstanceIds.add(covfrms.ProcessInstances[0].Id);
    }

    // Now that we have the most recent process instances, we can check
    // the most recent process steps for comments.  
    for (ProcessInstance pi : [SELECT TargetObjectId,
                                   (SELECT Id, StepStatus, Comments 
                                    FROM Steps
                                    ORDER BY CreatedDate DESC
                                    LIMIT 1 )
                               FROM ProcessInstance
                               WHERE Id IN :processInstanceIds
                               ORDER BY CreatedDate DESC])   
    {                   
      if ((pi.Steps[0].Comments == null || pi.Steps[0].Comments.trim().length() == 0)){
        orderrequestById.get(pi.TargetObjectId).addError(
          'Operation Cancelled: Please provide a comment');
      }
      
    }  
  }
}