/**

* Created by Mounika Suram on 7/26/2018.

* Purpose -PCOR Application. To test the methods of order request in the FormPageController

*/

 

@istest

public class TypeOneOrderRequestPageTest {

 

 

    @isTest

    static void testGetOrderRTs(){

        // Get user and set the session Id

        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Lan_ID__c = 'thetest_pcor' limit 1];

        // Create a permission set and assign it to the user

        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = [select id from PermissionSet where Label like '%BAPForms User%' limit 1].ID, AssigneeID = u.Id);

            try{

            insert psa;

            }

            catch (Exception e){

            system.debug(e.getMessage());

            }

 

        system.assert(FormPageController.getOrderRecordTypes('123UY009').size() > 0);

      

    }

 

    @isTest

    static void testInsertNewOrders(){

        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Lan_ID__c = 'thetest_pcor' limit 1];

        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];

        //siteUser

        User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];

 

        //apiUser

        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

 

        contact c = [select id,FirstName,lastname,Lan_ID__c from contact where Lan_ID__c = 'thetest_pcor' limit 1 ];
 

        Order_Request__c testOrd= new Order_Request__c();

        testOrd.Title__c='test';

        testOrd.Unauthenticated_Owner__c = u.id;

        testOrd.Request_Type__c='IT/E&IT Purchase';

        testOrd.Card_Holder__c=u.id;

        testOrd.Approving_Official__c=u.id;

        testOrd.FCO__c=u.id;

        testOrd.IT_Official__c=u.id;

        testOrd.RecordTypeId=[select id from RecordType where SobjectType='Order_Request__C' and DeveloperName='Purchase_Card_Order_Request'].Id;

        insert testOrd;

        Order_Request__c ord;

        try{

             ord = FormPageController.insertNewOrders('123UY009',[select id from RecordType where SobjectType='Order_Request__C' and DeveloperName='Purchase_Card_Order_Request'].id,uSU.id, uAU.id);

        }

        catch(exception ex){

        system.debug(ex.getMessage());

        }

 

        if (testOrd.id != null) {FormPageController.submitForApproval(testOrd.ID, '123UY009'); }

        FormPageController.submitForApprovalForOrder(testOrd.ID, '123UY009');

        FormPageController.findExistingOrders('xyz');

        FormPageController.findExistingOrders('123UY009');

        FormPageController.viewOrder(testOrd.ID, uSU.id);

        FormPageController.viewOrder(ord.ID, uSU.id);
        
        Order_Request__C o2 =FormPageController.cloneOrder('123UY009', ord.ID);

        FormPageController.deleteOrder(ord.ID, '123UY009');

        UtilityMethods.addOrderShare(testOrd.ID, uSU.id);

        FormPageController.removeOrderShare(testOrd.ID, uSU.id);

        FormPageController.recallApprovalForOrder(testOrd.ID, '123UY009');

      String supportInfo = FormPageController.orderSupportInfo(testOrd.ID);

 

    }

 

    @isTest

   static void testErrorDML(){

 

      User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Lan_ID__c = 'thetest_pcor' limit 1];

        

        //siteUser

        User uSU = [select id from User where isActive = true AND id != :u.id limit 1];

 

        //apiUser

        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :uSU.id limit 1];

 

 

        try{

        Order_Request__c ord = FormPageController.insertNewOrders('123UY009', [select id from RecordType where sObjectType = 'Account' limit 1].ID, uSU.id, uAU.id);

        }

        catch(exception ex){

        system.debug(ex.getMessage());

        }

 

    }

 

    @isTest

    static void testAttachmentMethods(){

        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Lan_ID__c = 'thetest_pcor' limit 1];

        contact c = [select id,FirstName,lastname,Lan_ID__c from contact where Lan_ID__c = 'thetest_pcor' limit 1 ];

        
        Order_Request__c testOrd= new Order_Request__c();

        testOrd.Title__c='test';

        testOrd.Unauthenticated_Owner__c = u.id;

        testOrd.Request_Type__c='IT/E&IT Purchase';

        testOrd.Card_Holder__c=u.id;

        testOrd.Approving_Official__c=u.id;

        testOrd.IT_Official__c=u.id;

        testOrd.FCO__c=u.id;

        testOrd.RecordTypeId=[select id from RecordType where SobjectType='Order_Request__C' and DeveloperName='Purchase_Card_Order_Request'].Id;

        insert testOrd;

 

        //create test data: file

        ID orderId = testOrd.id;

        String fileName = 'testFile.txt';

        String base64Data = 'testdata';

        String contentType = 'text/plain';

 

        String attID = FormPageController.uploadFile(orderId, fileName, base64Data, contentType);

        FormPageController.getListOfAttachmentsForOrders(orderId);

        FormPageController.deleteFormAttachment(attID);

 

       

        id attChunkid;

        FormPageController.saveChunk(orderId,'att',base64Data,contentType,'');

        id att2 = FormPageController.saveTheFile(orderId,'att',base64Data,contentType);

        FormPageController.saveChunk(orderId,'att',base64Data,contentType,att2);

 

 

        //test files

        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

 

        ContentVersion cv = new ContentVersion();

        cv.title = 'test content trigger';

        cv.PathOnClient ='test';

        cv.VersionData =beforeblob;

        insert cv;

 

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

 

        ContentDocumentLink contentlink=new ContentDocumentLink();

        contentlink.LinkedEntityId=orderId;

        contentlink.ShareType= 'V';

       contentlink.ContentDocumentId=testcontent.ContentDocumentId;

 

        insert contentlink;

 

        FormPageController.getListOfFilesForOrders(orderId);

 

    }

 

    @isTest

    static void testApprovalRecall(){

        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and Lan_ID__c = 'thetest_pcor' limit 1];

        contact c = [select id,FirstName,lastname,Lan_ID__c from contact where Lan_ID__c = 'thetest_pcor' limit 1 ];

 

        Order_Request__c testOrd= new Order_Request__c();

        testOrd.Title__c='test';

        testOrd.Unauthenticated_Owner__c = u.id;

        testOrd.Request_Type__c='IT/E&IT Purchase';

        testOrd.Card_Holder__c=u.id;

        testOrd.Approving_Official__c=u.id;

        testOrd.IT_Official__c=u.id;

        testOrd.FCO__c=u.id;

        testOrd.RecordTypeId=[select id from RecordType where SobjectType='Order_Request__C' and DeveloperName='Purchase_Card_Order_Request'].Id;

        insert testOrd;

 

        id orderId = testOrd.id;

 

        FormPageController.submitForApprovalForOrder(orderId, '123UY009');

        FormPageController.recallApprovalForOrder(orderId, '123UY009');

    }

 

    @isTest

    static void testLineItems(){

 

        string liRT = FormPageController.getLineItemRTForOrders();

 

        String rtID = [Select Id From RecordType Where SobjectType = 'Line_Item__c' and IsActive = true and  developerName ='PCOR_Items' limit 1].Id;

 

 

        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];

        User u2 = [select id from User where isActive = true and PRofile.Name = 'System Administrator' and id != :u.id limit 1];

        u.Session_Token__c = '123UY';

        u.Lan_ID__c = 'thetest5';

        update u;

 

        //siteUser

        User uSU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id limit 1];

 

        //apiUser

        User uAU = [select id from User where isActive = true AND id != :u.id AND id != :u2.id AND id != :uSU.id limit 1];

 

        contact c = new contact(FirstName='Mounika', LastName='Suram', Lan_ID__c = 'thetest5');

        insert c;

 

        Order_Request__c ord = FormPageController.insertNewOrders('123UY',[select id from RecordType where SobjectType='Order_Request__C' and DeveloperName='Purchase_Card_Order_Request'].id, uSU.id, uAU.id);

 

        List<Line_Item__c> liList = FormPageController.getListOfLineItemsForOrders(ord.ID);

 

        Line_Item__c litem = FormPageController.insertLineItemForOrder('123UY', ord.id, uSU.ID, uAU.ID);

        litem.item_price__c= 100;

        litem.Quantity__c=1;

        update litem;

        

        String d1 = 'Name';

        string d2 = 'Item_Name__c';

        string d3 = 'Item_Price__c';

        string d4 = 'Quantity__c';

        string d5 = 'Total__c';

        List<Line_Item__c> litems = FormPageController.getLineItemDataForOrders(d1, d2, d3, d4, d5, ord.ID);

        List<string> displays = FormPageController.getLineItemDisplayFields(rtID);

        List<string> datas = FormPageController.getLineItemDataFields(rtID);

        Line_Item__c litem2 = FormPageController.getLineItem(litem.ID);

        FormPageController.submitForApprovalForOrder(ord.ID, '123UY');

        FormPageController.recallApprovalForOrder(ord.ID, '123UY');

        UtilityMethods.addOrderShare(ord.id, uSU.id);        

        FormPageController.removeOrderShare(ord.id, uSU.id);        

        string msg =  FormPageController.deleteLineItem(litem.ID, 'x');

        

         

    }
    @testsetup
    public static void setup(){
        User u = [select id from User where isActive = true and PRofile.Name = 'System Administrator' limit 1];

        u.Session_Token__c = '123UY009';

        u.Lan_ID__c = 'thetest_pcor';

        update u;
         contact c = new contact(FirstName='Mounika', LastName='Suram', Lan_ID__c = 'thetest_pcor');

        insert c;
        
    }

 

}