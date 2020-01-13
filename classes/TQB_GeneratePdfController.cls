/**********************************************************************
Name: TQB_GeneratePdfController()

======================================================
======================================================
Purpose:
-------
Created this class to generate pdf document with the candidate package details
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
1.0 - Mounika Suram 5/17/2019 INITIAL DEVELOPMENT 
***********************************************************************/
public class TQB_GeneratePdfController {
	//Holds the redirect which determines whether the page should be redirected or not
    Private boolean isRedirect {get;set;}
    // Holds the current date
    Date myDate = system.today();
    //Holds the candidate application object
    Private Candidate_Application__c application;

    public Boolean initialised{get; set;}
    
/************************************
Name:Constructor
Purpose: To initialize the values when the class is instantiated
***************************************/
    public TQB_GeneratePdfController(ApexPages.StandardController stdController) {
        this.application = (Candidate_Application__c)stdController.getRecord();
        id applicationId = ApexPages.currentPage().getParameters().get('id');
        initialised=false;            
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
Purpose: Generates Pdf for the rendered content and Attchaches it to the selected application
***************************************/
    public void saveAttachment() {
        System.debug('Entered into saveAttachments');
        if (!initialised && application.ID !=NULL) {
            // Set the page reference to the current page
           PageReference pdf = Page.TQB_GeneratePdf;
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
            string filename = 'TQB Record - ' + application.Id + ' - ' + system.Now() +'.pdf';
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
                // Link the content document to the candidate application Object
                ContentDocumentLink cl = new ContentDocumentLink();
                cl.ContentDocumentId = contentVersion.ContentDocumentId;
                cl.LinkedEntityId = application.Id; 
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
}