global class CreateTrainingLineItems implements Database.Batchable<sObject>, Schedulable {

    global List<id> allSuccessId=new List<id>();
    public Boolean isTest=false;
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id,Approver_1__c,Approver_2__c,Cardholder_AO_Name__c,exists__c FROM Forms__c where exists__c=false and RecordType.Name IN (\'Purchase Card: New Purchase Card\',\'Purchase Card: New Convenience Check\',\'Purchase Card: New Approving Official (AO)\') ';
        Integer queryLimit = Test.IsRunningTest() ? 1:10000;
        query+=' limit '+queryLimit;
        System.debug('Query'+query);
        System.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Forms__c> formsList) {
        Set<Id> formIds = new Set<Id>();
        Map<Id,Set<String>> lineItemFormMap = new Map<Id,Set<String>>();
        List<Line_Item__c> createList = new List<Line_Item__c>();
        Id trainingRT = Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('Training').getRecordTypeId();


        for(Forms__c f:formsList){
            formIds.add(f.Id);
        }
        for(Line_Item__c li:[Select Id,Related_Form__c,Course_Title__c from Line_Item__c where Related_Form__c IN :formIds]){
            if(lineItemFormMap.containsKey(li.Related_Form__c)){
                Set<String> lis=lineItemFormMap.get(li.Related_Form__c);
                lis.add(li.Course_Title__c);
                lineItemFormMap.put(li.Related_Form__c,lis);
            }else{
                lineItemFormMap.put(li.Related_Form__c,new Set<String>{ li.Course_Title__c });
            }
        }

        for(Forms__c f:formsList){
            if(lineItemFormMap.containsKey(f.Id)){
                Set<String> existingLines = lineItemFormMap.get(f.Id);
                if(!existingLines.contains('CitiManager Training')){
                    createList.add(createLineItem('CitiManager Training',f,trainingRT));
                }
                if(!existingLines.contains('Purchase Card Warrant')){
                    createList.add(createLineItem('Purchase Card Warrant',f,trainingRT));
                }
                if(!existingLines.contains('Other/Miscellaneous')){
                    createList.add(createLineItem('Other/Miscellaneous',f,trainingRT));
                }
            }else{
                createList.add(createLineItem('CitiManager Training',f,trainingRT));
                createList.add(createLineItem('Purchase Card Warrant',f,trainingRT));
                createList.add(createLineItem('Other/Miscellaneous',f,trainingRT));
            }
            f.exists__c=true;
        }

        insert createList;
        update formsList;
}   

    global Line_Item__c createLineItem(String course,Forms__c form,String recType){

        return new Line_Item__c(Course_Title__c=course,Related_Form__c=form.Id,Approver_1__c = form.Approver_1__c,
            Approver_2__c = form.Approver_2__c,
            Employee__c= form.Cardholder_AO_Name__c,RecordTypeId=recType);
    }
    
    global void finish(Database.BatchableContext BC) {
    }
    global void execute(SchedulableContext sc) {
    // Type t = Type.forName('RulesOfBehaviorReset');
    // Database.Batchable< sObject > batchClass = ((Database.Batchable< sObject >) t.newInstance());
    // Database.executeBatch(batchClass, 200);
    }
}