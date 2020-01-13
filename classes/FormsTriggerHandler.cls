public class FormsTriggerHandler {
    public static Boolean isFirstTime = true;   //used in BeforeUpdate
    public static Boolean isFirstTimeAfter = true;   //used in AfterUpdate
    
    public void beforeInsert(List<Forms__c> forms){
        system.debug('in beforeInsert');
        for (forms__c form : forms){
          //if Type-3 user creating form, sets Type-1 Owner field to that user
          //otherwise, Type-1 user is Type-1 Owner
            if(form.Unauthenticated_Owner__c == null){ 
                form.Unauthenticated_Owner__c = userInfo.getUserID();
              }
            form.Originator_Type1__c = form.Form_Owner__c;
             // Mounika Suram 3/15/2019 - Updated to correct the form conflation of similarly named users
            form.Originator_Type1_ID__c = form.Unauthenticated_Owner__c;
            
            //find and set Type-1 Owner Contact  
            try{ 
                string uLan = [select LAN_ID__c from user where ID = :form.Unauthenticated_Owner__c].LAN_ID__c;          
                form.Type_1_Owner_Contact__c = [select id,LAN_ID__c from contact where LAN_ID__c = :uLan limit 1].id;
               }
               catch(Exception e) {       
                    Trigger.new[0].addError('No related Contact record found for User');
               }
          }
        
        updateFormLookups(forms, true);
    }
    
    public void beforeUpdate(Map<id,Forms__c> formMap){
        system.debug('in beforeUpdate');
        if(isFirstTime){
        isFirstTime = false;
        updateFormLookups(formMap.values(), false);
        
        // (sf-182 / ord-111 / OHR processes -- set form owner to person prepared for and then clear Prepare For field
        for (forms__c form : formMap.values()) {
    
            if (form.Approval_Step__c != null) {
                if (form.Prepare_Form_for__c != null && String.valueOf(form.Approval_Step__c).startsWith('Form Prepared for')) {
                    contact c = [select id, LAN_ID__c from contact where id = :form.prepare_Form_for__c limit 1];
                    user u = [select id, LAN_ID__c from user where LAN_ID__c = :c.LAN_ID__c limit 1];                    
                    if (form.Unauthenticated_Owner__c == null){
                        form.ownerid = u.id;}                    
                    else {form.Unauthenticated_Owner__c = u.id;                          
                        }
                    //update Type 1 Owner Contact    
                    form.Type_1_Owner_Contact__c = c.id;
                    //remove value
                    form.Prepare_Form_for__c = null;
                      }
               } // end if approval step is not null            
         } // end for
        }
    }
    
    private void updateFormLookups(List<Forms__c> forms, boolean onInsert){
        system.debug('in updateFormLookups');
        
        Boolean useContact = Contact_Approvers__c.getValues('Use Contact Fields').Use_Contact__c; // checkbox from "Contact Approvers" Custom Setting
        Set<id> uIds = new Set<id>();
        Set<String> lanIds = new Set<String>();
        Map<id, Contact> contactMap = new Map<id, Contact>();
        if (!onInsert) for (Forms__c form : forms) uIds.add(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
        else for (Forms__c form : forms) uIds.add(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            
        Map<id, User> userMap = new Map<id, User>([select id, 
                                                            Supervisor__c, 
                                                            Supervisor_2__c, 
                                                            Time_Keeper__c, 
                                                            Training_Officer__c, 
                                                            Funding_Official__c,
                                                            Supervisors__c,
                                                            Email,
                                                            LAN_ID__c                   // Lan_ID__c exists on both Users and Contacts, 
                                                                                        // used to match records
                                                        from User where id in :uIDs]);
        
        if(!useContact){ 
        for (forms__c form : forms){ // start update from User fields loop
            //get record type name
              recordtype rt = [select id, developerName from recordtype where id = :form.recordtypeid limit 1];
            
            user u;
            if (!onInsert) u =userMap.get(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
            else u =userMap.get(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            if (u != null && rt.developerName == 'SF_182'){
                if(form.Prepare_Form_for__c == null){
                    if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = u.Supervisor__c;}
                    if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = u.Supervisor_2__c;}
                    if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = u.Time_Keeper__c;}
                    if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = u.Training_Officer__c;}
                    if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = u.Funding_Official__c;}
                    if(form.Unlicensed_Owner_Email__c == null && form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = u.Email;}
                  }
                else if(form.Prepare_Form_for__c != null){
                 contact prep4U = [select id, Supervisor__c, Supervisor_2__c, Time_Keeper__c, Training_Officer__c, Funding_Official__c, email from contact where id = :form.Prepare_Form_for__c limit 1];
                  if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = prep4U.Supervisor__c;}
                  if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = prep4U.Supervisor_2__c;} 
                  if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = prep4U.Time_Keeper__c;}
                  if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = prep4U.Training_Officer__c;}
                  if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = prep4U.Funding_Official__c;}
                  if(form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = prep4U.Email;} 
                 }
               }
            else if (u != null && (rt.developerName == 'HR_System_Access_Request' || rt.developerName == 'OGE_450')){
                if(form.Prepare_Form_for__c != null){
                  contact prep4u = [select id, user__c from contact where id = :form.Prepare_Form_for__c limit 1];
                  u = [select id, supervisors__c, lan_id__c from user where id = :prep4u.user__c limit 1];
                 }
                  
                  if(form.Approver_1__c==null && rt.developerName == 'OGE_450'){
                      contact formCT = [select id, accountid from contact where LAN_ID__c = :u.LAN_ID__c limit 1];
                      system.debug('formCT: '+formCT);
                      id acctID = formCT.accountid;
                      account acct = [select id, parentid, Assistant_Deputy_Ethics_Official_1__c from account where id = :acctID limit 1];
                      id adeo;
                      id adeoContactID = acct.Assistant_Deputy_Ethics_Official_1__c;
                      boolean adeoFound = false;
                      
                      while(!adeoFound){
                          system.debug('adeoContactID: '+adeoContactID);
                          if(adeoContactID != null){adeoFound=true;}
                          else {
                               acctID = acct.parentid;
                               acct = [select id, parentid, Assistant_Deputy_Ethics_Official_1__c from account where id = :acctID limit 1];
                               adeoContactID = acct.Assistant_Deputy_Ethics_Official_1__c;
                               if(adeoContactID != null){adeoFound = true;}
                           }
                       }
                      
                      adeo = [select User__c from contact where id = :adeoContactID limit 1].User__c;                              
                      form.Approver_1__c = adeo;
                   }
                  
               }   
            else if (u != null && rt.developerName != 'SF_182' && (rt.developerName != 'HR_System_Access_Request' || rt.developerName != 'OGE_450')){
                if(form.User_supervisor__c == null){form.User_supervisor__c = u.Supervisor__c;}
                form.User_Supervisor_2__c = u.Supervisor_2__c;
                form.User_Time_Keeper__c = u.Time_Keeper__c;
                form.User_Training_Officer__c = u.Training_Officer__c;
                form.User_Funding_Official__c = u.Funding_Official__c;
                form.Unlicensed_Owner_Email__c = u.Email; 
               }
            } // end update from User fields loop
        }
        else { // USE Contact records for approvers
         // get related Contacts
            for (user u : userMap.values()) {  // collecting Lan_ID__c values from Users to find matching Contacts
                   lanIds.add(u.Lan_ID__c);
                }
            contactMap.putAll([select id,
                                Company_Name__c, 
                                Supervisor__c, 
                                Supervisor_2__c, 
                                Time_Keeper__c, 
                                Training_Officer__c, 
                                Funding_Official__c,
                                Email,
                                LAN_ID__c 
                            from Contact where Lan_ID__c in :lanIDs]);
                            
        Map<string,id> lanMap = new Map<string,id>();    // Map of Lan_ID__c and Contact to match with Users (Form owners)
        for (contact c : contactMap.values()) lanMap.put(c.Lan_ID__c, c.id);       
        for (forms__c form : forms){ // start update from Contact fields loop
            recordtype rt = [select id, developerName from recordtype where id = :form.recordtypeid limit 1];
            
            User u;
            Contact c;
            String lan;
            if (!onInsert) u =userMap.get(form.Unauthenticated_Owner__c == null ? form.OwnerID : form.Unauthenticated_Owner__c);
            else u =userMap.get(form.Unauthenticated_Owner__c == null ? userInfo.getUserID() : form.Unauthenticated_Owner__c);
            lan = lanMap.get(u.Lan_ID__c);  // gets Contact ID based on Lan_ID__c
            c = contactMap.get(lan);
            if (c != null && rt.developerName == 'SF_182'){
              if(form.Prepare_Form_for__c == null){
                if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = c.Supervisor__c;}
                if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = c.Supervisor_2__c;} 
                if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = c.Time_Keeper__c;}
                if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = c.Training_Officer__c;}
                if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = c.Funding_Official__c;}
                if(form.Unlicensed_Owner_Email__c == null && form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = c.Email;}
               }
              else if(form.Prepare_Form_for__c != null){
               contact prep4U = [select id, Supervisor__c, Supervisor_2__c, Time_Keeper__c, Training_Officer__c, Funding_Official__c, email from contact where id = :form.Prepare_Form_for__c limit 1];
                if(form.User_supervisor__c == null && form.Approval_Routing_Options__c != null){form.User_supervisor__c = prep4U.Supervisor__c;}
                if(form.User_Supervisor_2__c == null && form.Approval_Routing_Options__c != null){form.User_Supervisor_2__c = prep4U.Supervisor_2__c;} 
                if(form.User_Time_Keeper__c == null && form.Approval_Routing_Options__c != null){form.User_Time_Keeper__c = prep4U.Time_Keeper__c;}
                if(form.User_Training_Officer__c == null && form.Approval_Routing_Options__c != null){form.User_Training_Officer__c = prep4U.Training_Officer__c;}
                if(form.User_Funding_Official__c == null && form.Approval_Routing_Options__c != null){form.User_Funding_Official__c = prep4U.Funding_Official__c;}
                if(form.Approval_Routing_Options__c != null){form.Unlicensed_Owner_Email__c = prep4U.Email;}
               }
            }
            else if (u != null) {
                if(form.Prepare_Form_for__c != null){
                  contact prep4u = [select id, user__c from contact where id = :form.Prepare_Form_for__c limit 1];
                  u = [select id, supervisors__c, lan_id__c from user where id = :prep4u.user__c limit 1];
                  c = [select id, name, company_name__c, Supervisor__c, Supervisor_2__c, Email, Time_Keeper__c, Funding_Official__c, Training_Officer__c from contact where id = :form.Prepare_Form_for__c limit 1];                
                 }
                 
               //   Id OrgRtID = Schema.SObjectType.account.getRecordTypeInfosByName().get('RPIO').getRecordTypeId();
                  contact formCT = [select id, account.name, accountID from contact where LAN_ID__c = :u.LAN_ID__c limit 1];
                    system.debug('formCT: '+formCT);
                if(formCT.account.name != null && formCT.account.name != '' && !formCT.account.name.contains('inactive')){
                try{
                  if(form.Approver_1__c==null && rt.developerName == 'HR_System_Access_Request'){
                      string qname = formCT.account.name;
                        system.debug('qname: '+qname);
                      boolean topLevel = false;
                      if(qname!=null){topLevel = qname.indexOf('-')==-1;}                    
                        system.debug('topLevel: '+topLevel);
                      if(!topLevel){qname = qname.left(qname.indexOf('-'));}
                        system.debug('qname: '+qname);
                      account org = [select id, PMO_RHRO__c from account where name = :qname AND Lookup_Tags__c LIKE '%HR Org%' AND Lookup_Tags__c LIKE '%Top Level%' limit 1];
                      if(org.PMO_RHRO__c!=null){
                          id pmo = org.PMO_RHRO__c;
                              form.Approver_1__c = pmo;
                      }        
                  }
                  }//end try
                  catch(exception ex){system.debug('error: '+ex);}
                }
                  if(rt.developerName == 'OGE_450' && (form.Approver_1__c==null || form.Approver_2__c==null)){
                      // Approver_1__c is ADEO, Approver_2__c is DEO
                      
                      id acctID = formCT.accountid;
                      account acct = [select id, parentid, Assistant_Deputy_Ethics_Official_1__c, Deputy_Ethics_Official__c from account where id = :acctID limit 1];
                      
                     
                          id deo;
                          id adeo;
                          id deoContactID = acct.Deputy_Ethics_Official__c;
                          id adeoContactID = acct.Assistant_Deputy_Ethics_Official_1__c;
                          boolean deoFound = false;
                          boolean notFound = false;
                          id PacctID2 = acctID;
                          account Pacct2 = acct;
                          
                          while(!deoFound && !notFound){
                              if(deoContactID != null){deoFound=true;}
                              else {
                                    PacctID2 = Pacct2.parentid;                                 
                                    if(PacctID2 != null){
                                        Pacct2 = [select id, parentid, Deputy_Ethics_Official__c, Assistant_Deputy_Ethics_Official_1__c from account where id = :PacctID2 limit 1];
                                        deoContactID = Pacct2.Deputy_Ethics_Official__c;
                                        adeoContactID = Pacct2.Assistant_Deputy_Ethics_Official_1__c;
                                     }
                                    else{notFound = true;}    
                                    if(deoContactID != null){deoFound = true;}
                           }
                           
                       }                       
                           if(deoFound){
                               if(form.Approver_2__c==null){
                                   deo = [select User__c from Contact where id = :deoContactID limit 1].user__c;
                                   form.Approver_2__c = deo;
                               }
                               if(form.Approver_1__c==null){
                                   if(adeoContactID!=null){
                                       adeo = [select User__c from Contact where id = :adeoContactID limit 1].user__c;
                                       form.Approver_1__c = adeo;
                                   }
                               }
                            }                               
               }
               
                if(form.User_supervisor__c == null){form.User_supervisor__c = c.Supervisor__c;}
                if(onInsert){form.User_supervisor__c = c.Supervisor__c;}
                if(form.User_Supervisor_2__c == null){form.User_Supervisor_2__c = c.Supervisor_2__c;}
                form.User_Time_Keeper__c = c.Time_Keeper__c;
                form.User_Training_Officer__c = c.Training_Officer__c;
                form.User_Funding_Official__c = c.Funding_Official__c;
                form.Unlicensed_Owner_Email__c = c.Email;
            }
        } // end update from Contact fields loop
        }    
    }
    
    public void afterUpdate(Map<id,Forms__c> formMap){
        if(isFirstTimeAfter){
        isFirstTimeAfter = false;
        system.debug('in after update');
        system.debug('isFirstTimeAfter: '+isFirstTimeAfter);
            
        for (forms__c form : formMap.values()) {
                if(form.Approval_Step__c != 'Approved'){
                    system.debug('approval step does not equal approved');
                    createFormShares(formMap.keyset());
                  }             
            }
        }
    }
    
    @future
    // Shares Form record with Approvers
    public static void createFormShares(Set<id> mainIds){
        system.debug('in createFormShares');
        isFirstTimeAfter = false;
        id delAppID;
        
        //unlock record on submittal
        forms__c[] formList = [select id, Approval_Step__c, Approver_1__c, App_Approval_Info_1__c from forms__c where id in :mainIds AND Approval_Step__c != 'Approved'];
        Map<id, forms__c> formMap = new Map<id, forms__c>(formList);
        Approval.UnlockResult[] formUnlocks = Approval.Unlock(formList, false);
        
        //gets approval process info for Form(s)
        List<ProcessInstance> processInstances = [SELECT Id, (SELECT Id, ActorID,TargetObjectId, isPending, StepStatus, ProcessNode.Name, Comments FROM StepsAndWorkitems) FROM ProcessInstance where TargetObjectId in :mainIds];
        //system.debug('pis: ' + processInstances);
        Map<id, List<id>> formIdToPeopleIds = new Map<id, List<id>>();
        for (ProcessInstance pi : processInstances){            
            for (ProcessInstanceHistory pih : pi.StepsAndWorkItems){
                if (!formIdToPeopleIds.containsKey(pih.TargetObjectID) ){
                    formIdToPeopleIds.put(pih.TargetObjectId, new List<Id>{pih.ActorId});
                 }
                else{
                    formIdToPeopleIds.get(pih.TargetObjectId).add(pih.ActorId);                        
                 }
            }
        }
        system.debug(formIdToPeopleIds);
        List<id> formIds = new List<Id>();
        List<id> personIDs = new List<id>();
        for (id formID : formIdToPeopleIds.keyset()){
            for (id personID: formIdToPeopleIds.get(formId)){
                formIDs.add(formID);
                personIds.add(personID);
                //get delegated approver
                try{
                delAppID = [select id, DelegatedApproverID from user where id = :personID limit 1].DelegatedApproverID;
                    }
                catch(exception e){system.debug(e);}
                    if(delAppID != null){
                    personIds.add(delAppID);
                    }
            }
        }
        
        //shares form(s) with approvers
        List<Forms__Share> formShares = new List<Forms__Share>();
        for (Integer i = 0; i < formIds.size();i++){
              formShares.add(new Forms__Share(ParentID = formIds[i], UserorGroupID = personids[i], AccessLevel = 'edit'));
          }
        database.insert(formShares, false);
        
        //shares line item(s) with approvers
        list<line_item__c> litems = new list<line_item__c>();
        list<line_item__Share> lineShares = new list<line_item__Share>();
        for (Integer b = 0; b < formIds.size();b++){
             try{litems = [select id from line_item__c where related_Form__c = :formIds[b]];}
             catch(exception e){system.debug('No related Line Items.');}
             if(litems.size()>0){
                 for(line_item__c litem : litems){
                 lineShares.add(new line_item__Share(ParentID = litem.id, userorGroupID = personids[b], AccessLevel = 'edit'));         
             }            
           }
         }   
        database.insert(lineShares, false);
        
        //Approver reassigned
        Recordtype rt;
        Boolean notifyReassign = false;
        Boolean updateReassign = false;
        string rtDescriptor;
        List<forms__c> forms = [select id, recordtypeid, name, Approval_Step__c, Form_Type_Name__c, Unauthenticated_Owner__c, Finalize_Approval_Reassignment__c, App_Approval_Info_1__c, Approver_1__c, App_Approval_Info_2__c, Approver_2__c, App_Approval_Info_3__c, Approver_3__c 
        FROM forms__c WHERE id in :mainIds];
        
        for(forms__c form : forms){    
        rt = [select id, description, DeveloperName from recordtype where id = :form.recordtypeid limit 1];
        try{rtDescriptor = [select descriptor__c from BAP_Form_Descriptor__mdt where label = :rt.developername limit 1].descriptor__c;}
        catch(Exception e) {system.debug('error: '+e);}
        
        if(rtDescriptor != null){
            notifyReassign = rtDescriptor.contains('Reassignment Notification');
            system.debug('notifyReassign: '+notifyReassign);
        
            updateReassign = rtDescriptor.contains('Reassignment Update');
            system.debug('updateReassign: '+updateReassign);
        }
   
        if(form.Finalize_Approval_Reassignment__c && form.Approval_Step__c != null){   
        //    ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
        //    FROM ProcessInstanceWorkItem
        //    WHERE ProcessInstance.Status = 'Pending' AND ProcessInstance.TargetObjectId = :form.ID limit 1];
        //    system.debug('Pitem: '+Pitem);
        if(notifyReassign || updateReassign){
         //List<ProcessInstance> PIs = [SELECT Id, (SELECT Id, ActorID, OriginalActorId, TargetObjectId, isPending, StepStatus, ProcessNode.Name, Comments FROM StepsAndWorkitems where stepstatus = 'Pending') FROM ProcessInstance where TargetObjectId = :form.ID];
         ProcessInstance PI = [SELECT Id, (SELECT Id, ActorID, OriginalActorId, TargetObjectId, isPending, StepStatus, ProcessNode.Name, Comments FROM StepsAndWorkitems where stepstatus = 'Pending') FROM ProcessInstance where TargetObjectId = :form.ID];
         system.debug('processInstance: '+PI);
         ProcessInstanceHistory pih = pi.StepsAndWorkItems[0];
         string app1Note;
         string stepName;
         id Actor;
         id origActor;
         string oldApproverName;
         string newApproverName;
         string timeNow;
         contact ct;
         string lanID;
         
         system.debug('ActorID: '+pih.ActorID);
         system.debug('OriginalActorId: '+pih.OriginalActorId);
         system.debug('isPending: '+pih.isPending);
         
         Actor = pih.ActorID;
         origActor = pih.OriginalActorId;
         
         if(Actor != origActor) { 
            Schema.SObjectType actorToken = pih.ActorID.getSObjectType();            
            string drActor = actorToken.getDescribe().getName();

            Schema.SObjectType oActorToken = pih.OriginalActorID.getSObjectType();            
            string drOActor = oActorToken.getDescribe().getName();
            
            system.debug('actor desc: '+drActor);
            system.debug('Orig actor desc: '+drOActor);
                 
            if(drActor == 'User'){
            user newApprover = [Select id, email, firstname, lastname From User Where ID = :pih.ActorID Limit 1];
            newApproverName = newApprover.FirstName+' '+newApprover.LastName;
            }
            else {
            group newApprover = [Select id, name from group where id = :pih.ActorID limit 1];
            newApproverName = newApprover.Name;
            }
            
            if(drOActor == 'User'){
            user oldApprover = [Select id, email, firstname, lastname From User Where ID = :pih.OriginalActorId Limit 1]; 
            oldApproverName = oldApprover.FirstName+' '+oldApprover.LastName;
            }
            else {
            group oldApprover = [Select id, name from group where id = :pih.OriginalActorId limit 1];
            oldApproverName = oldApprover.Name;
            }
            
            system.debug('oldApproverName: '+oldApproverName);
            system.debug('newApproverName: '+newApproverName);
            
            if(system.now().minute() < 10){
               timeNow = system.now().hour()+':0'+system.now().minute(); 
                }
             else {timeNow = system.now().hour()+':'+system.now().minute();} 
            
            // if Record Type description has "Reassignment Update" then update related Approver field on Form 
            if(updateReassign){
              system.debug('current StepStatus: '+pih.StepStatus);
              system.debug('approver 1 note: '+Form.App_Approval_Info_1__c);
              stepName = pih.ProcessNode.name;  
              system.debug('current step (stepName): '+stepName);
            
              if(Form.App_Approval_Info_1__c.contains(stepName) && string.valueof(actor).left(3)=='005'){
                  system.debug('approver 1 Note contains stepName');
                  form.approver_1__c = actor;
              }  // end if Form.App_Approval_Info_1__c.contains(stepName)
              
              if(Form.App_Approval_Info_2__c.contains(stepName)){
                  system.debug('approver 2 Note contains stepName');
                  form.approver_2__c = actor;
              }  // end if Form.App_Approval_Info_2__c.contains(stepName)
              
              if(Form.App_Approval_Info_3__c.contains(stepName)){
                  system.debug('approver 3 Note contains stepName');
                  form.approver_3__c = actor;
              }  // end if Form.App_Approval_Info_3__c.contains(stepName)
          
            } // end if updateReassign           
        
        // if Record Type description has "Reassignment Notification" then send notification email to originator            
       if(notifyReassign){
          lanID = [select lan_id__c from user where id = :form.Unauthenticated_Owner__c limit 1].lan_id__c;
          ct = [select id, email from contact where lan_id__c = :lanID limit 1];
    //      ProcessInstanceWorkItem Pitem = [SELECT ActorID, OriginalActorId 
    //      FROM ProcessInstanceWorkItem
    //      WHERE ProcessInstance.Status = 'Pending' AND ProcessInstance.TargetObjectId = :form.ID limit 1];
    //      system.debug('Pitem: '+Pitem);
          
            
                string[] toAddress = new String[] {ct.email};
                
                system.debug('sending reassigned approver notificaiton to: '+toAddress);
                Messaging.reserveSingleEmailCapacity(2);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();          
                mail.setSenderDisplayName('BAP Approval Notification');            
                ID templateId = [Select id from EmailTemplate where name = 'Notify Form Owner Approver Reassigned' limit 1].id;
                mail.setWhatId(form.id);
                mail.setTargetObjectId(ct.id);
                mail.setTemplateID(templateId);
                mail.setToAddresses(toAddress);
                mail.setSaveAsActivity(false);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
           
       }  // end if notifyReassign
        
        form.Finalize_Approval_Reassignment__c = false;
        form.Last_Approval_Reassignment__c = 'Reassigned from ' + oldApproverName + ' to ' +
             newApproverName +' on ' + 
             system.now().month()+'/'+system.now().day()+'/'+system.now().year() + ' at ' +
             timeNow;
            
        update form;        
    //        }}       
         }     // END if pih.ActorID != pih.OriginalActorId 
         
         else {
             form.Finalize_Approval_Reassignment__c = false;
             update form;
          }
      } // END if reassign update or notify    
        if(form.Finalize_Approval_Reassignment__c){
          form.Finalize_Approval_Reassignment__c = false;
          update form;
        }
      } // END if Finalize_Approval_Reassignment__c & Approval_Step__c != null
      }    //END forms__c loop
   }    //END createFormShares method
   
}