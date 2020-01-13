public class BAPAutoReply {
    public List<application__c> getAccount() {
        return [select Application_Name__c,AutoReply_Text__c,Support_email__c from application__c where Included_in_Support__c	= true];
    }
}