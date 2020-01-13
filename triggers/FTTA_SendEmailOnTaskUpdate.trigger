/**********************************************************************
Name: FTTA_SendEmailOnTakUpdate()

======================================================
======================================================
Purpose: Send an email when task is created
-------
======================================================
======================================================
History
-------
VERSION AUTHOR 		  DATE 		 DETAIL 			 FEATURES/CSR/TTP
1.0 -   Mounika Suram 09/05/2018 INITIAL DEVELOPMENT CSR:FTTA

***********************************************************************/
trigger FTTA_SendEmailOnTaskUpdate on Task (after update) {
    try{
        if(trigger.isAfter && trigger.isUpdate){
            for(Task task : trigger.new){
                EPA_Agreement__c epaAgreement =[select id,name,EPA_File_2__c from EPA_Agreement__c where id=:task.WhatId];
                user assignedTO=[select Id,name,email from user where id = :task.OwnerId];
                System.debug('assignedTO'+assignedTO);
                user createdBy=[select Id,email,name from user where id = :task.CreatedById];
                System.debug('createdBy'+createdBy);
                System.debug('EPA Agreement Id '+epaAgreement.Id);
                String sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm()+'/';
                System.debug('sfdcBaseURL '+sfdcBaseURL);
                 
                if(epaAgreement.Id != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                   	mail.setTargetObjectId(task.CreatedById);
                    mail.setSenderDisplayName('Test Team');
                   
                    mail.setUseSignature(false);
                    mail.setBccSender(false);
                    mail.setSaveAsActivity(false);                                      
                    if(task.Status == 'Completed'){
                        String[] toAddresses = new String[]{createdBy.Email}; 
                        mail.setToAddresses(toAddresses);
                        System.debug('Task Status'+task.Status);
                        mail.setSubject('EPA File # '+epaAgreement.EPA_File_2__c+'- Task "'+task.Subject+'" Completed');
                        mail.setHtmlBody('<div><p>Task <b>'+task.Subject+'</b> assigned to '+assignedTO.Name+' has been completed for EPA File # '+epaAgreement.EPA_File_2__c+'.</p><p>To access the task, please click the link. <a href='+sfdcBaseURL+task.Id+'>'+task.Subject+'</a></p></div>');
                        System.debug('Mail'+mail);
                        Messaging.SendEmailResult [] r = 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});   
                    }
                    else{
                        String[] toAddresses = new String[]{assignedTo.Email}; 
                        mail.setToAddresses(toAddresses);
                        System.debug('Task Status'+task.Status);
                        mail.setSubject('EPA File # '+epaAgreement.EPA_File_2__c+'- Task "'+task.Subject+'" Updated');
                        mail.setHtmlBody('<div><p>Task <b>'+task.Subject+'</b> has been updated for EPA File # '+epaAgreement.EPA_File_2__c+'.</p><p>To access the task, please click the link. <a href='+sfdcBaseURL+task.Id+'>'+task.Subject+'</a></p></div>');
                        System.debug('Mail'+mail);
                        Messaging.SendEmailResult [] r = 
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    }
                }
            }
    	}
     }
    catch(exception ex){
              System.debug('Error occured while handling task email alert'+
                           ex.getMessage() + ex.getLineNumber()+ ex.getCause());  
            }
}