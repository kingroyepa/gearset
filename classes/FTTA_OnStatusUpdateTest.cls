/**********************************************************************
Name: FTTA_OnStatusUpdateTest()
======================================================
======================================================
Purpose: Created to test the class FTTA_RecordLockOnStatusTerminated
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE      DETAIL              FEATURES/CSR/TTP
1.0 -   Mounika Suram 8/15/2018 Initial Development FTTA
***********************************************************************/
@isTest(SeeAllData=true)
public class FTTA_OnStatusUpdateTest {
    
private static id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
private static id licenseRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_License'].id;
    @isTest
    private static void WhenAmendment(){
        system.debug('In FTTA_OnStatusUpdateTest:InsertAgreement');
        EPA_Agreement__C agreement = new EPA_Agreement__C();
        agreement.RecordTypeId=agreementRecordTypeId;
        agreement.Status__c='Created';
        agreement.Termination_Date__c=null;
        insert agreement;
        
        Account partner = new Account();
        partner.name ='Test Account';
        partner.EPA_Agreement__c = agreement.id;
        insert partner;
        
        Contact poc = new Contact();
        poc.LastName='test';
        poc.AccountId=partner.id;
        insert poc;
        
        Line_Item__C product = new Line_Item__C();
        product.Software_Developed__c=true;
        product.EPA_Agreement__c= agreement.id;
        insert product;
        
        EPA_Agreement__C amendment = new EPA_Agreement__C();
        amendment.RecordTypeId=agreementRecordTypeId;
        amendment.Status__c='Created';
        amendment.Agreement_Type__c='Amendment';
        amendment.Agreement__c = agreement.id;
        insert amendment;
        EPA_Agreement__C amendment2 = new EPA_Agreement__C();
        amendment2.RecordTypeId=agreementRecordTypeId;
        amendment2.Status__c='Created';
        amendment2.Agreement_Type__c='Amendment';
        amendment2.Agreement__c = agreement.id;
        insert amendment2;
        system.assert([select id,EPA_File_2__c from EPA_Agreement__C where id=:amendment.Id].EPA_File_2__c <> null);
    }
    @isTest
    private static void WhenStatusTerminated(){
        system.debug('In FTTA_OnStatusUpdateTest:InsertAgreement');
        
        EPA_Agreement__C agreement = new EPA_Agreement__C();
        agreement.RecordTypeId=agreementRecordTypeId;
        agreement.Status__c='Created';
        agreement.Termination_Date__c=null;
        insert agreement;
        system.debug('Status'+agreement.Status__c);
        agreement.Status__c='Terminated';
        agreement.Description__c='test';
        update agreement;
        system.debug(' Updated Status'+agreement.Status__c);
        system.debug(' Updated agreement'+agreement);
    }
    // Mounika 2/15/2019 Temporarily commented for the ftta workflow.
    //@isTest
    //private static void WhenStatusAtSignature(){
    //     try{
    //        system.debug('In FTTA_RecordLockOnStatusTerminatedTest:WhenStatusAtSignature');
    //        EPA_Agreement__C agreement = new EPA_Agreement__C();
    //        agreement.RecordTypeId=agreementRecordTypeId;
    //        agreement.Status__c='Created';
    //        agreement.OGC_Review_Needed__c='Yes';
    //        insert agreement;
   //         system.debug('Status'+agreement.Status__c);
    //        agreement.Status__c='At Signature';
   //         agreement.Description__c='test';
    //        update agreement;             
  //          system.debug(' Updated Status'+agreement.Status__c);
  //          system.debug(' Updated agreement'+agreement);  
  //      }
   //     catch(Exception e){
       
  //          Boolean expectedExceptionThrown = (e.getMessage().contains('Status not saved. Please complete OGC Review and Concurrence'))? true : false;
            
  //         System.AssertEquals(expectedExceptionThrown, true);
        
  //      } 
  //  }
    @isTest
    private static void WhenStatusPending(){
         try{
            system.debug('In FTTA_RecordLockOnStatusTerminatedTest:WhenStatusPending');
            EPA_Agreement__C agreement = new EPA_Agreement__C();
            agreement.RecordTypeId=agreementRecordTypeId;
            agreement.Status__c='Created';
            agreement.OGC_Review_Needed__c='Yes';
            insert agreement;
            system.debug('Status'+agreement.Status__c);
            agreement.Status__c='Pending';
            agreement.Description__c='test';
            update agreement;             
            system.debug('Updated Status'+agreement.Status__c);
            system.debug('Updated agreement'+agreement);  
        }
        catch(Exception e){
        
            Boolean expectedExceptionThrown = (e.getMessage().contains('Status not saved. Please add Partner/Collaborator'))? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
        
        } 
    }
    @isTest
    private static void WhenStatusIsNull(){
         try{
            system.debug('In FTTA_RecordLockOnStatusTerminatedTest:WhenStatusIsNull');
            EPA_Agreement__C agreement = new EPA_Agreement__C();
            agreement.RecordTypeId=agreementRecordTypeId;
            agreement.Status__c='Created';
            agreement.OGC_Review_Needed__c='Yes';
            insert agreement;
            system.debug('Status'+agreement.Status__c);
            agreement.Status__c='fake';
            agreement.Description__c=null;
            update agreement;             
            system.debug(' Updated Status'+agreement.Status__c);
            system.debug(' Updated agreement'+agreement);  
        }
        catch(Exception ex){
        
            System.debug('Error occured while handling WhenStatusIsNull'+
                           ex.getMessage() + ex.getLineNumber()+ ex.getCause()); 
        
        } 
    }
    @isTest
    private static void WhenLicense(){
            EPA_Agreement__C license = new EPA_Agreement__C();
            license.RecordTypeId=licenseRecordTypeId;
            license.License_Type__c='exclusive';
            license.OGC_Review_Needed__c='Yes';
            insert license;
    }
}