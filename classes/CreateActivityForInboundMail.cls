/**********************************************************************
Name: CreateActivityForInboundMail()
======================================================
======================================================
Purpose: Created to handle the inbound email from. The following is required to be in the email body 'ref:recordid:ref'
-------
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -    Roy King      06/26/2019 INITIAL DEVELOPMENT BAP
***********************************************************************/
global class CreateActivityForInboundMail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope env){  
        Messaging.InboundEmailResult result= new Messaging.InboundEmailResult();
        try{ 
            System.debug('email'+email);
            String subject = email.subject;
            
            System.debug('Subject'+subject);
            String body = email.htmlBody;
            if(body.contains('ref:')){
                String recName = body.substringBetween('ref:',':ref');
                recName = recName.trim();
                Id recID = Id.valueOf(recName);
                if(recID !=null){
					System.debug('object is '+ recID.getsobjecttype());
                    //create an email  message
                    EmailMessage em = new EmailMessage();
                    em.FromAddress=email.fromAddress;
                    em.FromName=email.fromName;
                    //em.ToAddress=email.toAddresses[0];
                    // em.CcAddress= email.ccAddresses[0];
                    em.HtmlBody=email.htmlBody;
                    em.Subject=email.subject;
                    em.RelatedToId=(Id)recID;
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