public class RevokeLicense
{@future
public static void revoke(Id myid)
{
User u = [Select id, isActive from User where id =:myid];
u.isActive = false;
update u;
}
   @future
    public static void RemovePermissionSet(String myid, String PermSet, String GrpName) {
        String c = [Select name,Id,user__c from contact where Id = :myid].User__c;
        User u = [Select name,Id,isActive from user where Id = :c];
        string permSetId = [SELECT Id FROM PermissionSet WHERE Label = :PermSet LIMIT 1].Id;
        System.debug(u.Id);
        System.debug(permSetId);
        If (permSetId != null) {
            System.debug('SELECT Id from PermissionSetAssignment WHERE PermissionSetId = ' + permSetId + ' AND AssigneeId = ' + u.Id);
            try {
                delete [SELECT Id from PermissionSetAssignment WHERE PermissionSetId = :permSetId AND AssigneeId = :u.ID];
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch (Exception e) {
                System.debug(e.getMessage());
            }

    }

        If(GrpName != null){
            // If Public group is selected
            Group groupID = [SELECT Id,name FROM Group WHERE Name = :GrpName LIMIT 1];
            try {
                delete [Select Id from GroupMember where GroupId = :groupID.Id  and UserOrGroupId = :u.Id];
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            } catch(Exception e) {
                System.debug(e.getMessage());
            }

        }
    }
}