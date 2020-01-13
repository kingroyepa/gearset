public class UserTriggerHandler {
    public static Boolean isFirstTime = true;   //used in BeforeUpdate
    public static Boolean isFirstTimeAfter = true;   //used in AfterUpdate
    
    public void afterUpdate(List<User> newMap,List<User> oldMap){
        //if(isFirstTimeAfter){
        //isFirstTimeAfter = false;
        
        // If activation status hasnt change dont do anything
        if (oldMap[0].isActive != newMap[0].isActive){
            System.enqueuejob(new UserLogHandler(Trigger.new,null,'Via User Trigger'));
        }
        //}
    }
    
}