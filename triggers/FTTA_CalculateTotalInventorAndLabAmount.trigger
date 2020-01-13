/**********************************************************************
Name: FTTA_CalculateTotalInventorAndLabAmount()
======================================================
======================================================
Purpose: Calculate the total inventor and lab amount and update the FTTA license when the contact record is created, updated and deleted.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -   Mounika Suram 09/26/2018 INITIAL DEVELOPMENT CSR: FTTA License
***********************************************************************/
trigger FTTA_CalculateTotalInventorAndLabAmount on Contact (after insert,after update, after delete) {
     
     private id fttainventorRTId = [select id, developerName from RecordType where developerName='FTTA_License_Inventor'].id;
     private id fttaLicenseId;
     List<contact> conList= new List<contact>();
     private Decimal totalInventorAmount = 0.0;   
     private Decimal totalLabAmount = 0.0;
     if((trigger.isUpdate || trigger.isInsert) && trigger.isAfter){
        for(Contact con : trigger.new){
            if(con.RecordTypeId == fttainventorRTId && con.EPA_Agreement_License__c != null){
                fttaLicenseId=con.EPA_Agreement_License__c;
                conList = [Select id,Inventor_Amount__c,Lab_Office_Amount__c from Contact where EPA_Agreement_License__c= :con.EPA_Agreement_License__c];
                
            }
        }
     }
    if(trigger.isDelete && trigger.isAfter){
        for(Contact con : trigger.old){
            if(con.RecordTypeId == fttainventorRTId && con.EPA_Agreement_License__c != null){
                fttaLicenseId=con.EPA_Agreement_License__c;
                conList = [Select id,Inventor_Amount__c,Lab_Office_Amount__c from Contact where EPA_Agreement_License__c= :con.EPA_Agreement_License__c];
               
            }
        }
     }
 
    if(!conList.isEmpty()){
        for(Contact con : conList){
            if(con.Inventor_Amount__c!=null)
            totalInventorAmount += con.Inventor_Amount__c;
            if(con.Lab_Office_Amount__c!=null)
            totalLabAmount += con.Lab_Office_Amount__c;
           }
        
        
        EPA_Agreement__c license = new EPA_Agreement__c();
        license=[select id,Total_EPA_Inventor_Amount__c from EPA_Agreement__c where id=:fttaLicenseId];
        license.Total_EPA_Inventor_Amount__c = totalInventorAmount;
        license.Total_Lab_Office_Amount__c = totalLabAmount;
        update license;
    }
    
}