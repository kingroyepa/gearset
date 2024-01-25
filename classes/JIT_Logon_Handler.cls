/*
* @author Roy King
* @Name: JIT_Logon_Handler
* @description Class to unfreeze user accounts upon logon, if acct is 'activated'
* @date Created at 1/10/2020
*/
global class JIT_Logon_Handler implements Auth.SamlJitHandler {

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
        return null;
    } 

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier, Map<String, String> attributes, String assertion) {
         // If user is frozen, unfreeze them
        List<User> u = [Select name,Id,isActive from user where Id=:userId limit 1];
        if (u[0].isActive) {
            UserLogin frzId = (UserLogin) [SELECT Id,isfrozen FROM UserLogin WHERE UserID = :u[0].Id LIMIT 1];
            if (frzId.IsFrozen) {
                frzId.IsFrozen = false;
                update frzId;
                // Store action in audit log
                System.enqueueJob(new UserLogHandler(u,'Unfreeze','via JIT'));
            }
        }
    }
}   
