@isTest
public class BAPAutoReply_Test {
    public static Id aimRt = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('Software Application').getRecordTypeId();
    
    public static testMethod void someMethod_Test()
    {
        Application__c app = New Application__c();
        app.Application_Name__c = 'Test';
        app.AutoReply_Text__c = 'Test';
        app.Support_email__c = 'test@test.com';
        app.Included_in_Support__c	= true;
        //app.Send_as_Record__c = false;
        //app.Retention__c = SObjectType.application__c.Fields.Retention__c.PicklistValues[0].getValue(); 
        //app.Sensitivity__c = SObjectType.application__c.Fields.Sensitivity__c.PicklistValues[0].getValue(); 
        //app.Date_Event__c = SObjectType.application__c.Fields.Date_Event__c.PicklistValues[0].getValue();
        app.RecordTypeId=aimRt;
        insert app;
        
        //System.assertEquals(1,e.getAccount.size());
        BAPAutoReply c = new BAPAutoReply();
        System.assertEquals(1,c.getAccount().size());
        
    }
}