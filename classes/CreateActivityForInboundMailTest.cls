/**********************************************************************
Name: CreateActivityForInboundMailTest()
======================================================
======================================================
Purpose: Created to test the CreateActivityForInboundMailTest class.
-------
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -    Roy King      06/26/2019 INITIAL DEVELOPMENT BAP

***********************************************************************/
@isTest(seeAlldata=true)
public class CreateActivityForInboundMailTest {
    private static id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
    static testMethod void TestinBoundEmail()
    {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        EPA_Agreement__C agreement = new EPA_Agreement__C();
        agreement.RecordTypeId=agreementRecordTypeId;
        agreement.Status__c='Created';
        insert agreement;
        EPA_Agreement__c agreement1 =[select id,EPA_File__c from EPA_Agreement__c where id =:agreement.Id limit 1 ];
        email.subject = 'EPA File # '+agreement1.EPA_File__c+' :';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Testing the Inbound Email service'; 
        email.htmlBody='Testing the Inbound Email service ref:' + agreement1.Id + ':ref';  
        CreateActivityForInboundMail  testInbound=new CreateActivityForInboundMail();
        testInbound.handleInboundEmail(email, env);     
        if(Test.isRunningTest()){
        Messaging.InboundEmail failemail = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope failenv = new Messaging.InboundEnvelope();
            testInbound.handleInboundEmail(failemail, failenv); 
        }
        
        
    }
}