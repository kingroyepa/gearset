/*
* @author Omer
* @description Scheduler class for UserDeprovisioningEmail Batch
* @date Created at 2019-10
*/
global class UserDeprovisioningEmailScheduler implements Schedulable {
    global void execute(SchedulableContext SC){
        UserDeprovisionEmail userdeporv = new UserDeprovisionEmail();
        ID idBatch = Database.executeBatch(userdeporv, 200);
    }
}