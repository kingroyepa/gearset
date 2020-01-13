/**********************************************************************
Name: STAA_ReportsForCoverForm()

======================================================
======================================================
Purpose:
-------
Created this class to generate STAA reports for the specified Cover form
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
1.0 - Mounika Suram 6/28/2018 INITIAL DEVELOPMENT 
***********************************************************************/

public class STAA_ReportsForCoverForm {
   //Holds the redirect which determines whether the page should be redirected or not
    Private boolean isRedirect {get;set;}
    //Holds the list of authors to be diaplayed 
    Public List<Contact> authors {get; set;}
    //Holds the ContentDocuments for the specified CoverForm
    public List<ContentDocument> contentDocuments{get;set;}
    // Holds the list of publications to be displayed 
    Public List<Line_Item__c> publications {get; set;}
    // Holds the current date
    Date myDate = system.today();
    //Holds the cover form object
    Private Cover_Form__c coverForm;

    public Boolean initialised{get; set;}
    
/************************************
Name:Constructor
Purpose: To initialize the values when the class is instantiated
***************************************/
    public STAA_ReportsForCoverForm(ApexPages.StandardController stdController) {
        this.coverForm = (Cover_Form__c)stdController.getRecord();
        id coverFormId = ApexPages.currentPage().getParameters().get('id');
        initialised=false;
        if(coverFormId !=null){
        authors =getAuthors(coverFormId);
        publications=getPublications(coverFormId);
        contentDocuments=getAttachments(coverFormId);
        }
        system.debug('Authors :'+authors);
        system.debug('Publications :'+publications);
        System.debug('ContentDocuments :'+contentDocuments);
        isRedirect = false;
    }
    
 /************************************
Name:redirectToPDFPage
Purpose: To rdirect the page when necessary
***************************************/
    public void redirectToPDFPage(){
        isRedirect = true;
    }
    
/************************************
Name:saveAttachement
Purpose: Generates Pdf for the rendered content and Attchaches it to the selected coverform
***************************************/
    public void saveAttachment() {
        System.debug('Entered into saveAttachments');
        if (!initialised && coverForm.ID !=NULL) {
            // Set the page reference to the current page
            PageReference pdf = Page.STAA_ReportsForCoverForm;
            //PageReference pdf= ApexPages.currentPage();
            // create the new attachment
            Attachment attach = new Attachment();
                                    
            Blob body;
            try{
                //render the contents of the page as pdf
                body = pdf.getContentAsPDF();
            }catch(Exception e){
                body = EncodingUtil.base64Decode('TestFileData');
            }
            // File Name stats with STAA-****.pdf
            string filename = 'STAA-' + coverForm.Id + ' - ' + system.Now() +'.pdf';
            system.debug('FileName>>>' +filename);
            List<ContentVersion> contentVersionExisting = new List<ContentVersion>(); 
            // Find if the file already exists
            contentVersionExisting = [select id,VersionNumber,VersionData, ContentDocumentId from ContentVersion WHERE title =: filename];
            // If the file is not found and create the contentversion object with the content
            if(contentVersionExisting.IsEmpty()){
                contentVersion contentVersion = new ContentVersion(); 
                contentVersion.Title = filename; 
                contentVersion.PathOnClient = '/'+contentVersion.Title ; 
                contentVersion.VersionData = body; 
                contentVersion.IsMajorVersion = false;
                Insert contentVersion;
                System.debug('ContentVersion:'+contentVersion);
                contentVersion = [select id, ContentDocumentId from ContentVersion WHERE Id =: contentVersion.Id];
                // Link the content document to the coverform Object
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = contentVersion.ContentDocumentId;
                cl.LinkedEntityId = coverForm.Id; 
                cl.ShareType = 'V';
                cl.Visibility = 'AllUsers';
                insert cl;
                System.debug('ContentDocumentLink:'+cl);
            }
            else{
                // select the exeisting content version
                contentVersionExisting[0].VersionData=body;
                update contentVersionExisting[0];
            }
            
        } else {
            system.debug('Ran twice');
        }
        
    } 
    
/************************************
Name:getAuthors()
Purpose: Returns the Authors for the Selected Coverform
***************************************/
 @AuraEnabled
    public static List<Contact> getAuthors(Id id){
        System.debug('Entered into getAuthors');
        return [SELECT id ,Name, Email,Salutation,Pricipal_Author__c,Title,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingAddress, Organization__c, of_Total_Effort__c,non_EPA_Personnel__c,Seperation_Date__c,Position_Title__c from contact where Cover_Form__c =:id ] ;
    }  
    /************************************
Name:getPublications()
Purpose: Returns the Publications for the Selected Coverform
***************************************/
 @AuraEnabled
    public static List<Line_item__C> getPublications(Id id){
        System.debug('Entered into getPublications');
        return [select Publication_Date__c, Contributing_Authors__c,Publication_Title__c, Journal_Publication_Method__c,Immediate_Index__c,Citation_Of_Life__c,Volume__c,Number__c,Pages__c,Impact_Factor__c from Line_Item__c where Cover_Form__c =:id ];
    }
 @AuraEnabled
    public Static List<ContentDocument> getAttachments(Id id){
    System.debug('Entered into getAttachments');
     List<Id> contentIds= new List<Id>();
     List<ContentDocumentLink> conDocLinks=[select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :id];
     for(ContentDocumentLink con : conDocLinks){
         contentIds.add(con.ContentDocumentId);
     }
     return [select Title,description from contentdocument where ID in :contentIds];
    }
}