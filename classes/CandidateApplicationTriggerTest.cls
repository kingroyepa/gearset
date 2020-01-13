/**********************************************************************
Name: CandidateApplicationTrigger
======================================================
======================================================
Purpose: Tests CandidateApplicationTrigger
-------
======================================================
======================================================
History
-------
VERSION  AUTHOR 	   DATE 	  DETAIL 			  FEATURES/CSR/TTP
1.0 - 	 Mounika Suram 04/02/2018 INITIAL DEVELOPMENT TQB
***********************************************************************/

@isTest
public class CandidateApplicationTriggerTest {
  private static Id loiRt = schema.SObjectType.Candidate_Application__c.getRecordTypeInfosByName().get('Letter of Intent (LOI)').getRecordTypeId();
  private static Id candiadteRt = schema.SObjectType.Candidate_Application__c.getRecordTypeInfosByName().get('Candidate Application').getRecordTypeId();
    
    @isTest
    static void WhenNoDocuments(){
        try{
            User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
            Candidate_Application__c LoiApplication = new Candidate_Application__c(recordTypeId=loiRt,First_Line_Supervisor__c=u.Id);
            insert LoiApplication;
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setObjectId(LoiApplication.Id);
            request.setComments('Submitted for Approval');           
            test.startTest(); 
            Approval.ProcessResult result = Approval.process(request);          
            test.stopTest();
            
        }
        catch(exception ex){
            System.assert(ex.getMessage().contains('No documents are attached to the application.'));
        }
    }
     @isTest
    static void WhenCandidate(){
        try{
            User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];
            Candidate_Application__c candidateApplication = new Candidate_Application__c(recordTypeId=candiadteRt,First_Line_Supervisor__c=u.Id,
                                                                                  TQB_Coordinator__c=u.Id,TQB_Chair__c=u.Id);
            insert candidateApplication;
            Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
            request.setObjectId(candidateApplication.Id);
            request.setComments('Submitted for Approval');           
            test.startTest(); 
            Approval.ProcessResult result = Approval.process(request);          
            test.stopTest();
            
        }
        catch(exception ex){
            System.assert(ex.getMessage().contains('Please fill First Line Supervisor and Second Line Supervisor.'));
        }
    }
}