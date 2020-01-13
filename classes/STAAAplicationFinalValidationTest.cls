/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 7-May-2018
*    Class Name : STAAAplicationFinalValidationTest
*    This class tests VisualForce page that is populated with errors

**/

@isTest
private class STAAAplicationFinalValidationTest{
 public static Id staaRt = Schema.SObjectType.Cover_Form__c.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
 public static Id staaAuthorRt = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
 public static Id staaPubRt = Schema.SObjectType.Line_Item__C.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
  
 public static testMethod void beforeInsertTest(){
  
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];

    // Create User Record
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    LocaleSidKey='en_US', ProfileId = p.Id,
    TimeZoneSidKey='America/Los_Angeles',
    UserName='STAA2@test.org', Phone='1231231234');
    insert u;
	PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'STAA_Coordinator_Access'];
    insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
    // Create Contact Record
    Contact con = new Contact(LastName='Test',Email='standarduser@testorg.com', Phone='1231231234');
    
    
    Line_Item__c pub = new Line_Item__c();
    pub.RecordTypeId=staaPubRt;
    pub.Publication_Title__c  = '1';
    pub.Publication_Date__c   = Date.newInstance(2018, 12, 9);
    pub.Journal_Publication_Method__c = '1';
    pub.Volume__c = '1';
    pub.Number__c = '1';
    pub.Pages__c = '1';
    pub.Impact_Factor__c = '1';


    // Create Cover Form Record
    Cover_Form__c CForm = new Cover_Form__c();
    cForm.recordTypeId=staaRt; 
    CForm.Primary_Research_Category__c = 'Ecological Research';
    CForm.Nominating_Official__c = u.Id;
    CForm.STAA_Coordinator__c  = u.Id;
    CForm.Status__c = 'FINAL';
    
   
    // Begin Test Page
    Test.startTest(); 
     system.runAs(u) {
        insert CForm;
        insert con;
        insert pub;
        ApexPages.currentPage().getParameters().put('id',CForm.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(CForm);
        STAAAplicationFinalValidation obj = new STAAAplicationFinalValidation(new ApexPages.StandardController(CForm));
        obj.checkRecord();
     }
    Test.stopTest();

 }
 

 public static testMethod void ValidationTest(){
  
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
    // Create User Record
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    LocaleSidKey='en_US', ProfileId = p.Id,
    TimeZoneSidKey='America/Los_Angeles',
    UserName='STTA3@test.org');
    insert u;
     
	PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'STAA_Coordinator_Access'];
    insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
    // Create Cover Form Record
    system.runAs(u) {
    Cover_Form__c CForm = new Cover_Form__c();
    cform.RecordTypeId=staaRt;
    CForm.Primary_Research_Category__c = 'Ecological Research';
    CForm.Nominating_Official__c = u.Id;
    CForm.STAA_Coordinator__c  = u.Id;
    CForm.Justification_1__c = 'N/A';
    CForm.Justification_2A__c = 'N/A';
    CForm.Justification_2B__c = 'N/A';
    CForm.Justification_2C__c = 'N/A';
    CForm.Justification_2D__c = 'N/A';
    CForm.Justification_2E__c = 'N/A';
    CForm.Justification_3A__c = 'N/A';
    CForm.Justification_3B__c = 'N/A';
    CForm.Eligibility_Criteria_1__c = TRUE;
    CForm.Eligibility_Criteria_2__c = TRUE;
    CForm.Eligibility_Criteria_3__c = TRUE;
    CForm.Eligibility_Criteria_4__c = TRUE;
    CForm.Citation__c = 'N/A';
    insert CForm;

    // Create Contact Record
    Contact con = [Select id, Name, of_Total_Effort__c, non_EPA_Personnel__c, Do_You_have_Record_of_Agree__c, At_Time_Research_Was__c, Seperation_Date__c from Contact where Cover_Form__c =: CForm.Id];
    con.LastName='test';
    con.Cover_Form__c=CForm.id;
    con.of_Total_Effort__c = 100;
    con.Do_You_have_Record_of_Agree__c = TRUE;
    con.At_Time_Research_Was__c = 'PHS Assigned to EPA';
    con.Seperation_Date__c = System.today();
   	update con;

    // Create Publication Record
    Line_Item__c pub = new Line_Item__c();
    //pub.RecordTypeId=staaPubRt; 
    pub.Publication_Title__c  = '1';
    pub.Publication_Date__c   = Date.newInstance(2018, 12, 9);
    pub.Journal_Publication_Method__c = '1';
    pub.Volume__c = '1';
    pub.Number__c = '1';
    pub.Pages__c = '1';
    pub.Impact_Factor__c = '1';
    pub.Cover_Form__C = CForm.Id;
    insert pub;

    // Create Publication Attachment Record
    ContentVersion contentVersion_1 = new ContentVersion(
      Title = 'Test',
      PathOnClient = 'Test.jpg',
      VersionData = Blob.valueOf('Test Content'),
      IsMajorVersion = true
    );
    
      
        insert contentVersion_1;
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1]; 
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = pub.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
  		contentlink.ShareType = 'V';
        insert contentlink; 
        Test.startTest(); 
        //ApexPages.currentPage().getParameters().put('id',CForm.id);
        //ApexPages.StandardController sc= new ApexPages.StandardController(CForm);
        STAAAplicationFinalValidation obj = new STAAAplicationFinalValidation(new ApexPages.StandardController(CForm));
        obj.checkRecord();
   
    // Re-run Test without Contact and Publication Attachment Records
       delete con;
       delete contentlink;
       obj.checkRecord();
    
    Test.stopTest(); 
        }
 }
}