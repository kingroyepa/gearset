/**
 * Methods called from LineItemTrigger.
 */
public class LineItemTriggerHelper {
    // Record type map for easy identification of DCR record types and Ids
    public static Map<Id, RecordType> dcrRecordTypeIdMap = new Map<Id, RecordType>([
            SELECT Id, Name
            FROM RecordType
            WHERE SobjectType = 'Line_Item__c'
            AND Name IN ('DCR Bankcard Purchase Line Item', 'DCR Contract Line Item', 'DCR Grant Line Item',
                    'DCR IA Line Item', 'DCR Other Line Item', 'DCR Travel Line Item', 'DCR Contract Line Item (O)')
    ]);

    /**
     * Whenever a DCR line item is created or updated, calculate the total amount of all line items related to the object
     * and add that total to the object specified.
     *
     * @param recordIds sObject Ids that are related to an updated/inserted DCR line item.
     * @param objectName sObject API name provided from the updated/inserted DCR line item.
     */
    private static void calculateLineItemTotalsOnSObject(List<Id> recordIds, String objectName) {
        // Map of line item lookup field to sObject that needs to be updated
        Map<String, String> sObjectToLookupFieldMap = new Map<String, String>{
                'Document__c' => 'DCR_Document__c',
                'EPA_Agreement__c' => 'Vehicle_Record2__c',
                'EPA_Order__c' => 'Order_Record__c'
        };

        String queryString = 'SELECT ' + sObjectToLookupFieldMap.get(objectName) + ', SUM(Amount__c) totalAmount FROM Line_Item__c WHERE ' + sObjectToLookupFieldMap.get(objectName) + ' IN :recordIds GROUP BY ' + sObjectToLookupFieldMap.get(objectName);

        if (!recordIds.isEmpty()) {

            // Get the line item totals grouped by Document Id
            System.debug('>>>>> Query string: ' + queryString);
            AggregateResult[] lineItemTotals = Database.query(queryString);

            // Create a new document object to update from the aggregate results
            if (!lineItemTotals.isEmpty()) {
                List<SObject> objectList = new List<SObject>();

                for (AggregateResult result : lineItemTotals) {
                    Id recordId = (Id) result.get(sObjectToLookupFieldMap.get(objectName));
                    SObject tempObject = recordId.getSObjectType().newSObject(recordId);
                    tempObject.put('Line_Item_Total__c', (Decimal) result.get('totalAmount'));

                    objectList.add(tempObject);
                }

                // Update the documents
                update objectList;
            }
        }
    }

    /**
     * Whenever a line item is updated/inserted, add populated lookup field values to lists and then update those
     * related records with the sum of line item amounts related to that record.
     *
     * @param lineItems DCR Line Item records that have been updated/inserted.
     */
    public static void updateLineItemTotalsOnSObjects(List<Line_Item__c> lineItems) {
        if (!lineItems.isEmpty()) {
            List<Id> documentIds = new List<Id>();
            List<Id> orderIds = new List<Id>();
            List<Id> agreementIds = new List<Id>();

            // Add populated line item lookup field values to lists for DCR Line Items
            for (Line_Item__c item : lineItems) {
                if (dcrRecordTypeIdMap.keySet().contains(item.RecordTypeId)) {
                    if (item.DCR_Document__c != null) {
                        documentIds.add(item.DCR_Document__c);
                    }

                    if (item.Vehicle_Record2__c != null) {
                        agreementIds.add(item.Vehicle_Record2__c);
                    }

                    if (item.Order_Record__c != null) {
                        orderIds.add(item.Order_Record__c);
                    }
                }
            }

            // If the lists are populated, then call the calculate line items method and provide the Ids and object API name
            if (!documentIds.isEmpty()) {
                calculateLineItemTotalsOnSObject(documentIds, 'Document__c');
            }

            if (!orderIds.isEmpty()) {
                calculateLineItemTotalsOnSObject(orderIds, 'EPA_Order__c');
            }

            if (!agreementIds.isEmpty()) {
                calculateLineItemTotalsOnSObject(agreementIds, 'EPA_Agreement__c');
            }
        }
    }
}