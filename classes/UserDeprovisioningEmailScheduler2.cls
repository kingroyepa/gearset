/*
* @author Omer
* @description Scheduler class for UserDeprovisioningEmail Batch
* @date Created at 2019-10
*/
global class UserDeprovisioningEmailScheduler2 implements Schedulable {
    global void execute(SchedulableContext SC){
        UserDeprovisionemail2 userdeporv = new UserDeprovisionemail2();
        ID idBatch = Database.executeBatch(userdeporv, 200);
    }
}