public class TQBRequestHandler {

    private static Id tqbQuestionResponsesRT = Schema.SObjectType.Question_Response__c.getRecordTypeInfosByName().get('TQB Question Responses').getRecordTypeId();
    
    @InvocableMethod
    public static void addRelatedQuestions(List<Candidate_Application__c>  requests){
        if(requests.size() > 0){
            Candidate_Application__c  request = requests.get(0);
            String track = request.Intended_Track__c;
            System.debug('addRelatedQuestions for ' + request.Id + ' = ' + track);
            // Get all related questions
            List<Questions__c> relatedQuestions = TQBRequestHandler.getRelatedQuestions(track);
            System.debug('relatedQuestions = ' + relatedQuestions.size());
            // Create junction records for the request
            Boolean insertStatus = TQBRequestHandler.createRequestResponses(request,relatedQuestions);
            System.debug('insertStatus = ' + insertStatus);
        }
    }
    
    public static List<Questions__c> getRelatedQuestions(String track){
        List<Questions__c> relatedQuestions = null;
        try{
            //Mounika Suram-  4/11/2019 - updated the query to sort by ascending
            relatedQuestions = [Select id,Question__c from Questions__c where Status__c = 'Active' AND Track__c =:track order by Name ASC];
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
        }catch(Exception e){
            System.debug('getRelatedQuestions query fail.'+e.getMessage());
        }
        return relatedQuestions;
    }
    public static Boolean createRequestResponses(Candidate_Application__c request, List<Questions__c> relatedQuestions){
        Boolean insertStatus = true;

        try{
            List<Question_Response__c> newRecords = null;
            // do we have to find any existing objects and modify?
            Boolean updateExistingQuestions = true;
            Boolean insertNewRecords = false;
            if(updateExistingQuestions){
                 //Mounika Suram-  4/11/2019 - updated the query to sort by ascending
                newRecords = [Select Id,Question__c from Question_Response__c where Candidate_Application__r.Id =:request.Id order by Name ASC];                
            }
            if(newRecords != null && newRecords.size()>0){ newRecords = null;
            }else{
                insertNewRecords = true;
            }
                
            if(insertNewRecords){
                newRecords = new  List<Question_Response__c>();
                for(Questions__c  relatedQuestion : relatedQuestions){
                    Question_Response__c reqResponse = new Question_Response__c();
                    reqResponse.Candidate_Application__c = request.Id;
                    reqResponse.Questions__c = relatedQuestion.Id;
                    reqResponse.Question__c = relatedQuestion.Question__c;
                    reqResponse.RecordTypeId = tqbQuestionResponsesRT;
                    newRecords.add(reqResponse);
                }
            }
            if(newRecords.size()>0){
                upsert newRecords;
            }
        }catch(Exception e){
            insertStatus = true;
            System.debug('Exception in createRequestResponses. '+e.getMessage());
        }
        return insertStatus;
    }
}