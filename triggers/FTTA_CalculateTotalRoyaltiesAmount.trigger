/**********************************************************************
Name: FTTA_CalculateTotalRoyaltiesAmount()
======================================================
======================================================
Purpose: Calculate the total royalties amount and update the FTTA license when the Accounting_Line__c record is created, updated and deleted.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -   Mounika Suram 09/26/2018 INITIAL DEVELOPMENT CSR: FTTA License
***********************************************************************/
trigger FTTA_CalculateTotalRoyaltiesAmount on Accounting_Line__c (after insert,after update, after delete) {
     
     private id fttaRoyaltiesRTId = [select id, developerName from RecordType where developerName='FTTA_Royalties'].id;
     private id fttaLicenseId;
     List<Accounting_Line__c> acList= new List<Accounting_Line__c>();
     private Decimal totalRoyaltiesAmount = 0.0;   
     if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter){
        for(Accounting_Line__c ac : trigger.new){
            if(ac.RecordTypeId == fttaRoyaltiesRTId && ac.EPA_License__c != null && ac.Payment_Amount__c !=null){
                fttaLicenseId=ac.EPA_License__c;
                acList = [Select id,Payment_Amount__c from Accounting_Line__c where EPA_License__c= :ac.EPA_License__c];
                
            }
        }
     }
     else if(trigger.isDelete && trigger.isAfter){
        for(Accounting_Line__c ac : trigger.old){
            if(ac.RecordTypeId == fttaRoyaltiesRTId && ac.EPA_License__c != null&& ac.Payment_Amount__c !=null){
               fttaLicenseId=ac.EPA_License__c;
               acList = [Select id,Payment_Amount__c from Accounting_Line__c where EPA_License__c= :ac.EPA_License__c];
               
            }
        }
     }
 
     if(!acList.isEmpty()){
        for(Accounting_Line__c ac : acList){
            totalRoyaltiesAmount += ac.Payment_Amount__c;
           }
        
       
        EPA_Agreement__c license = new EPA_Agreement__c();
        license=[select id,Total_Royalties__c from EPA_Agreement__c where id=:fttaLicenseId];
        license.Total_Royalties__c = totalRoyaltiesAmount;
        update license;
        
     }
}