/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_savePDF 
*    Class called VisualForce page to attached data to files of the eOrder record when 'Generate Document' button pushed
**/
public class ORDGAS_savePDF {
    public boolean isRedirect {get;set;}
    public String orderNumber {get;set;}
  
    // The extension constructor initializes the private member
    // variable pageeOrd by using the getRecord method from the standard
    // controller.
    Date myDate = system.today();
    Private eOrders__c pageeOrd;
    public Boolean initialised{get; set;}

    //Constructor
    public ORDGAS_savePDF(ApexPages.StandardController stdController) {
        this.pageeOrd = (eOrders__c)stdController.getRecord();
        id pageeOrdId = ApexPages.currentPage().getParameters().get('id');
        initialised=false;
        orderNumber = [select Order_Number__c from eOrders__c where id=:pageeOrdId].Order_Number__c;
        system.debug('id = ' + pageeOrd.id + '     id2' +pageeOrdId);
        isRedirect = false;
    }

    public void redirectToPDFPage(){
        isRedirect = true;
    }
    
//method to insert attachement call it on page on click of button 
    public void saveAttachement() {
        if (!initialised && pageeOrd.ID !=NULL) {

        PageReference pdf = Page.EOrderPage;
        // create the new attachment
        Attachment attach = new Attachment();
        // the contents of the attachment from the pdf

        //body = pdf.getContentAsPDF();
        Blob body;
        try{
            body = pdf.getContentAsPDF();
        }catch(Exception e){
            body = EncodingUtil.base64Decode('TestFileData');
        }
        string filename = 'eOrder_'+ orderNumber +'.pdf';
        system.debug('body should be fine>>>' +filename);
        List<ContentVersion> contentVersionExisting = new List<ContentVersion>(); 
        contentVersionExisting = [select id,VersionNumber,VersionData, ContentDocumentId from ContentVersion WHERE title =: filename];
        if(contentVersionExisting.IsEmpty()){
            contentVersion contentVersion = new ContentVersion(); 
            contentVersion.Title = filename; 
            contentVersion.PathOnClient = '/'+contentVersion.Title ; 
            contentVersion.VersionData = body; 
            contentVersion.IsMajorVersion = false;
            Insert contentVersion;
            contentVersion = [select id, ContentDocumentId from ContentVersion WHERE Id =: contentVersion.Id];
            ContentDocumentLink cl = new ContentDocumentLink();
            cl.ContentDocumentId = contentVersion.ContentDocumentId;
            cl.LinkedEntityId = pageeOrd.Id; 
            cl.ShareType = 'V';
            cl.Visibility = 'AllUsers';
            insert cl;
        }else{
            contentVersionExisting[0].VersionData=body;
            update contentVersionExisting[0];
            
        }
        eOrders__c order = [SELECT Status__c FROM eOrders__c WHERE Id =:pageeOrd.Id ];
        if(order.Status__c == 'Draft'){
            order.Status__c = 'Activated';
            update order;
        }

        } else {
          system.debug('tried to run twice');
      }
      
    } 
}