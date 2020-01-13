trigger EpaOrderTrigger on EPA_Order__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        EpaOrderTriggerHelper.calculateOrderTotalsOnAgreements(Trigger.new);
    }
}