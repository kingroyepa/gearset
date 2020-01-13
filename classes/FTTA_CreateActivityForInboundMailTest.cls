/**********************************************************************
Name: FTTA_CreateActivityForInboundMailTest()
======================================================
======================================================
Purpose: Created to test the FTTA_CreateActivityForInboundMailTest class.
-------
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -    Mounika Suram 09/11/2018 INITIAL DEVELOPMENT CSR:FTTA

***********************************************************************/
@isTest(seeAlldata=true)
public class FTTA_CreateActivityForInboundMailTest {
    private static id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
    static testMethod void TestinBoundEmail()
    {
       	Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
    	EPA_Agreement__C agreement = new EPA_Agreement__C();
        agreement.RecordTypeId=agreementRecordTypeId;
        agreement.Status__c='Created';
        insert agreement;
        EPA_Agreement__c agreement1 =[select id,EPA_File_2__c from EPA_Agreement__c where id =:agreement.Id limit 1 ];
        email.subject = 'EPA File # '+agreement1.EPA_File_2__c+' :';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Testing the Inbound Email service'; 
        email.htmlBody='Testing the Inbound Email service';  
        FTTA_CreateActivityForInboundMail  testInbound=new FTTA_CreateActivityForInboundMail();
        testInbound.handleInboundEmail(email, env);     
     
   
   }
}