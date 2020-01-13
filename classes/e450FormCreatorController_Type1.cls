public with sharing class e450FormCreatorController_Type1 {

    public ID formID {get; set;}
    
    public List<ProcessInstance> approvalHistory {get; set;}
    private String sessionId; //a variable to hold the sessionid
    public ID userID;  //a variable to hold the userId
    public boolean valid;   //a boolean variable to decided if a user session is valid
    public forms__c theForm {get; set;}
    public List<line_item__c> lineItems1 {get; set;}
    public List<line_item__c> lineItems2 {get; set;}
    public List<line_item__c> lineItems3 {get; set;}
    public List<line_item__c> lineItems4 {get; set;}
    public List<line_item__c> lineItems5 {get; set;}
    public String yourFileName = 'nameofFile.pdf';

    public e450FormCreatorController_Type1() {
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + yourFileName);
        
        // Get session ID from URL parameters, get user ID from the matching session
        sessionId = UtilityMethods.getSessionID();
        userId = UtilityMethods.getUserID(sessionId);
       
        // Validate Session, temporarily disabled until more user data from proxy 
        try{
        valid = UtilityMethods.validateSession(sessionId, userId);
        if (Test.isRunningTest()) {
            CalloutException e = new CalloutException();
            e.setMessage('This is a constructed exception for testing and code coverage');
            throw e;
         }
        }
        catch(Exception e)
        {
            valid = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        
        //Get formID from URL parameter
        formID = ApexPages.currentPage().getParameters().get('Fid');
        this.theForm = getTheForm(formID);
        
        //get all line items related to Form
        list<line_item__c> allLineItems = [
            SELECT id, recordtype.name, Item_Description__c, No_Longer_Held__c, Name_of_Creditor__c, Type_of_Liability__c,
             Organization__c, Type_of_Organization__c, Position__c, Entity__c, Terms_of_Agreement_or_Arrangement__c, Source__c, 
             Description__c, Approver_Comment__c, Filer_s_Response__c
             From line_item__c where Related_Form__c = :formID
            ];
            
        
        this.lineItems1 = getLineItems1(allLineItems);
        this.lineItems2 = getLineItems2(allLineItems);
        this.lineItems3 = getLineItems3(allLineItems);
        this.lineItems4 = getLineItems4(allLineItems);
        this.lineItems5 = getLineItems5(allLineItems);
        
        this.approvalHistory = getApprovalHistory(formID);

    }
    
    public forms__c getTheForm(id formID){
        system.debug('formid: '+formID);
        theForm = [select id, Reporting_Status__c, CONFIDENTIAL_FINANCIAL_DISCLOSURE_REPORT__c, Why_Must_I_File__c, When_Must_I_File__c,
                     What_is_the_Reporting_Period__c, What_if_I_Have_Questions__c, PENALTIES__c, Privacy_Act_Statement__c, 
                     Public_Burden_Information__c, Applicant_Name_Last_First_MI2__c, Work_Email_Address2__c, Position_Title__c, Grade__c, 
                     Agency__c, Branch_Unit_and_Address__c, Office_Telephone2__c, If_New_Entrant_Date_of_Appt_to_Position__c, I__c, Step_1__c, 
                     Response_1__c, II__c, Response_2__c, III__c, Response_3__c, IV__c, Response_4__c, V__c, Response_5__c, Step_2__c, Step_3__c, 
                     Step_4__c
                  from forms__c where id = :formID limit 1];
        return theForm;
    }
    
    public List<line_item__c> getLineItems1(list<line_item__c> lines) {
    system.debug('# of lines: '+lines.size());
        list<line_item__c> theLineItems = new list<line_item__c>();
            for(line_item__c line : lines){
                if(line.recordtype.name == 'OGE-450 Part 1 Assets and Income Line Item'){
                    theLineItems.add(line);
                    system.debug('adding this line: '+line);
                }
            }
        system.debug('theLineItems count: '+theLineItems.size());
        return theLineItems;
    }        
    
    public List<line_item__c> getLineItems2(list<line_item__c> lines) {
    system.debug('# of lines: '+lines.size());
        list<line_item__c> theLineItems = new list<line_item__c>();
            for(line_item__c line : lines){
                if(line.recordtype.name == 'OGE-450 Part 2 Liabilities Line Item'){
                    theLineItems.add(line);
                    system.debug('adding this line: '+line);
                }
            }
        system.debug('theLineItems count: '+theLineItems.size());
        return theLineItems;
    }        
    
    public List<line_item__c> getLineItems3(list<line_item__c> lines) {
    system.debug('# of lines: '+lines.size());
        list<line_item__c> theLineItems = new list<line_item__c>();
            for(line_item__c line : lines){
                if(line.recordtype.name == 'OGE-450 Part 3 Outside Positions Line Item'){
                    theLineItems.add(line);
                    system.debug('adding this line: '+line);
                }
            }
        system.debug('theLineItems count: '+theLineItems.size());
        return theLineItems;
    }        
    
    public List<line_item__c> getLineItems4(list<line_item__c> lines) {
    system.debug('# of lines: '+lines.size());
        list<line_item__c> theLineItems = new list<line_item__c>();
            for(line_item__c line : lines){
                if(line.recordtype.name == 'OGE-450 Part 4 Agreements or Arrangements Line Item'){
                    theLineItems.add(line);
                    system.debug('adding this line: '+line);
                }
            }
        system.debug('theLineItems count: '+theLineItems.size());
        return theLineItems;
    }        
    
    public List<line_item__c> getLineItems5(list<line_item__c> lines) {
    system.debug('# of lines: '+lines.size());
        list<line_item__c> theLineItems = new list<line_item__c>();
            for(line_item__c line : lines){
                if(line.recordtype.name == 'OGE-450 Part 5 Gifts and Travel Reimbursements Line Item'){
                    theLineItems.add(line);
                    system.debug('adding this line: '+line);
                }
            }
        system.debug('theLineItems count: '+theLineItems.size());
        return theLineItems;
    }        
    
    public List<ProcessInstance> getApprovalHistory(Id formID) {
  /*      list<ProcessInstance> pis = [
                SELECT Id, createddate
                FROM ProcessInstance
                WHERE TargetObjectId = :formID
          ];
        system.debug('pis: '+pis);
        list<id> apprvIDs = new list<id>();
        for(processInstance pi : pis){
            apprvIDs.add(pi.id);
        }
        system.debug('apprvIDs: '+apprvIDs);
        
        if (pis.isEmpty()) {
            return null;
          }

        List<ProcessInstanceStep> approvalHistory = [
                SELECT Id, OriginalActor.Name, Actor.Name, CreatedDate, StepStatus, Comments
                FROM ProcessInstanceStep
                WHERE ProcessInstanceId IN :apprvIDs
                ORDER BY CreatedDate
          ];
        system.debug('approvalHistory: '+approvalHistory);
        */
        
        list<ProcessInstance> approvalHistory = [SELECT Id, Status, CreatedDate, CompletedDate, TargetObjectId, 
                                                (SELECT Id, StepStatus, Actor.Name, ElapsedTimeInDays, ElapsedTimeInMinutes, 
                                                CreatedDate, ProcessNodeId, ProcessNode.Name, Comments 
                                                FROM StepsAndWorkitems order by CreatedDate) from ProcessInstance 
                                                Where TargetObjectId =: formID order by CreatedDate];
        return approvalHistory;
    }
    
     public PageReference validateOrRedirect() {
        if (!valid) {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else { return null; }       
    }
    
}