trigger EpaAgreementTrigger on EPA_Agreement__c (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        EpaAgreementTriggerHelper.updateMasterContractLineItemTotal(Trigger.new);
    }
}