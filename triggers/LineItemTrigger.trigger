/**
 * Created by justindove on 9/7/18.
 */

trigger LineItemTrigger on Line_Item__c (after insert, after update, after delete) {
    if (Trigger.isAfter && Trigger.isInsert) {
        LineItemTriggerHelper.updateLineItemTotalsOnSObjects(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        LineItemTriggerHelper.updateLineItemTotalsOnSObjects(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isDelete) {
        LineItemTriggerHelper.updateLineItemTotalsOnSObjects(Trigger.old);
    }
}