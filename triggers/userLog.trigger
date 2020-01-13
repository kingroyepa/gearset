trigger userLog on User (after update) {
   if (trigger.isAfter && trigger.isUpdate) new UserTriggerHandler().afterUpdate(trigger.new,trigger.old);
}