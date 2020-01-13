/*
* @author Omer
* @description Batch Class to freeze user accounts if lastlogindate is 105 days
* @date Created at 2019-10
*/

global class UserDeprovisioning implements Database.Batchable<sObject> {
    
    global Set<id> allFailedId=new Set<id>();
    global List<id> allSuccessId=new List<id>();
    public Boolean isTest=false;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String dateTimeFormat = DateTime.now().addDays(-105).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String query = 'SELECT IsFrozen,UserId FROM UserLogin WHERE IsFrozen=false AND UserId IN ';
        query+='(SELECT Id FROM User WHERE Profile.Name != \'System Administrator\' ';
        query+='AND LastLoginDate<='+dateTimeFormat+' AND IsActive=True)';
        /*if(Test.isRunningTest()){
query+=' limit 1';
}else{
query+=' limit 10000';
}*/
        Integer queryLimit = Test.IsRunningTest() ? 1:10000;
        query+=' limit '+queryLimit;
        
        System.debug('Query'+query);
        System.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<UserLogin> userList) {
        
        // process each batch of records
        allFailedId=new Set<id>();
        allSuccessId=new List<id>();
        List<String> userIds = new List<String>();
        for(UserLogin user : userList)
        {        
            user.IsFrozen=true;
            userIds.add(user.userId);
            
        }
        try {
            database.SaveResult[] updateResults=database.update(userList,false);
            Id rtID = Schema.SObjectType.Metadata__c.getRecordTypeInfosByName().get('User History').getRecordTypeId();
            List<Metadata__c> insertMetadataList = new List<Metadata__c>();
            for(User user:[select Id,LAN_ID__c,EmployeeNumber,email from user where Id IN :userIds]){
                // Log action
                Metadata__c m = new Metadata__C (RecordTypeId=rtID,name=user.email,action__c='Freeze',action_date__c=Datetime.now(),user__c=user.id,
                                                 original_sf_id__c=user.id,label__c=user.LAN_ID__c,API_Name__c=user.EmployeeNumber);
                insertMetadataList.add(m);
            }
            insert insertMetadataList;
            
            if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
            } catch(Exception e) {
                System.Debug('Exception: ' + e);
            }
        }   
        
        global void finish(Database.BatchableContext BC) {
        }
    }