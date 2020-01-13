public with sharing class e450FormCreatorController_Type3 {

    public ID formID {get; set;}
    
    public List<ProcessInstance> approvalHistory {get; set;}
    public List<line_item__c> lineItems1 {get; set;}
    public List<line_item__c> lineItems2 {get; set;}
    public List<line_item__c> lineItems3 {get; set;}
    public List<line_item__c> lineItems4 {get; set;}
    public List<line_item__c> lineItems5 {get; set;}
    public String yourFileName = 'nameofFile.pdf';

    public e450FormCreatorController_Type3(ApexPages.StandardController stdController) {
        
        this.formID = stdController.getId();
        forms__c theForm = [select id, Applicant_Name_Last_First_MI2__c from forms__c where id = :formID limit 1];
        yourFileName = 'OGE-450 Form for ' + theForm.Applicant_Name_Last_First_MI2__c + '.pdf';
        Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=' + yourFileName);
        
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
    
}