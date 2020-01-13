/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 7-May-2018
*    Class Name : STAAAplicationFinalValidation
*    This class creates a VisualForce page that is populated with errors based on the criteria below (validateRecord class)
*
**/

public class STAAAplicationFinalValidation {

    public Cover_Form__c cForm;
    public String errorMessage{get;set;}
    public String recordId;
    
    // Get RecordType Id
    public Id RecordTypeIdToFilterBy = Schema.SObjectType.Cover_Form__c.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
    
    public STAAAplicationFinalValidation(ApexPages.StandardController stdController) {
        recordId = stdController.getRecord().Id;       
        cForm = [Select Id, RecordTypeId, Eligibility_Criteria_1__c, Eligibility_Criteria_2__c, Eligibility_Criteria_3__c, Eligibility_Criteria_4__c,
            Justification_1__c, Justification_2A__c, Justification_2B__c, Justification_2C__c, Justification_2D__c, Justification_2E__c,
            Justification_3A__c, Justification_3B__c, Citation__c, Status__c
            from Cover_Form__c where Id =: recordId];
        
        // Inserts Error Message into the VisualForce page
        errorMessage = '<div class="errorTitle">Please review and complete the following fields</div>';
    }
    
    
    // Populates VisualForce Page
    public PageReference checkRecord(){
    if(cForm.recordtypeId == RecordTypeIdToFilterBy){
        if(!validateRecord()){ 
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            //req1.setComments('Submitting request for approval.');
            req1.setObjectId(cForm.id);
            Approval.ProcessResult result = Approval.process(req1);
            
            if(result.isSuccess()){
                PageReference pg = new PageReference('/'+cForm.Id);
                pg.setRedirect(true);
                return pg;  
            }
            else{
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'Approval Not Submitted Succesfully'));
                return null;
            }
        }
        else{
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.FATAL,errorMessage));
            return null;
        }
        }
        return null;
    }
    


    // Checks for Errors
    public Boolean validateRecord() {
        
        Boolean result = False;
        
        if(cForm.Status__c != 'DRAFT'){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">Application has already been submitted or expired (check "Comments" tab)</div>';
            result = TRUE;
        }
        
        ///// Eligibility Criteria boxes (error if not checked)
        if(!cForm.Eligibility_Criteria_1__c){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Eligibility Criteria 1"</span> must be checked before application submission.</div>';
            result = TRUE;
        }
        
        if(!cForm.Eligibility_Criteria_2__c){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Eligibility Criteria 2"</span> must be checked before application submission.</div>';
            result = TRUE;
        }
        
        if(!cForm.Eligibility_Criteria_3__c){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Eligibility Criteria 3"</span> must be checked before application submission.</div>';
            result = TRUE;
        }
        
        if(!cForm.Eligibility_Criteria_4__c){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Eligibility Criteria 4"</span> must be checked before application submission.</div>';
            result = TRUE;
        }

        ///// Justification text areas (error if empty)
        if(cForm.Justification_1__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 1"</span> needs to be filled.</div>';
            result = TRUE;
        }
        
        if(cForm.Justification_2A__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 2A"</span> needs to be filled.</div>';
            result = TRUE;
        }
        
        if(cForm.Justification_2B__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 2B"</span> needs to be filled.</div>';
            result = TRUE;
        }
        
        if(cForm.Justification_2C__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 2C"</span> needs to be filled.</div>';
            result = TRUE;
        }
 
         if(cForm.Justification_2D__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 2D"</span> needs to be filled.</div>';
            result = TRUE;
        }  
        
        if(cForm.Justification_2E__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 2E"</span> needs to be filled.</div>';
            result = TRUE;
        }
        
        if(cForm.Justification_3A__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 3A"</span> needs to be filled.</div>';
            result = TRUE;
        } 
        
        if(cForm.Justification_3B__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Justification 3B"</span> needs to be filled.</div>';
            result = TRUE;
        } 

        if(cForm.Citation__c == NULL){
            errorMessage += '<div class="errorItem">- <span class="errorItemTitle">"Citation"</span> needs to be filled.</div>';
            result = TRUE;
        }
        
        /////////// Authors Related List
        //Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
        
        Map<Id,Contact> listAuthors = new Map<Id,Contact>(
            [Select id, Name, of_Total_Effort__c, non_EPA_Personnel__c, Do_You_have_Record_of_Agree__c, At_Time_Research_Was__c, Seperation_Date__c from Contact where Cover_Form__c =: recordId]);       
        
        // Error if no Authors are created
        if(listAuthors.size() == 0){
            errorMessage += '<div class="errorItem">- Please Add <span class="errorItemTitle">Authors</span>.</div>';
            result = TRUE;
        }
        
        // Error if Authors' efforts do not add up to 100%
        Double total_eforts = 0;
        for (Contact con: listAuthors.values()){
            if(con.of_Total_Effort__c == NULL){
                total_eforts += 0;
            }
            if(con.of_Total_Effort__c != NULL){
                total_eforts += con.of_Total_Effort__c;
            }         
        }
        if (total_eforts != 100){
            errorMessage += '<div class="errorItem">- Check the <span class="errorItemTitle">"Authors"</span> Section. <span class="errorItemTitle">"% of Total Effort"</span> across Authors must sum 100%.</div>';
            result = TRUE;
        }
        
        
        for (Contact con: listAuthors.values()){
            String author_name = con.Name;
            Double percentage_eforts = con.of_Total_Effort__c;
                        
            // Error if '% of Total Effort' is zero of NULL
            if(percentage_eforts == 0 || percentage_eforts == NULL){
                errorMessage += '<div class="errorItem">- Check Author <span class="errorItemTitle">' + author_name + ' - "% of Total Effort"</span> must greater than 0%.</div>';
                result = TRUE;          
            }
            
            if(con.non_EPA_Personnel__c == FALSE){
                    // Error if 'At Time Research Was' not selected
                    if(con.At_Time_Research_Was__c == NULL){
                        errorMessage += '<div class="errorItem">- Check Author <span class="errorItemTitle">' + author_name + ' - "At Time Research Was"</span> value must be selected.</div>';
                        result = TRUE;              
                    }
            
                    // Error if 'Record of Agreement' not checked
                    if(con.Do_You_have_Record_of_Agree__c == FALSE){
                        errorMessage += '<div class="errorItem">- Check Author <span class="errorItemTitle">' + author_name + ' - "Record of Agreement"</span> must be checked.</div>';
                        result = TRUE;          
                    }           

            }
        }
    
        
        
        //////////Publications
        Map<Id,Line_Item__c> listPublication = new Map<Id,Line_Item__c>(
            [Select id, Name from Line_Item__c where Cover_Form__c =: recordId]);
        
        // Error if there are no Publications
        if(listPublication.size() == 0){
            errorMessage += '<div class="errorItem">- Please attach a file to your <span class="errorItemTitle">Publications</span>.</div>';
            result = TRUE;
        }
        
        Set<Id> newSet = listPublication.keySet();
        List<Id> newList = new List<Id>();
        newList.addAll(listPublication.keySet());
        if(newList.size() > 0){
            List<ContentDocumentLink> listContentDocumentLink = [Select id, LinkedEntityId from ContentDocumentLink where LinkedEntityId IN :newList];
        
            for(ContentDocumentLink cdl : listContentDocumentLink){
                if(listPublication.containsKey(cdl.LinkedEntityId))
                    newSet.remove(cdl.LinkedEntityId);
            }
            
            // Error if Publication does not have a file attached
            if(newSet.size() > 0){
                errorMessage += '<div class="errorItem">- Please attach at least <span class="errorItemTitle">1 file</span> to all the related <span class="errorItemTitle">Publications</span>.</div>';
                result = TRUE;
            }
        }
        
       
        return result;
        
    }
    
}