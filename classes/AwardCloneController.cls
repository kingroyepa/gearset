/**
 * AwardCloneController clones award records based on record type.
 */
public with sharing class AwardCloneController {
    private ApexPages.StandardController controller { get; set; }
    private Award__c award { get; set; }

    public AwardCloneController(ApexPages.StandardController controller) {
        this.controller = controller;
        award = (Award__c) controller.getRecord();
    }

    public void cashAwardClone() {
        String recordTypeName = 'Cash Award';

        cloneAward(recordTypeName);
    }

    public void timeoffAwardClone() {
        String recordTypeName = 'Time Off Award';

        cloneAward(recordTypeName);
    }

    public PageReference cloneAward(String recordTypeName) {
        Savepoint sp = Database.setSavepoint();
        Award__c newAward;
        Id recordTypeId;

        // Need to get the Awards record type
        String recordTypeToCopy;
        if (!String.isBlank(recordTypeName)) {
            recordTypeToCopy = recordTypeName;
            recordTypeId = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        } else {
            recordTypeToCopy = [SELECT RecordType.Name FROM Award__c WHERE Id = :award.Id LIMIT 1].RecordType.Name;
            recordTypeId = Schema.SObjectType.Award__c.getRecordTypeInfosByName().get(recordTypeToCopy).getRecordTypeId();
        }

        // Query for fields related to that record type
        String fields = getQueryFields(recordTypeToCopy);
        Id awardId = award.Id;
        String queryString = 'SELECT ' + fields + ' FROM Award__c WHERE Id = :awardId';

        // Use award.clone to clone the award record
        try {
            award = Database.query(queryString);

            newAward = award.clone(false, false, false, false);
            newAward.RecordTypeId = recordTypeId;

            insert newAward;
        } catch (DmlException e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

        System.debug('>>>> New award id: ' + newAward.Id);
        System.debug('>>>> Attempting to redirect ...');
        // Return a new page reference to the record
        return new PageReference('/' + newAward.Id);

    }

    /**
     * Because we're querying for fields based on record type, return the query string with specific fields for the
     * supplied record type name.
     *
     * @param recordTypeName Record type name for the award getting cloned
     *
     * @return Query string for the specific record type
     */
    private static String getQueryFields(String recordTypeName) {

        Map<String, String> queryFieldsByRecordType = new Map<String, String>{
                'Cash Award' => 'Requesting_Official__c, Emp_Name__c, Authorizing_Official__c, Awardee_Direct_Supervisor__c, Budget__c, Work_Code_Lookup__c, Value_and_Application__c, Supervisor_Justification__c, Cincinnati_Office_Justification__c',
                'QSI Award' => 'Requesting_Official__c, Emp_Name__c, Authorizing_Official__c, Awardee_Direct_Supervisor__c, Budget__c, Work_Code_Lookup__c, Value_and_Application__c, Supervisor_Justification__c, Cincinnati_Office_Justification__c, QSI__c',
                'Time Off Award' => 'Requesting_Official__c, Emp_Name__c, Authorizing_Official__c, Awardee_Direct_Supervisor__c, Budget__c, Work_Code_Lookup__c, Value_and_Application__c, Supervisor_Justification__c, Cincinnati_Office_Justification__c'
        };

        return queryFieldsByRecordType.get(recordTypeName);
    }

}