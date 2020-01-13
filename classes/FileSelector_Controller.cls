public class FileSelector_Controller {
// Apex Controller for File Selector List Lightning Component
    public static Id fileSelectorRt = Schema.SObjectType.Metadata__c.getRecordTypeInfosByName().get('File Selector').getRecordTypeId();

    @AuraEnabled
public static List<Metadata__c> getPreselectedFiles(List<Id> files) {
System.debug('pf: ' + files);
String parentID = '%' + files + '%';
// Get list of files attached to current record
return [Select Original_SF_ID__c from metadata__c where name like :parentID];
}

@AuraEnabled
public static String resetListAction(String files) {
    // NMeeds to be a future call dues to record ownership, so calling a subsequent method
    clearList(files);
    return 'List Cleared';
}

    @future
    public static void clearList(String files)
    {
        System.debug('rl: ' + files);
        String parentID = '%' + files + '%';
        // Get list of files attached to current record
        List<Metadata__c> rl = [select id from Metadata__c where name like :parentID];
        System.debug('rl Size : ' + rl.size());
        delete rl;
        //return [select id from Metadata__c where name like :parentID];
    }


    @AuraEnabled
public static List<ContentDocument> getAttachedFiles(List<Id> files) {
System.debug('cdl: ' + files);
Set<Id> docIDs = new Set<Id>();
// Get list of files attached to current record
List<ContentDocumentLink> cdl = [select id,contentdocumentid,contentdocument.Title from contentdocumentlink where linkedentityid = :files];
for(ContentDocumentLink cdLink:cdl){
    docIDs.add (cdLink.ContentDocumentID);
}
return [Select id, title,fileextension from contentdocument where id IN: docIDs];
}

@AuraEnabled
public static String saveFileList(String accRecmId, String sObj, String name) {
Type idArrType = Type.forName('List<string>');
List<string> idList = (List<string>) JSON.deserialize(accRecmId, idArrType);
System.debug('idList Size : ' + idList.size());
List<Metadata__c> mdList = new List<Metadata__c>();

for(String item:idList){
        System.debug('Item : ' + item);
        Metadata__c u = new Metadata__c();
        ContentDocument fName = [Select id, title,fileextension from contentdocument where id = :item];
        u.RecordTypeId = fileSelectorRt;
        u.Parent__c = sObj;
        u.Filename__c = fName.Title;
        u.Name = name;
        u.Original_SF_ID__c = item;
        mdList.add(u);
    }
insert mdList;
return  'records added: ' + mdList.size();
}

@AuraEnabled
public static List<ContentDocument> getAttachedFiles2(List<Id> files, List<String> sObj) {
    Set<Id> docIDs = new Set<Id>();
    Set<string> setChildRelationshipNames = new Set<string>();
    Set<Id> setAllIds = new Set<Id>();
    // Make the describe call
    Schema.DescribeSobjectResult[] results = Schema.describeSObjects(sObj);
    for(Schema.DescribeSobjectResult res : results) {
        List<String> subqueries = new List<String>();
        String query ='';
        // Get child relationships
        Schema.ChildRelationship[] rels = res.getChildRelationships();
        if (rels.size() > 0) {
            integer i = 1;
            for(Schema.ChildRelationship rel:rels){
                if (rel.getChildSObject().getDescribe().fields.getMap().get('Name') != null) {
                    if(rel.getChildSObject().getDescribe().isCustom()) {
                        SObjectType childType = rel.getChildSObject();
                        // get all the child relationship names of that object
                        setChildRelationshipNames.add(rel.getRelationshipName());
                        // build the query or subquery
                        subqueries.add('(SELECT Id FROM ' + rel.getRelationshipName() + ')');
                    }

                }
                i++;
            }

            // Create a query to get all IDs from parents and children
            query = 'SELECT ' + String.join(subQueries, ',') + ' FROM '+ sObj[0] + ' where Id = \'' + files[0] + '\'' ;
            // Run the query with subqueries
            List<SObject> ids = Database.query(query);
            System.debug('Size: ' + ids.size() + ' - ' + query);

            //now when iterating through the parent records, get all its child record Ids along with parent Ids in a single set
            for(SObject idList:ids){
                setAllIds.add((Id)idList.get('Id'));
                for(string childRelationShipName : setChildRelationshipNames) {
                    List<sObject> childRecords = idList.getSObjects(childRelationShipName);
                    if(childRecords <> null) { for (sObject chd : childRecords) { setAllIds.add(chd.Id); } }
                }
            }

            // query on ContentDocumentLink to get all contentdocumentlinks which are related to a parent along with its child records
            List<ContentDocumentLink> cdl = [select id,contentdocumentid,contentdocument.Title from contentdocumentlink where linkedentityid IN :setAllIds];
            for(ContentDocumentLink cdLink:cdl) {
                docIDs.add (cdLink.ContentDocumentID);
                System.debug('Title: ' + cdLink.ContentDocumentId );

            }
        }
    }
    // return the query that loops through the combined ID list
    return [Select id, title,fileextension from contentdocument where id IN :docIDs];

}
}