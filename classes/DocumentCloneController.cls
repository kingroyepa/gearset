/**
 * The DocumentCloneController class has methods to clone a document object and its related line items, if any.
 */

public with sharing class DocumentCloneController {
    private ApexPages.StandardController controller { get; set; }
    private Document__c document { get; set; }

    public DocumentCloneController(ApexPages.StandardController controller) {
        this.controller = controller;
        document = (Document__c) controller.getRecord();
    }

    public PageReference cloneDocument() {
        Savepoint sp = Database.setSavepoint();
        Document__c newDocument;
        List<Line_Item__c> newLineItems = new List<Line_Item__c>();

        try {
            document = [
                    SELECT AHRC__c, Allowance_Holder__c, Alternate_Project_Officer__c, Alternate_Work_Assignment_Manager__c,
                            Appropriation__c, Bankcard_Holder__c, Document_Preparer__c, Requester__c, Vendor_Record__c, RecordTypeId,
                            EAS_PR_Number__c, Expenditure_Type__c, TA_Number__c, Traveler__c, Travel_Destination_Country__c, Travel_Destination_State__c,
                            Travel_Destination__c, Travel_Type__c, Travel_Purpose__c, Travel_Start_Date__c, Travel_End_Date__c, BBFY_EBFY__c,
                            File_Name__c, Operating_Plan_Year__c, PRC__c, Account_Name__c, BOC_Category__c, FTE_Op_Plan__c,
                            Primary__c, Project__c
                    FROM Document__c
                    WHERE Id = :document.Id
            ];
            newDocument = document.clone(false, false, false, false);
            insert newDocument;

            List<Line_Item__c> lineItems = [
                    SELECT Appropriation__c, BBFY_EBFY__c, PRC__c, Allowance_Holder__c, AHRC__c, Budget_Org__c,
                            Op_Plan_Year__c, Site_Code__c, Project_Task__c, FOC__c, BOC__c, Vehicle_Record2__c, Order_Record__c, RecordTypeId
                    FROM Line_Item__c
                    WHERE DCR_Document__c = :document.Id
            ];

            if (!lineItems.isEmpty()) {
                for (Line_Item__c item : lineItems) {
                    Line_Item__c newLineItem = item.clone(false, false, false, false);
                    newLineItem.Id = null;
                    newLineItem.DCR_Document__c = newDocument.Id;
                    System.debug('New Line Item Object: ' + newLineItem);
                    newLineItems.add(newLineItem);
                }

                insert newLineItems;
            }
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }

        return new PageReference('/' + newDocument.Id);
    }
}