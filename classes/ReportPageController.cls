public without sharing class ReportPageController  {
    @AuraEnabled
    public static List<BAP_Report_VF_Pages__mdt> getBAPreports(){
        return [select Label, Report_URL__c, Report_Description__c from BAP_Report_VF_Pages__mdt ORDER BY Label ASC];
    }
    
}