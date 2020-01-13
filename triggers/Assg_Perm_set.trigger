trigger Assg_Perm_set on Forms__c (after update) {
    ID PermSetRT = Schema.SObjectType.Forms__c.getRecordTypeInfosByName().get('BAP User Provisioning').getRecordTypeId();
    // ID PermSetRT = [select id from recordtype where name = 'BAP User Proivisioning'].Id;
     if (trigger.new[0].recordtypeid == PermSetRT && trigger.new[0].Form_Type__c == 'Permission Set' &&  trigger.new[0].Form_Status__c == 'Approved')
     { 
        GrantLicense.AssignPermissionSet(Trigger.new[0].Technical_Contact__c, Trigger.new[0].Permission_Set_Name__c, Trigger.new[0].Public_Group__c);  
     } 
}