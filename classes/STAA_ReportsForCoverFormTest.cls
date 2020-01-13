/**********************************************************************
Name: STAA_ReportsForCoverFormTest

======================================================
======================================================
Purpose:
-------
Created this class to test the STAA_ReportsForCoverForm class.
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
1.0 - Mounika Suram 7/12/2018 INITIAL DEVELOPMENT 
1.0- Mounika Suram	11/9/2018 Fixing the Errors in the production deployment.
***********************************************************************/
@isTest
public class STAA_ReportsForCoverFormTest {
    public static Id staaRt = Schema.SObjectType.Cover_Form__c.getRecordTypeInfosByName().get('STAA Application').getRecordTypeId();
    static testMethod void afterInsert(){
     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
   	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    	LocaleSidKey='en_US', 
        ProfileId = p.Id,
    	TimeZoneSidKey='America/Los_Angeles',
    	UserName='STTA10@test.org');
    	insert u;
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'STAA_Coordinator_Access'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        
        cover_form__c cf = new cover_form__C();
        cf.Primary_Research_Category__c='Ecological Research';
        cf.Nominating_Official__c=u.id;
        cf.STAA_Coordinator__c=u.id;
        cf.Citation__c='Some Citation';
        cf.RecordTypeId=staaRt;
      	test.StartTest();
        system.runAs(u){
        insert cf;
        ApexPages.currentPage().getParameters().put('id',cf.id);
        ApexPages.StandardController sc= new ApexPages.StandardController(cf);
        STAA_ReportsForCoverForm ext= new STAA_ReportsForCoverForm(sc);
        ext.saveAttachment();
       
        }
         test.StopTest();
    }
    static testMethod void afterUpdate(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
   	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    	LocaleSidKey='en_US', ProfileId = p.Id,
    	TimeZoneSidKey='America/Los_Angeles',
    	UserName='STTA11@test.org');
    	insert u;
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'STAA_Coordinator_Access'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        cover_form__c cf = new cover_form__C();
        cf.Primary_Research_Category__c='Ecological Research';
        cf.Nominating_Official__c=u.Id;
        cf.STAA_Coordinator__c=u.Id;
        cf.Citation__c='Some Citation';
        cf.RecordTypeId=staaRt;
              
        ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'test-'+cf.Id + '.pdf'; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        test.StartTest();
        system.runAs(u){
        insert cf;
        insert contentVersion;       
        ApexPages.CurrentPage().getParameters().put('id',cf.id);
        Apexpages.StandardController sc = new Apexpages.StandardController(cf);
        STAA_ReportsForCoverForm ext = new STAA_ReportsForCoverForm(sc);
        ext.saveAttachment();
        ext.redirectToPDFPage();
        
        }
        test.StopTest();
    }
    static testMethod void negativeTesting(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
   	    EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
    	LocaleSidKey='en_US', ProfileId = p.Id,
    	TimeZoneSidKey='America/Los_Angeles',
    	UserName='STTA11@test.org');
    	insert u;
        PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'STAA_Coordinator_Access'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id );
        cover_form__c cf = new cover_form__C();
        cf.Primary_Research_Category__c='Ecological Research';
        cf.Nominating_Official__c=u.Id;
        cf.STAA_Coordinator__c=u.Id;
        cf.Citation__c='Some Citation';
        cf.RecordTypeId=staaRt;           
        ContentVersion contentVersion = new ContentVersion(); 
        contentVersion.Title = 'test.pdf'; 
        contentVersion.PathOnClient = contentVersion.Title; 
        Blob bodyBlob = EncodingUtil.base64Decode('TestFileData');
        contentVersion.VersionData = bodyBlob; 
        contentVersion.IsMajorVersion = false;
        contentVersion.origin = 'H';
        
        test.StartTest();
        system.runAs(u){
        insert contentVersion;
        ApexPages.CurrentPage().getParameters().put('id',null);
        Apexpages.StandardController sc = new Apexpages.StandardController(cf);
        STAA_ReportsForCoverForm ext = new STAA_ReportsForCoverForm(sc);
        ext.saveAttachment();
        ext.redirectToPDFPage();
        }
         test.StopTest();
    }
    
}