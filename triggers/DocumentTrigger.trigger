trigger DocumentTrigger on Document__c (before insert, before update, after insert, after update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        List<Document__c> beforeInsertBudgetDocuments = new List<Document__c>();

        for (Document__c document : Trigger.new) {
            if (AwardConstants.AWARD_BUDGET_RECORDTYPEID_SET.contains(document.RecordTypeId)) {
                beforeInsertBudgetDocuments.add(document);
            }
        }

        if (!beforeInsertBudgetDocuments.isEmpty()) {
            DocumentTriggerHelper.doArttBudgetControls(beforeInsertBudgetDocuments);
            DocumentTriggerHelper.setTotalBudget(beforeInsertBudgetDocuments);
        }

    }

    if(Trigger.isBefore && Trigger.isUpdate) {
        List<Document__c> beforeUpdateBudgetDocuments = new List<Document__c>();

        for (Document__c document : Trigger.new) {
            if (AwardConstants.AWARD_BUDGET_RECORDTYPEID_SET.contains(document.RecordTypeId)) {
                beforeUpdateBudgetDocuments.add(document);
            }
        }

        if (!beforeUpdateBudgetDocuments.isEmpty()) {
            DocumentTriggerHelper.doArttBudgetControls(beforeUpdateBudgetDocuments);
            DocumentTriggerHelper.setTotalBudget(beforeUpdateBudgetDocuments);

        }
    }

    if(Trigger.isAfter && Trigger.isUpdate) {
        List<Document__c> afterUpdateBudgetDocuments = new List<Document__c>();

        for (Document__c document : Trigger.new) {
            if (AwardConstants.AWARD_BUDGET_RECORDTYPEID.equals(document.RecordTypeId)) {
                afterUpdateBudgetDocuments.add(document);
            }
        }

        if (!afterUpdateBudgetDocuments.isEmpty()) {
            DocumentTriggerHelper.updateControlBudgets(afterUpdateBudgetDocuments);
        }
    }

    if(Trigger.isAfter && Trigger.isInsert) {
        List<Document__c> afterInsertBudgetDocuments = new List<Document__c>();

        for (Document__c document : Trigger.new) {
            if (AwardConstants.AWARD_BUDGET_RECORDTYPEID.equals(document.RecordTypeId)) {
                afterInsertBudgetDocuments.add(document);
            }
        }

        if (!afterInsertBudgetDocuments.isEmpty()) {
            DocumentTriggerHelper.updateControlBudgets(afterInsertBudgetDocuments);
        }
    }
}