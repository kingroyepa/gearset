/*
* @author Omer
* @description Scheduler class for UserDeprovisioning Batch
* @date Created at 2019-10
*/
global class UserDeprovisioningScheduler implements Schedulable {
    global void execute(SchedulableContext SC){
        UserDeprovisioning userdeporv = new UserDeprovisioning();
        //string cronExp = '0 0 22 * * ? *';
        //string JobId = system.schedule('User_Deprovisioning', cronExp, sc);
        ID idBatch = Database.executeBatch(userdeporv, 200);
    }
}