/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 7-May-2018
*    Class Name : STAAAplicationCommentsRequired
*    This trigger requires the Comments to be filled in at the time of Approval/Rejection. Then those Comments are inputted into a designated field on the Object
*
**/
trigger STAAApplicationCommentsRequired on Cover_Form__c (before update) {
  Map<Id, Cover_Form__c> coverformsById = new Map<Id, Cover_Form__c>{};


Id RecordTypeIdToFilterBy = Schema.SObjectType.Cover_Form__c.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();

  for(Cover_Form__c cover_form: trigger.new){
    Cover_Form__c oldCF = System.Trigger.oldMap.get(cover_form.Id);
    if (((oldCF.Status__c != 'DRAFT' && cover_form.Status__c == 'DRAFT') || (oldCF.Status__c != 'LOCKED2' && cover_form.Status__c == 'LOCKED2') || (oldCF.Status__c != 'FINAL' && cover_form.Status__c == 'FINAL'))&& cover_form.RecordTypeId == RecordTypeIdToFilterBy){ 
      coverformsById.put(cover_form.Id, cover_form);  
    }
  }
   
  if (!coverformsById.isEmpty())  
  {
    // Get the most recent approval process instance for the object.
    // If there are some approvals to be reviewed for approval, then
    // get the most recent process instance for each object.
    List<Id> processInstanceIds = new List<Id>{};
    for (Cover_Form__c covfrms : [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM Cover_Form__c
                                      WHERE ID IN :coverformsById.keySet()])
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
       if (String.isBlank(pi.Steps[0].Comments)){
        coverformsById.get(pi.TargetObjectId).addError(
          'Operation Cancelled: Please provide a comment');
      }
      
    }  
  }
}