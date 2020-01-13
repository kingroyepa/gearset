/**********************************************************************
Name: CandidateApplicationTrigger
======================================================
======================================================
Purpose: Checks whether the LOI candidate application contains documents before submitting to approval.
-------
======================================================
======================================================
History
-------
VERSION  AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -    Mounika Suram 04/02/2018 INITIAL DEVELOPMENT TQB
***********************************************************************/
trigger CandidateApplicationTrigger on Candidate_Application__c (before update) {
    private Id loiRt = [select id from recordtype where developerName='Letter_of_Intent_LOI'].Id;
    private Id candidateRt = [select id from recordtype where developerName='Candidate_Package'].Id;
    private Id candidateSubRt = [select id from recordtype where developerName='Candidate_Submission'].Id;
    private List<ContentDocumentLink> fileList;
    Private List<Id> candidateIds = new List<Id>();
    private List<Candidate_Application__c> lOiApplications = new List<Candidate_Application__c>();  
    private List<Candidate_Application__c> candidateApplications = new List<Candidate_Application__c>();
    private List<Candidate_Application__c> candidateWithQuestions = new List<Candidate_Application__c>();
    private List<Candidate_Application__c> tqbChecklist = new List<Candidate_Application__c>();
    private Boolean checklistCompletion = false;
    private Boolean questionCompletion = true;
    
    for(Candidate_Application__c loi: trigger.new){
        Candidate_Application__c oldLoi = trigger.oldMap.get(loi.Id);
        if(loi.recordTypeId==loiRt && loi.Status__c =='Awaiting 1st Line Supervisor Approval' && oldLoi.Status__c !='Awaiting 1st Line Supervisor Approval' ){
            lOiApplications.add(loi);
        } 
        if(loi.recordTypeId==candidateRt && loi.Status__c =='Awaiting 1st Line Supervisor Approval' && oldLoi.Status__c !='Awaiting 1st Line Supervisor Approval' ){
            if(loi.First_Line_Supervisor__c == null || loi.Second_Line_Supervisor__c == null){ 
                candidateApplications.add(loi);
                system.debug('candidateApplications'+candidateApplications);
                
            }
            else{
                candidateIds.add(loi.Id);
                candidateApplications.add(loi);
            }
            
        }
        if(loi.recordTypeId==candidateSubRt && loi.Status__c =='Awaiting TQB Coordinator Approval'){
         if (loi.List_of_5_References_and_5_Ad_hocs__c && loi.Candidate_s_CV_and_Bi__c && loi.List_of_Major_Scientific_Engineering_Tec__c &&
             loi.Selection_request_of_3_outside_experts__c && loi.Nomination_of_4_Ad_hoc_Members__c && loi.Availability_statements_from_four_Ad_hoc__c &&
             loi.Transmittal_and_certification_memo__c && loi.Candidate_s_Essay_with_Responses__c && loi.X3_5_Recent_Publications_Work_Products__c &&
             loi.New_Position_Description_PD__c && loi.Include_the_3_letters__c && loi.Signed_COI_Statements_from_4_Ad_hocs__c &&
             loi.Biosketches_CVs_for_four_Ad__c
         ){
            checklistCompletion = true;
         }
        if(!checklistCompletion ){
             Candidate_Application__c record = Trigger.newMap.get(loi.Id);
             record.addError('Please complete the TQB Checklist.');
            }
        }
    }
    if(!lOiApplications.isEmpty()){
        for(Candidate_Application__c loi : lOiApplications){
            
            fileList = [SELECT id, linkedEntityId from ContentDocumentLink where LinkedEntityId =:loi.Id];
            System.debug('filelist: '+fileList.size());
            if(fileList.isEmpty()) {
                loi.addError('No documents are attached to the application.');
            }   
            
            
        }
    }
    if(!candidateApplications.isEmpty() && candidateIds.isEmpty()){
        
        for(Candidate_Application__c ca : candidateApplications){
            
            ca.addError('Please fill First Line Supervisor and Second Line Supervisor.');
        } 
        
    }
    if(!candidateIds.isEmpty()){
        candidateWithQuestions =[ Select Id, Name, 
                                 (Select Id, Name, Questions__c, Answer__c, Response_Status__c from Question_Responses__r),
                                 (Select Id, Name, TQB_Ad_Hoc_Status__c, TQB_Contact_Type__c from Adhocs__r)
                                 From Candidate_Application__c 
                                 where Id in :candidateIds];
     
        for(Candidate_Application__c ca : candidateWithQuestions){
            for(Question_Response__c qa : ca.Question_Responses__r){
                if(qa.Answer__c == null || qa.Response_Status__c <> 'Completed'){
                    questionCompletion = false;
                }
            }
                    
            if(!questionCompletion){
                Candidate_Application__c record = Trigger.newMap.get(ca.Id);
                record.addError('Please answer the questions and mark the response status to completed.');
            }
            
            if(ca.Adhocs__r.size()<5){
                Candidate_Application__c record = Trigger.newMap.get(ca.Id);
                record.addError('Please add atleast 5 panel members.');
            }
        }
        
    }
}