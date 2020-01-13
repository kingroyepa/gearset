@isTest
public class TopicDownloadControllerTest {
    //

    static Submission__c submission1;
    static Submission__c submission2;
    static Submission__c submission3;
    static Submission__c submission4;
    static Submission__c submission5;
    static Topic__c topic1;
    static Topic__c topic2;
    static Topic__c topic3;
    static Topic__c topic4;
    static Topic__c topic5;
    static Snippet__c snippet1;
    static Snippet__c snippet2;
    static Snippet__c snippet3;
    static Snippet__c snippet4;
    static Snippet__c snippet5;
    static List<Id> snpIds;

    static void setUpTesting(){

        //Submissions
        submission1 = new Submission__c(Submission_Number__c='TEST_SUB_1',Commenter_Name__c='TEST USER');
        submission2 = new Submission__c(Submission_Number__c='TEST_SUB_2',Commenter_Name__c='TEST USER');
        submission3 = new Submission__c(Submission_Number__c='TEST_SUB_3',Commenter_Name__c='TEST USER');
        submission4 = new Submission__c(Submission_Number__c='TEST_SUB_4',Commenter_Name__c='TEST USER');
        submission5 = new Submission__c(Submission_Number__c='TEST_SUB_5',Commenter_Name__c='TEST USER');

        insert submission1;
        insert submission2;
        insert submission3;
        insert submission4;
        insert submission5;

        //Topics
        topic1 = new Topic__c(Name='1.0',Topic_Number__c='TEST_TOPIC_1.0',Topic_Name__c='1.0');
        topic2 = new Topic__c(Name='1.1',Topic_Number__c='TEST_TOPIC_1.1',Topic_Name__c='1.1.0.b.0.c');
        topic3 = new Topic__c(Name='2',Topic_Number__c='TEST_TOPIC_2',Topic_Name__c='2');
        topic4 = new Topic__c(Name=Null,Topic_Number__c='TEST_TOPIC_3.0',Topic_Name__c=Null);
        topic5 = new Topic__c(Name='3.3.3',Topic_Number__c='TEST_TOPIC_4.1',Topic_Name__c='3.3.3');

        insert topic1;
        insert topic2;
        insert topic3;
        insert topic4;
        insert topic5;

        snippet1 = new Snippet__c(Submission__c=submission1.Id,Topic__c=topic1.Id);
        snippet2 = new Snippet__c(Submission__c=submission2.Id,Topic__c=topic2.Id);
        snippet3 = new Snippet__c(Submission__c=submission3.Id,Topic__c=topic3.Id);
        snippet4 = new Snippet__c(Submission__c=submission4.Id,Topic__c=topic4.Id);
        snippet5 = new Snippet__c(Submission__c=submission5.Id,Topic__c=topic5.Id);

        insert snippet1;
        insert snippet2;
        insert snippet3;
        insert snippet4;
        insert snippet5;

        
        //List of Ids
        snpIds = new List<Id>();
        snpIds.add(snippet1.Id);
        snpIds.add(snippet2.Id);
        snpIds.add(snippet3.Id);
        snpIds.add(snippet4.Id);
        snpIds.add(snippet5.Id);

    }
    
    static testMethod void runThisTestOnTheSnippets(){
                
        setUpTesting();        
        
        System.debug('Test Get all topics for a topic id - '+TopicDownloadController.getAllSnippets(topic1.Id));

        System.debug('Test Basic get all topis - '+TopicDownloadController.getSnippets(topic1.Id,1,new List<String>{topic1.id},false,false,''));        
        System.debug('Test Get topics with already a selected record - '+TopicDownloadController.getSnippets(topic1.Id,1,new List<String>{topic1.Id},false,false,''));        
        
        System.debug('Test Search wiht Main topic - '+TopicDownloadController.getSnippets(topic1.Id,0,new List<String>(),false,true,'1'));        
        
        System.debug('Test search with subtopics - '+TopicDownloadController.getSnippets(topic2.Id,0,new List<String>(),false,true,'1.1'));        

        System.debug('Test search  no subtopics - '+TopicDownloadController.getSnippets(topic3.Id,0,new List<String>(),false,true,'2'));
        
        // Call constructor with the above topic details
        String ss = String.join(snpIds, ',');
        
        System.debug('ss='+ss);
        Test.setCurrentPageReference(new PageReference('Page.DemoWordGeneration'));
        System.currentPageReference().getParameters().put('snpIds', ss);
        
        TopicDownloadController topicContro = new TopicDownloadController();
        topicContro.handleVisualPageRequest(ss,'[1,2,3,4,5,6]');
        // Mounika Suram 8/9/2018 Added to test the added functionality
        // topicContro.handleVisualPageRequestForSelectAll(topic1.Id,'[1,2,3,4,5,6]');
    }
    static testMethod void testUpdateExportFieldOtions(){
        TopicDownloadController topicContro = new TopicDownloadController();
        topicContro.updateExportFieldOtions('[1,2,3,4,5,6]');
        topicContro.updateExportFieldOtions('[1,2,4,5,6]');
    }
    
    
}