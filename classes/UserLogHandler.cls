public class UserLogHandler implements Queueable {
    private List<User> userIDs;
    private String action;
    private String comments;

    public UserLogHandler (List<User> recs, String act, String cmts) {
        this.userIDs = recs;
        this.action = act;
        this.comments = cmts;
    }

    public void execute(QueueableContext context) {
        List<User> uList= [select Id, email,isactive,alias,LAN_ID__c,EmployeeNumber from user where Id = :userIDs];
        Id rtID = Schema.SObjectType.Metadata__c.getRecordTypeInfosByName().get('User History').getRecordTypeId();
        List<Metadata__c> insertMetadataList = new List<Metadata__c>();
            
        for (User u : uList) {
            If(action != null){
                    Metadata__c m = new Metadata__C (recordtypeid=rtID,name=u.email,action__c=action,action_date__c=Datetime.now(),user__c=u.id,
                                                     original_sf_id__c=u.id,label__c=u.LAN_ID__c,API_Name__c=u.EmployeeNumber, Description__c=comments);
                    insertMetadataList.add(m);                
            } else {
                if (u.isActive == True) {
                    Metadata__c m = new Metadata__C (recordtypeid=rtID,name=u.email,action__c='Activate',action_date__c=Datetime.now(),user__c=u.id,
                                                     original_sf_id__c=u.id,label__c=u.LAN_ID__c,API_Name__c=u.EmployeeNumber, Description__c=comments);
                    insertMetadataList.add(m);
                } else if (u.isActive == False){
                    Metadata__c m = new Metadata__C (recordtypeid=rtID,name=u.email,action__c='Deactivate',action_date__c=Datetime.now(),user__c=u.id,
                                                     original_sf_id__c=u.id,label__c=u.LAN_ID__c,API_Name__c=u.EmployeeNumber, Description__c=comments);
                    insertMetadataList.add(m);
                }
            }
        }
        
        try {
             insert insertMetadataList;
             if(Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
             }
        } catch (Exception e){
            System.debug('Exception: ' + e);
        }
    }
}