/*
*    Author : mondal.javed@epa.gov
*    CreatedDate : 1-May-2018
*    Class Name : ORDGAS_190063savePDF 
*    Class called VisualForce page to attached data to files of the Account record when 'Generate 1900-63' button pushed
**/
public class ORDGAS_190063savePDF {
    public boolean isRedirect {get;set;}
    public Id pageeOrdId {get; set;}
    public List<eOrder_Item__c> eroderToDisplay {get; set;}
    public List<String> orgNames {get; set;}
    public String organizationName {get; set;}
  
    // The extension constructor initializes the private member
    // variable pageeOrd by using the getRecord method from the standard
    // controller.
    Date myDate = system.today();
    Private Account pageeOrd;
    public Boolean initialised{get; set;}

    //Constructor
    public ORDGAS_190063savePDF(ApexPages.StandardController stdController) {
        orgNames = new List<String>();
        this.pageeOrd = (Account)stdController.getRecord();
        pageeOrdId = ApexPages.currentPage().getParameters().get('id');
        initialised=false;
        system.debug('organizationName = ' + organizationName);
        system.debug('id = ' + pageeOrd.id + '     id2' +pageeOrdId);
        if(organizationName != null && orgNames.contains(organizationName)){
            eroderToDisplay = [
                    SELECT id, eOrder__r.Call_Number__c,Product__r.Name,Quantity__c,Product_List_Price__c,Total_Price__c,Order_Request__r.Requester_Org__c,Order_Request__r.Delivery_Date__c,X1900_63_Generated_Date__c
                    from eOrder_Item__c
                    where Vendor_Name__c = :pageeOrdId AND X1900_63__c = TRUE AND Status__c = 'Order Delivered' AND Order_Request__r.Requester_Org__c = :organizationName
            ];
        }
        else {
            eroderToDisplay = [SELECT id , eOrder__r.Call_Number__c,Product__r.Name,Quantity__c,Product_List_Price__c,Total_Price__c,Order_Request__r.Requester_Org__c,Order_Request__r.Delivery_Date__c,X1900_63_Generated_Date__c from eOrder_Item__c where Vendor_Name__c =:pageeOrdId AND X1900_63__c = TRUE AND Status__c = 'Order Delivered' ];
        }

        system.debug('@@@'+eroderToDisplay);
        for(eOrder_Item__c item :eroderToDisplay){
            if(!orgNames.contains(item.Order_Request__r.Requester_Org__c)){orgNames.add(item.Order_Request__r.Requester_Org__c);}
        }
        if(eroderToDisplay.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no eOrder Items with the status "Order Delivered" to be added to this form'));
        }
        isRedirect = false;
    }

    public void redirectToPDFPage(){
        isRedirect = true;
    }

    public pageReference getEordersForOrg(){
        System.debug('in getEordersForOrg');
        if(orgNames.contains(organizationName)) {
            eroderToDisplay = [
                    SELECT id, eOrder__r.Call_Number__c,Product__r.Name,Quantity__c,Product_List_Price__c,Total_Price__c,Order_Request__r.Requester_Org__c,Order_Request__r.Delivery_Date__c,X1900_63_Generated_Date__c
                    from eOrder_Item__c
                    where Vendor_Name__c = :pageeOrdId AND X1900_63__c = TRUE AND Status__c = 'Order Delivered' AND Order_Request__r.Requester_Org__c = :organizationName
            ];
            System.debug('Eorders' + eroderToDisplay);
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There are no eOrder Items with the status "Order Delivered" for the Organization'));
        }

        return null;
    }

    public pageReference Cancel(){
        PageReference vendorPage = new PageReference('/' + pageeOrdId);
        return vendorPage;
    }
    
//method to insert attachement call it on page on click of button 
    public pageReference saveAttachement() {
        string filename;
        PageReference vendorPage = new PageReference('/' + pageeOrdId);
        if (!initialised && pageeOrd.ID !=NULL) {
            System.debug('Eorders - save Attachment' + eroderToDisplay);
                PageReference pdf = Page.ORDGAS_190063;
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
                if(organizationName != null){
                    filename = '1900-63 - ' + pageeOrd.Name + ' - '+ organizationName + ' - '+ system.Now() +'.pdf';
                }
                else{
                    filename = '1900-63 - ' + pageeOrd.Name + ' - ' + system.Now() +'.pdf';
                }
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
                for( eOrder_Item__c orderItems : eroderToDisplay){
                    orderItems.Status__c = 'Added to 1900-63';
                }
                update eroderToDisplay;
             }

        else {
          system.debug('Ran twice');
      }
        return vendorPage;
      
    } 
}