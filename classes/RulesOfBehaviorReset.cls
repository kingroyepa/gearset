/**********************************************************************
Name: RulesOfBehaviorReset
======================================================
======================================================
Purpose:
-------

======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/12/19 Initial development  
 
**********************************************************************/
global class RulesOfBehaviorReset implements Database.Batchable<sObject>, Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, FirstName,LastName FROM User where isActive=true';//+(Test.isRunningTest()?' LIMIT 1':''
        Integer queryLimit = Test.IsRunningTest() ? 1:10000;
		query+=' limit '+queryLimit;
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<User> scope) {
        for (User a : scope) {
            a.Agree_To_Rules_of_Behavior__c = false;
            a.Signature__c = null;
            a.Last_Banner_Date__c = null;
        }
        update scope;
    }
    global void finish(Database.BatchableContext BC) {
    }

    global void execute(SchedulableContext sc) {
        Type t = Type.forName('RulesOfBehaviorReset');
        Database.Batchable< sObject > batchClass = ((Database.Batchable< sObject >) t.newInstance());
        Database.executeBatch(batchClass, 200);
    }
}