/*
* @author Omer
* @description Batch Class to sendemail to users if lastlogindate is 104 days
* @date Created at 2019-10
*/
global class UserDeprovisionemail2 implements Database.Batchable<sObject> {
    
    global Set<id> allFailedId=new Set<id>();
    global List<id> allSuccessId=new List<id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String dateTimeFormat = DateTime.now().addDays(-104).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String query = 'SELECT Id,Email FROM User WHERE Profile.Name != \'System Administrator\' ';
        query+='AND LastLoginDate<'+dateTimeFormat+' AND IsActive=True';
        //query+=' limit 10000';
        Integer queryLimit = Test.IsRunningTest() ? 1:10000;
		query+=' limit '+queryLimit;

        System.debug('Query'+query);
        System.debug('Query'+query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<user> userList) {
       OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'BAP-Support@epa.gov'];
        

       emailtemplate etname=[SELECT Id,name,HTMLValue,subject from Emailtemplate where name='BAP Login reminder 104 Days'];
        for(User user : userList)
        {        
            Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
            String[] sendingTo = new String[]{user.email};
            String body = etname.HTMLValue;
            String subject = etname.subject;

            semail.setToAddresses(sendingTo);
            semail.setSubject(subject);
            semail.setHtmlBody(body);
            semail.setTemplateId(etname.Id);
            if ( owea.size() > 0 ) {
            semail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {semail});
    
        }
        
        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}