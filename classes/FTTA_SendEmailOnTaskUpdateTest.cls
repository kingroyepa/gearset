/**********************************************************************
Name: FTTA_SendEmailOnTaskUpdateTest()

======================================================
======================================================
Purpose: FTTA. Created to test the class FTTA_SendEmailOnTaskUpdate.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -   Mounika Suram 09/06/2018 INITIAL DEVELOPMENT CSR:FTTA

***********************************************************************/
@isTest
public class FTTA_SendEmailOnTaskUpdateTest {
    private static id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
    private static id taskId = [select id from RecordType where sobjectType='Task' and developerName='FTTA_Tasks'].Id;
    @isTest
    private static void WhenTaskComplted(){
        system.debug('In FTTA_RecordLockOnStatusTerminatedTest:InsertAgreement');
        EPA_Agreement__C agreement = new EPA_Agreement__C();
        agreement.RecordTypeId=agreementRecordTypeId;
        agreement.Status__c='Created';
        insert agreement;
        system.debug('Status'+agreement.Status__c);
        Task task= new task(Subject='Test',WhatId=agreement.id,priority='low',recordTypeId=taskId);
        insert task;
        task.Priority ='high';
        update task;
        task.Status='Completed';
        update task;  
    }

}