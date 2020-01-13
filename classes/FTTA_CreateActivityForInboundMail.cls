/**********************************************************************
Name: FTTA_CreateActivityForInboundMail()
======================================================
======================================================
Purpose: FTTA application. Created to handle the inbound email from the EPA agreement.
-------
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -    Mounika Suram 09/04/2018 INITIAL DEVELOPMENT CSR:FTTA
1.0 -    Mounika Suram 09/11/2018 Updated the EPA File # CSR:FTTA
***********************************************************************/
global class FTTA_CreateActivityForInboundMail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env){  
            Messaging.InboundEmailResult result= new Messaging.InboundEmailResult();
            try{ 
              System.debug('email'+email);
              String subject = email.subject;
                
              System.debug('Subject'+subject);
              String body = email.htmlBody;
              if(subject.contains('EPA')){
                   String epaFile= subject.substringBeforeLast(':');
                  System.debug('epaFile'+epaFile);
                   String fileNumber = epaFile.substringAfter('#');
                   System.debug('fileNumber'+fileNumber); 
                   fileNumber = fileNumber.trim();
                   fileNumber = fileNumber.replaceAll('(\\s+)', ' ');
                   System.debug('fileNumber with out spaces'+fileNumber); 
                   if(fileNumber!=null){
                        EPA_Agreement__c agreement = new EPA_Agreement__c();
                        agreement=[select id from EPA_Agreement__c where EPA_File_2__c=:fileNumber];
                        //create an email  message
                        EmailMessage em = new EmailMessage();
                        em.FromAddress=email.fromAddress;
                        em.FromName=email.fromName;
                        //em.ToAddress=email.toAddresses[0];
                        em.ToAddress='ftta_inboundemail@l-8rsonzf7g61oy8ve139wdjtc9q3bazcyw6pzyl7ao11mwcqrs.r-8scveaa.cs32.apex.sandbox.salesforce.com';
                       // em.CcAddress= email.ccAddresses[0];
                        em.HtmlBody=email.htmlBody;
                        em.Subject=email.subject;
                        em.RelatedToId=(id)agreement.Id;
                        em.Status='2';
                       System.debug('Email Message'+em);
                        insert em;
                    } 
                }
                
            }
            catch(exception ex){
              System.debug('Error occured while handling inbound email'+
                           ex.getMessage() + ex.getLineNumber()+ ex.getCause());  
            }
           return result;
        }
}