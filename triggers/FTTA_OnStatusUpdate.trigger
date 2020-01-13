/**********************************************************************
Name: FTTA_RecordLockOnStatusExpiredOrTerminated()
======================================================
======================================================
Purpose: Trigger on EPA Agreement to lock the record once its status is expired or terminated.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE      DETAIL               FEATURES/CSR/TTP
1.0 -   Mounika Suram 8/13/2018 Initial Development  FTTA
1.0     Mounika Suram 9/27/2018 Updated with License FTTA License
1.0     Mounika Suram 10/24/2018 Added generation for the fiscal year FTTA License
1.0		Mounika Suram 2/7/2019	Autogeneration Sequence FTTA 
***********************************************************************/
trigger FTTA_OnStatusUpdate on EPA_Agreement__c (before insert,before update,after insert) {
    // Record type of the epa agreement
    private id agreementRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_EPA_Agreement'].id;
    private id licenseRecordTypeId = [select id from RecordType where sobjectType='EPA_Agreement__C' and developerName='FTTA_License'].id;
    private List<Epa_Agreement__C> amendments = new List<Epa_Agreement__C> ();
    private List<Account> partners;
    private List<Contact> pocs;
    private integer index;
    private String epaFileNumber;
    // List of agreements
    private list<EPA_Agreement__c> oldValues = new list<EPA_Agreement__c>(); 
    try {
            
        if(trigger.isBefore && trigger.isInsert){
              for(EPA_Agreement__c agreement :  trigger.new){
                    // store the size of the amendments for the particular agreement
                    integer size;
                   // stores the file number of the last element in the list
                    String lastFileNumber;
                  // When License
                  	if(agreement.recordTypeId==licenseRecordTypeId){
                        agreement.EPA_File_2__c = FTTA_OnStatusUpdatehelper.generateEPAFileNumber(true);
                    }
                  // When Agreement
                    if(agreement.recordTypeId==agreementRecordTypeId && agreement.Agreement_Type__c!='Amendment' ){
                        agreement.EPA_File_2__c = FTTA_OnStatusUpdatehelper.generateEPAFileNumber(false);
                    }
                    //when  amendment is inserted
                    if((agreement.recordTypeId==agreementRecordTypeId || agreement.recordTypeId==licenseRecordTypeId) && (agreement.Agreement_Type__c=='Amendment') && 
                        agreement.Agreement__c!=null && agreement.EPA_File_2__c == null){
                        // get the parent record
                        // get the list of amendments
                        System.debug('Is Before-Insert: New Amendment Created');
                        amendments = [select id, Name, EPA_File_2__c from EPA_Agreement__C where Agreement__c =:agreement.Agreement__c order by id];
                        if(!amendments.contains(agreement)) {   
                            amendments.add(agreement);
                         }
                        amendments.sort();
                        if(!amendments.isEmpty()){
                            size= amendments.size();
                            system.debug('amendments'+amendments);
                            system.debug('lastFileNumber'+amendments[size - 1].EPA_File_2__c ); 
                            if(amendments[size - 1].EPA_File_2__c != null){
                                lastFileNumber = amendments[size - 1].EPA_File_2__c;
                                system.debug('lastFileNumber'+lastFileNumber); 
                            }                           
                            index = amendments.indexOf(agreement);
                            system.debug('index'+index);
                            if(index !=null){
                               EPA_Agreement__C parent=[select id,name,EPA_File_2__c from EPA_Agreement__C where id=:agreement.Agreement__C];
                               epaFileNumber = FTTA_OnStatusUpdatehelper.getParentFileNumber(lastFileNumber,parent.EPA_File_2__c,index);
                               system.debug('epaFileNumber'+epaFileNumber);
                               agreement.EPA_File_2__c= epaFileNumber;
                            }
                            
                         }
                                             
                                                    
                     }  
              }
           }
        if(trigger.isAfter && trigger.isInsert){
             for(EPA_Agreement__c agreement :  trigger.new){
                 //if((agreement.recordTypeId==agreementRecordTypeId || agreement.recordTypeId==licenseRecordTypeId) && agreement.Agreement_Type__c!='Amendment'){
                   // FTTA_OnStatusUpdatehelper.generateCaseId(agreement.Name);
                    //}
                 if((agreement.recordTypeId==agreementRecordTypeId || agreement.recordTypeId==licenseRecordTypeId) && (agreement.Agreement_Type__c=='Amendment') && 
                        agreement.Agreement__c!=null){
                   partners = [select id, Name,Short_Description__c,Type,Size_of_Business__c,Region__c,Description,Code__c,
                               Submitted_by__c,Phone,Fax,Foreign_Domestic__c,NumberOfEmployees,Startup_5_yrs__c,
                               RecordTypeId, BillingCity,BillingCountry,BillingGeocodeAccuracy,
                               BillingLatitude,BillingLongitude,BillingPostalCode,BillingState, BillingStreet 
                               from Account where EPA_Agreement__c =:agreement.Agreement__c];
                                if(!partners.isEmpty()){
                                   FTTA_OnStatusUpdatehelper.createPartnerforAmendment(agreement,partners);
                                   FTTA_OnStatusUpdatehelper.createPartnePocsforAmendment(agreement);
                                   FTTA_OnStatusUpdatehelper.createProductsForAmendment(agreement);
                                }  
                 }
            }
         }
        if(trigger.isBefore && trigger.isUpdate){
            oldValues=trigger.old;
            for(EPA_Agreement__c agreement :  trigger.new){
                
                if((agreement.recordTypeId==agreementRecordTypeId || agreement.recordTypeId==licenseRecordTypeId) && (agreement.Status__c== 'Terminated')){
                    System.debug('Entered into the if statement evaluation in the trigger');
                    System.debug('status'+agreement.Status__c);
                    agreement.Termination_Date__c= system.today();               
                }
                // Mounika 2/15/2019 Temporarily commented for the ftta workflow.
                //else if((agreement.recordTypeId==agreementRecordTypeId || agreement.recordTypeId==licenseRecordTypeId) && (agreement.Status__c== 'At Signature')){
                //    System.debug('status'+agreement.Status__c);
                //    EPA_Agreement__c old= trigger.oldMap.get(agreement.Id);
                //    System.debug('old status'+old.Status__c);
                //    if(old.Status__c !='OGC Concurrence' && agreement.OGC_Review_Needed__c=='Yes'){
                //        agreement.addError('Status not saved. Please complete OGC Review and Concurrence');
                //    } 
                //}
                else if((agreement.recordTypeId==agreementRecordTypeId || agreement.recordTypeId==licenseRecordTypeId) && (agreement.Status__c== 'Pending')){
                    System.debug('status'+agreement.Status__c);
                    EPA_Agreement__c old= trigger.oldMap.get(agreement.Id);
                    System.debug('old status'+old.Status__c);
                    List<Account> partners = [select id from Account where EPA_Agreement__c = :agreement.id];
                    System.debug('partners'+partners); 
                    if(partners.isEmpty()){
                        agreement.addError('Status not saved. Please add Partner/Collaborator.');
                    } 
                }
            }
            
        }
     }
    catch(exception ex){
        system.debug('Exception occured in the trigger' + ex.getMessage() + ex.getLineNumber());
    }
}