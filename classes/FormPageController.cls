/**********************************************************************
Name: FormPageController

======================================================
======================================================
Purpose:
-------
Server side controller for form lightning component 
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE    DETAIL                                        FEATURES/CSR/TTP
1.0     Mounika Suram 7/27/2018  Merged code with production                PCOR
1.0     Mounika Suram 7/31/2018  Updated the SubmitApprovaForOrderRequest   PCOR
1.0     Mounika Suram 9/07/2018  Merged with TCTO                           PCOR
1.0     Mounika Suram 12/14/2018 Updated the site info order                PCOR
1.2     Mounika Suram 2/28/2018  Updated findExistingOrders                 PCOR
1.3     Mounika Suram 3/15/2019  Updated findExistingForms                  BAP
1.4     Roy King      6/26/2019  Updated getFormRTs                         BAP
1.5     John Jenkins  6/27/2019  Added HR System Access Request to hardcoded list   OHR
1.5     John Jenkins  6/27/2019  Added OGE-450 to hardcoded list   OGE-450
***********************************************************************/
public without sharing class FormPageController  {
    @AuraEnabled
    public static List<RecordType> getFormRTs(string sID){
        //query for permissionsetassignments for this user
        User u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];

        // Added the following line to force the 3 character orgs to the top of the lookup (king.roy@pa.gov)
        List<Account> updateOrgTimestamps = [select name,id,lastvieweddate,lastreferenceddate from account where recordtype.name='HR Org' and (NOT name like '%Inactive%') and (NOT name like '%-%') for view];

        Set<id> psIds = new Set<id>();
        for (PermissionSetAssignment psa : [select id, PermissionSetId from PermissionSetAssignment where AssigneeId = :u.Id]){
            psIds.add(psa.PermissionSetID);
        }

        Set<string> formNames = new Set<String>();
        Type1RecordTypes__mdt frt= [Select Id,Recordtype_name__c from Type1RecordTypes__mdt where developerName='FormsRecordType' limit 1];
        for (PermissionSet ps : [select id, Label from PermissionSet where id in :psIDs]){

            formNames.add(ps.label.removeStart('BAPForms User - '));
            //hardcoding form RTs for all users
//            formNames.add('BAP User Provisioning');
//            formNames.add('EPA-100');
//            formNames.add('SF-182');
//            formNames.add('ORD-111');
//            formNames.add('EPA-3160-6v5');
//            formNames.add('FCO Appointment');
//            formNames.add('HR System Access Request');
//            formNames.add('OGE-450');
//            formNames.add('TCTO Request');
            for(String s:frt.Recordtype_name__c.split(',')){
                formNames.add(s);
            }
        }
        return [select id, Name, Description from RecordType where sObjectType = 'Forms__c' and IsActive = true and Name in :formNames];
    }

    @AuraEnabled
    public static List<Forms__c> findExistingForms(string sID){
        Forms__c existingForm;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];

           // Mounika Suram 3/15/2019 - Updated to correct the form conflation of similarly named users	            
           return [select id, Name, Form_Type_Name__c, Approval_Step__c, CreatedDate, LastModifiedDate, AWL_Phone_Number__c, User_Supervisor__c, Originator_Type1__c	
                    from Forms__c where Unauthenticated_Owner__c = :u.ID OR Originator_Type1_ID__c = :u.Id order by CreatedDate DESC];
            
           //return [select id, Name, Form_Type_Name__c, Approval_Step__c, CreatedDate, LastModifiedDate, AWL_Phone_Number__c, User_Supervisor__c, Originator_Type1__c from Forms__c where Unauthenticated_Owner__c = :u.ID OR Originator_Type1__c = :u.ID order by CreatedDate DESC];
        }
        catch (exception e){}

        return null;
    }

    @AuraEnabled
    public static Forms__c viewForm(string formID, string siteUserID) {
        UtilityMethods.addFormShare(formID, siteUserID);
        forms__c form = [select id, name, Approval_step__c, SF_182_Prepare_For_checker__c from Forms__c where id = :formID limit 1];
        return form;
    }

    @AuraEnabled
    public static Forms__c insertNewForms(string sID, string rtID, string siteUserID, string apiUserID){
        system.debug('Starting insertNewForms');
        string rtName = [select id, developerName from recordtype where id = :rtID limit 1].developerName;
        Forms__c existingForm;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];

            /*existingForm = [select id, Approval_step__c, AWL_Phone_Number__c, User_Supervisor__c from Forms__c where RecordTypeId = :rtID and Unauthenticated_Owner__c = :u.ID and Approval_Step__c != 'Approved' order by CreatedDate DESC limit 1];
            if (existingForm != null) return existingForm;*/
        }
        catch (exception ex){
        }
        try{
            //no existing form
            if (u != null){
                Forms__c nf = new Forms__c();
                nf.put('Unauthenticated_Owner__c', u.id);
                if(rtName != 'SF_182') nf.put('User_Supervisor__c', u.Supervisor__c);
                nf.put('RecordTypeId', rtID);
                nf.put('Quantity__c', 1);
                // LS 2017/11/19: Set Owner to "API" user
                nf.put('OwnerId', apiUserID);
                insert nf;
                // LS 2017/11/19: Add FormShare for force.com site user to new form record
                UtilityMethods.addFormShare(String.ValueOf(nf.Id), siteUserID);
                System.debug('newForms'+nf);
                return nf;
            }
        }
        catch(DMLException ex){
            AuraHandledException e = new AuraHandledException(ex.getMessage() + ' - ' + string.valueOf(ex.getLineNumber()));
            system.debug(ex.getMessage());
            throw e;
        }
        return null;
    }

    @AuraEnabled
    public static string deleteForm(ID formID, string sID){
       
        //4-26-2018 LSpack: added check to prevent deletion of any orphan Line Item records
        if(formID != null) {
            //find any related Line Items and delete
            list<line_item__c> litems = [select id from line_item__c where related_form__c = :formID];
            delete litems;
        }

        //delete form
        if(formID == null){
            return 'Form not Found';
        }
        else {
            delete [select id from Forms__c where ID = :formID];
            return 'Form Deleted';
        }
    }

    @AuraEnabled
    public static string saveForm(Forms__c sentForm, string sID){
        String message = 'Saved';
        try{
            upsert sentForm;
            return message;
        }
        catch(exception ex){
            message = ex.getMessage();
            return message;
        }
    }

    @AuraEnabled
    public static string submitForApproval(ID formID, string sID){
        String message = 'Not Submitted - Please check that all your approvers are set and try again';
        Boolean Yprob = false; // problem with e450 Filer stating yes they have reportable information, but did not provide line item(s)
        Boolean Nprob = false; // problem with e450 Filer stating no they don't have reportable information, but provided line item(s)
        Boolean Sprob = false; // e450 Filer did not 'sign' the form (using the "employee's signature" checkbox) before attempting to submit
        try{
            system.debug('In submitForApproval');
            system.debug(formId);
                       
            //Mounika Suram 9/17/2018 Added the validation to check the line items for the TCTO request
            String formName = getFormName(formID,sID);
            system.debug('formName'+formName);
            
            list<line_item__c> litems = [select id from line_item__c where related_form__c = :formID]; 
            System.debug('litems'+litems); 
            if(formName == 'TCTO Request' && litems.isEmpty()){
                 message = 'Not Submitted - Please check your line items.';
             } // end if TCTO Request
 
            
            //John Jenkins 5/24/2019 Added the validation to check the line items for the OGE-450 forms
            else if(formName == 'OGE-450'){                
              system.debug('formName = OGE-450');
                id RT1 = [select id, developerName from recordtype where developerName = 'OGE_450_Assets_Income_Line_Item' limit 1].id; 
                id RT2 = [select id, developerName from recordtype where developerName = 'OGE_450_Liabilities_Line_Item' limit 1].id;
                id RT3 = [select id, developerName from recordtype where developerName = 'OGE_450_Outside_Positions_Line_Item' limit 1].id;
                id RT4 = [select id, developerName from recordtype where developerName = 'OGE_450_Agreements_or_Arrangements_Line_Item' limit 1].id;
                id RT5 = [select id, developerName from recordtype where developerName = 'OGE_450_Part_5_Gifts_and_Travel_Reimbursements_Line_Item' limit 1].id;
                
                // clean out any empty line item records
                list<line_item__c> LI1s = [select Item_Description__c, No_Longer_Held__c from line_item__c where Related_Form__c = :formID AND recordtypeid = :RT1];
                    integer LIcount1 = LI1s.size();
                    if(LIcount1>=1){
                        for(line_item__c li1 : LI1s){
                            if(li1.Item_Description__c == null && li1.No_Longer_Held__c == false){delete li1; LIcount1=LIcount1-1;
                             }
                         }
                     }
                
                list<line_item__c> LI2s = [select Name_of_Creditor__c, Type_of_Liability__c from line_item__c where Related_Form__c = :formID AND recordtypeid = :RT2];
                    integer LIcount2 = LI2s.size();
                    if(LIcount2>=1){
                        for(line_item__c li2 : LI2s){
                            if(li2.Name_of_Creditor__c == null && li2.Type_of_Liability__c == null){delete li2; LIcount2=LIcount2-1;
                             }
                         }
                     }
                
                list<line_item__c> LI3s = [select Organization__c, Type_of_Organization__c, Position__c, No_Longer_Held__c from line_item__c where Related_Form__c = :formID AND recordtypeid = :RT3];
                    integer LIcount3 = LI3s.size();
                    if(LIcount3>=1){
                        for(line_item__c li3 : LI3s){
                            if(li3.Organization__c == null && li3.Type_of_Organization__c == null && li3.Position__c == null && li3.No_Longer_Held__c == false){delete li3; LIcount3=LIcount3-1;
                             }
                         }
                     }
                
                list<line_item__c> LI4s = [select Entity__c, Terms_of_Agreement_or_Arrangement__c from line_item__c where Related_Form__c = :formID AND recordtypeid = :RT4];
                    integer LIcount4 = LI4s.size();
                    if(LIcount4>=1){
                        for(line_item__c li4 : LI4s){
                            if(li4.Entity__c == null && li4.Terms_of_Agreement_or_Arrangement__c== null){delete li4; LIcount4=LIcount4-1;
                             }
                         }
                     }
                
                list<line_item__c> LI5s = [select Source__c, Description__c from line_item__c where Related_Form__c = :formID AND recordtypeid = :RT5];
                    integer LIcount5 = LI5s.size();
                    if(LIcount5>=1){
                        for(line_item__c li5 : LI5s){
                            if(li5.Source__c == null && li5.Description__c == null){delete li5; LIcount5=LIcount5-1;
                             }
                         }
                     }
                     
                //validate form responses vs line item records 
                //get Form info
                forms__c form = [select id, Reporting_Status__c, Employee_s_Signature__c, response_1__c, response_2__c, response_3__c, response_4__c, response_5__c from forms__c where ID = :formID limit 1];
                
              //check 'yes' responses
                string YmsgLIs = '';
                if(form.response_1__c == 'yes'){
                    if(LIcount1==0){Yprob=true; 
                        if(YmsgLIs==''){YmsgLIs=YmsgLIs+'Assets & Income';}
                        else {YmsgLIs=YmsgLIs+', Assets & Income';}
                        }
                 }
                if(form.response_2__c == 'yes'){  
                    if(LIcount2==0){Yprob=true; 
                        if(YmsgLIs==''){YmsgLIs=YmsgLIs+'Liabilities';}
                        else {YmsgLIs=YmsgLIs+', Liabilities';}
                        }
                 }
                if(form.response_3__c == 'yes'){  
                    if(LIcount3==0){Yprob=true; 
                        if(YmsgLIs==''){YmsgLIs=YmsgLIs+'Outside Positions';}
                        else {YmsgLIs=YmsgLIs+', Outside Positions';}
                        }
                 }
                if(form.response_4__c == 'yes'){  
                    if(LIcount4==0){Yprob=true;  
                        if(YmsgLIs==''){YmsgLIs=YmsgLIs+'Agreements or Arrangements';}
                        else {YmsgLIs=YmsgLIs+', Agreements or Arrangements';}
                        }
                 }
                if(form.Reporting_Status__c == 'Annual' && form.response_5__c == 'yes'){  
                    if(LIcount5==0){Yprob=true;   
                        if(YmsgLIs==''){YmsgLIs=YmsgLIs+'Gifts or Travel Reimbursements';}
                        else {YmsgLIs=YmsgLIs+', Gifts or Travel Reimbursements';}
                        }
                 }
                 if(Yprob){message = 'Not Submitted - You have indicated "Yes" to the following categories without submitting Reportable Information: '+YmsgLIs;}  
                
              //check 'no' responses
               string NmsgLIs = '';
               if(form.response_1__c == 'no'){
                    if(LIcount1>=1){Nprob=true;  
                        if(NmsgLIs==''){NmsgLIs=NmsgLIs+'Assets & Income';}
                        else {NmsgLIs=NmsgLIs+', Assets & Income';}
                        }
                  }
                 if(form.response_2__c == 'no'){
                    if(LIcount2>=1){Nprob=true;  
                        if(NmsgLIs==''){NmsgLIs=NmsgLIs+'Liabilities';}
                        else {NmsgLIs=NmsgLIs+', Liabilities';}
                        }
                  }
                 if(form.response_3__c == 'no'){  
                    if(LIcount3>=1){Nprob=true; 
                        if(NmsgLIs==''){NmsgLIs=NmsgLIs+'Outside Positions';}
                        else {NmsgLIs=NmsgLIs+', Outside Positions';}
                        }
                  }
                 if(form.response_4__c == 'no'){  
                    if(LIcount4>=1){Nprob=true;   
                        if(NmsgLIs==''){NmsgLIs=NmsgLIs+'Agreements or Arrangements';}
                        else {NmsgLIs=NmsgLIs+', Agreements or Arrangements';}
                        }
                  }
                 if(form.Reporting_Status__c == 'Annual' && form.response_5__c == 'no'){  
                    if(LIcount5>=1){Nprob=true;    
                        if(NmsgLIs==''){NmsgLIs=NmsgLIs+'Gifts or Travel Reimbursements';}
                        else {NmsgLIs=NmsgLIs+', Gifts or Travel Reimbursements';}
                        }
                  }
                  if(Nprob){
                      if(!Yprob){message = 'Not Submitted - You have indicated "No" to the following categories, but entered Reportable Information: '+NmsgLIs;}   
                      if(Yprob){message = message+' --- You also indicated "No" to the following categories, but entered Reportable Information: '+NmsgLIs;}
                   }
             
                 if(!Yprob && !Nprob && !form.Employee_s_Signature__c){
                     Sprob=true;
                     message = 'Not Submitted - You must complete the Acknowledgment section by reading the Acknowledgment statement and checking the Employee\'s Signature checkbox before submitting the form.';
                     }
                 else if(!form.Employee_s_Signature__c){
                     Sprob=true;
                     message = message+' --- Also, you must complete the Acknowledgment section by reading the Acknowledgment statement and checking the Employee\'s Signature checkbox before submitting the form.';
                     }
                 else if(!form.Employee_s_Signature__c){
                 }
             } //end else if OGE-450   
            
            if(!Yprob && !Nprob && !Sprob){
                if(formName == 'OGE-450'){
                    forms__c form = [select id,Applicant_Name_Last_First_MI2__c from forms__c where ID = :formID limit 1];
                    contact con = [select id,OGE_450_Form_Submitted_Date__c from contact where name = :form.Applicant_Name_Last_First_MI2__c limit 1];
                    con.OGE_450_Form_Submitted_Date__c = date.today(); 
                    update con;
                 }       
            
            //update OHR form if prepared for someone else
             if(formName == 'HR System Access Request'){
                 forms__c form = [select id, ownerid, Type_1_Owner_Contact__r.id, Form_Originally_Prepared_By__c, Type_1_Owner_Contact__c , Unauthenticated_Owner__c, prepare_Form_for__c from forms__c where ID = :formID limit 1];
                 if(form.prepare_Form_for__c != null){
                 contact c = [select id, LAN_ID__c from contact where id = :form.prepare_Form_for__c limit 1];
                 user u = [select id, LAN_ID__c from user where LAN_ID__c = :c.LAN_ID__c limit 1];                    
                 if (form.Unauthenticated_Owner__c == null){
                     form.ownerid = u.id;}                    
                 else {form.Unauthenticated_Owner__c = u.id;}
                 //update form original prepare field
                 form.Form_Originally_Prepared_By__c = form.Type_1_Owner_Contact__r.id;
                 //update Type 1 Owner Contact    
                 form.Type_1_Owner_Contact__c = c.id;
                 //remove value
                 form.Prepare_Form_for__c = null;
                 
                 update form;
                 }
             }
                 
          // submit for approval      
          Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
          req1.setComments('Automatically Submitted');
          req1.setObjectId(formId);
    
          Approval.ProcessResult result = Approval.process(req1);
          if (result.IsSuccess()) message = 'Submitted';
          }
          system.debug('message'+message);
          return message;
            
        }
        catch(exception ex){
            message = string.valueof(ex);
            return message;
        }
    }

    @AuraEnabled
    public static string recallApproval(ID formID, string sID){
        String message = 'Recall Failed';
        Boolean allowRecall = true;
        try{
            system.debug(formId);
            Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
            ProcessInstance x = [select id, status, ProcessDefinitionID from ProcessInstance where TargetObjectID=:formID AND status='pending' limit 1];
            ProcessInstanceWorkItem xItem = [select id from ProcessInstanceWorkItem where ProcessInstanceID=:x.id limit 1];
            ProcessDefinition Pdef = [select id, Description FROM ProcessDefinition Where ID=:x.ProcessDefinitionID limit 1];
            if(pdef.Description !=null){
                if(pdef.Description.indexOf('No Recall')>-1){
                    allowRecall = false;
                }
            }
            if(allowRecall){
                pwr.setWorkItemId(xItem.id);
                pwr.setAction('Removed');

                // Execute process request
                Approval.ProcessResult result = Approval.process(pwr);
                if (result.IsSuccess()){
                    message = 'Approval Request Recalled';
                    UtilityMethods.removeAllFormShares(formID);}
                return message;
            }
            else {message = 'Recall not allowed for this Form type.';
                return message;
            }
        }
        catch(exception ex){
            message = string.valueof(ex);
            return message;
        }
    }
    
    @AuraEnabled
    public static List<BAP_Fill_and_Print_List__mdt> getFandP_FormRTs(){
        return [select Label, Description__c, File_Url__c from BAP_Fill_and_Print_List__mdt ORDER BY Label ASC];
    }
    
    @AuraEnabled
    public static Id uploadFile(String FormID, String fileName, String base64Data, String contentType) {
        //   base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment a = new Attachment();
        a.parentId = FormID;
        a.Body = EncodingUtil.base64Decode(base64Data);
        a.Name = fileName;
        a.ContentType = contentType;
        insert a;
        System.debug(a.Id);
        return a.Id;
    }

    @AuraEnabled
    public static List<attachment> getListOfAttachments(String formID) {
        return [select id, Name, CreatedDate from Attachment where parentID = :formID order by CreatedDate DESC];
    }

    @AuraEnabled
    public static List<ContentVersion> getListOfFiles(String formID) {
        list<ContentDocumentLink> filez = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink where LinkedEntityId = :formID];
        List<ID> fileIDs = new List<ID>();
        for(ContentDocumentLink fil : filez){
            fileIDs.add(fil.ContentDocumentId);
        }
        List<ContentDocument> cdocs = [select id from ContentDocument where id in :fileIDs];
        List<ID> docIDs = new List<ID>();
        for(ContentDocument cd : cdocs){
            docIDs.add(cd.id);
        }

        return [Select Id, ContentDocumentId, Title, createddate, IsLatest FROM ContentVersion where ContentDocumentID in :docIDs AND IsLatest = true];
    }

    @AuraEnabled
    public static string deleteFormAttachment(ID attID){
       
        if(attID==null){
            return 'Attachment not found.';
        }
        else {
            delete [select id from Attachment where ID = :attID];
            return '-- Attachment Deleted';
        }
    }

    @AuraEnabled
    public static Forms__c cloneForm(String sID, ID FormID) {
       
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
        }
        catch (exception ex){system.debug('error: '+ex);
        }

        String soql = UtilityMethods.getCreatableFieldsSOQL('forms__c','id=\''+FormID+'\'');
        forms__c f = (forms__c)Database.query(soql);
        forms__c f2 = f.clone(false, true);
        f2.put('Unauthenticated_Owner__c', u.id);
        insert f2;

        //clone any related line items
        list<line_item__c> litems = [select id from line_item__c where related_form__c = :formID];
        for(line_item__c litem : litems){
            soql = UtilityMethods.getCreatableFieldsSOQL('line_item__c','id=\''+litem.id+'\'');
            line_item__c l = (line_item__c)Database.query(soql);
            line_item__c l2 = l.clone(false, true);
            l2.put('ownerid', u.id);
            l2.put('related_form__c', f2.id);
            insert l2;
        }

        return f2;
    }

    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert,
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
        } else {
            appendToFile(fileId, base64Data);
        }

        return Id.valueOf(fileId);
    }

    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;

        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;

        insert oAttachment;

        return oAttachment.Id;
    }

    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');

        Attachment a = [
                SELECT Id, Body
                FROM Attachment
                WHERE Id =: fileId
        ];

        String existingBody = EncodingUtil.base64Encode(a.Body);

        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);

        update a;
    }

    @AuraEnabled
    public static string getSiteUserID() {
        return UtilityMethods.getAnyUserID('EPA BAP Forms', 'Site Guest User');
    }

    @AuraEnabled
    public static string getAPIUserID() {
        return UtilityMethods.getAnyUserID('EPA Business Automation Platform', 'User');
    }

    @AuraEnabled
    public static void removeFormShare(string formID, string siteUserID) {
        UtilityMethods.removeFormShare(formID, siteUserID);
    }

    @AuraEnabled
    public static string isLineItemEnabled(string formName){
       
        string qName = 'Form - '+formName+' Line Item';
        string liRT = 'notEnabled';

        try{
            liRT = [select id, name from recordtype where sObjectType = 'Line_Item__c' and IsActive = true and Name = :qName limit 1].id;
            string formRTDesc = [select id, Description from recordtype where sObjectType = 'Forms__c' and name = :formName limit 1].Description;
            if (formRTDesc.contains('grid') || formRTDesc.contains('Grid')){liRT='grid';}
        }
        catch(exception e){system.debug('notEnabled');}

        return liRT;
    }

   
    @AuraEnabled
    public static string getLineItemLabel(string formName){
        string qName = 'Form - '+formName+' Line Item';
        string liLabel = 'noLabel';

        try{
            string formRTDesc = [select id, Description from recordtype where sObjectType = 'Forms__c' and name = :formName limit 1].Description;

            if (formRTDesc.contains('Testing')){formRTDesc = '(LI Label: test)';}
            if (formRTDesc.contains('LI Label')){
                liLabel=formRTDesc.right(formRTDesc.length()-formRTDesc.indexOf('LI Label: ',1));
                liLabel=liLabel.left(liLabel.indexOf(')'));
                liLabel=liLabel.right(liLabel.length()-10);
            }
        }
        catch(exception e){system.debug('noLabel');}

        return liLabel;
    }
    
    @AuraEnabled
    public static string getLineItemLink(string formName){
        string qName = 'Form - '+formName+' Line Item';
        string liLink = 'noLink';

        try{
            string formRTDesc = [select id, Description from recordtype where sObjectType = 'Forms__c' and name = :formName limit 1].Description;

            if (formRTDesc.contains('Testing')){formRTDesc = '(LI Link: \test)';}
            if (formRTDesc.contains('LI Link')){
                liLink=formRTDesc.right(formRTDesc.length()-formRTDesc.indexOf('LI Link: ',1))
                        .right(formRTDesc.right(formRTDesc.length()-formRTDesc.indexOf('LI Link: ',1)).length()-9)
                        .left(formRTDesc.right(formRTDesc.length()-formRTDesc.indexOf('LI Link: ',1))
                                .right(formRTDesc.right(formRTDesc.length()-formRTDesc.indexOf('LI Link: ',1)).length()-9).length()-1);
            }
        }
        catch(exception e){system.debug('noLink');}

        return liLink;
    }

    @AuraEnabled
    public static List<Line_Item__c> getListOfLineItems(String formID, String rtID) {
        if(rtID==null){
            return [select id, RecordTypeId, RecordType.Name from Line_Item__c where Related_Form__c = :formID order by CreatedDate DESC];
        }
        else{
            return [select id, RecordTypeId, RecordType.Name from Line_Item__c where Related_Form__c = :formID AND recordTypeId = :rtID order by CreatedDate DESC];
        }
    }

    @AuraEnabled
    public static List<string> getLineItemDisplayFields(String rtID) {
        
        // get map of Line Item fields
        String objType='Line_Item__c';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objType);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        string apiNames = [select description from recordtype where id = :rtID limit 1].description;
        list<string> apiList = apiNames.split(',');
        string fieldLabel;
        list<string> displayFields = new list<string>();
        for(string fieldApi : apiList){
            if(fieldAPI.trim()!='No Create' && fieldAPI.trim()!='For Testing'){
                fieldLabel = fieldMap.get(fieldApi.trim()).getDescribe().getLabel();
                displayFields.add(fieldLabel);}
            else if(fieldAPI.trim()=='No Create') {displayFields.add('No Create');}
            else {displayFields.add('ID');}
        }

        return displayFields;

    }

    @AuraEnabled
    public static List<string> getLineItemDataFields(String rtID) {
        string dataFields = [select description from recordtype where id = :rtID limit 1].description;
        return dataFields .split(',');
    }

    @AuraEnabled
    public static List<Line_Item__c> getLineItemData(String d1, string d2, string d3, string d4, string d5, String formID, String rtID) {

        string soql = 'select id, '+d1;
        if(d5!=null){soql = soql +', '+d2+', '+d3+', '+d4+', '+d5;}
        else if(d4!=null){soql = soql +', '+d2+', '+d3+', '+d4;}
        else if(d3!=null){soql = soql +', '+d2+', '+d3;}
        else if(d2!=null){soql = soql +', '+d2;}
        soql = soql + ' from Line_Item__c where Related_Form__c = :formID';
        List<Line_Item__c> interim = Database.query(soql);

        for(line_item__c litem : interim) {
            litem.display1__c = (string)string.valueof(litem.get(d1));
            if(d5!=null){
                litem.display2__c = (string)string.valueof(litem.get(d2));
                litem.display3__c = (string)string.valueof(litem.get(d3));
                litem.display4__c = (string)string.valueof(litem.get(d4));
                litem.display5__c = (string)string.valueof(litem.get(d5));
            }
            else if(d4!=null){
                litem.display2__c = (string)string.valueof(litem.get(d2));
                litem.display3__c = (string)string.valueof(litem.get(d3));
                litem.display4__c = (string)string.valueof(litem.get(d4));
            }
            else if(d3!=null){
                litem.display2__c = (string)string.valueof(litem.get(d2));
                litem.display3__c = (string)string.valueof(litem.get(d3));
            }
            else if(d2!=null){
                litem.display2__c = (string)string.valueof(litem.get(d2));
            }
            update litem;
        }
        
        if(rtID==null){
            List<Line_Item__c> displayData = [select id, display1__c, display2__c, display3__c, display4__c, display5__c from line_item__c where Related_Form__c = :formID];
            return displayData;
        }
        else{
            List<Line_Item__c> displayData = [select id, display1__c, display2__c, display3__c, display4__c, display5__c from line_item__c where Related_Form__c = :formID AND recordTypeId = :rtID];
            return displayData;
        }
    }

    @AuraEnabled
    public static Line_Item__c getLineItem(ID liID) {
        String soql = UtilityMethods.getCreatableFieldsSOQL('Line_Item__c','id=\''+liID+'\'');
        Line_Item__c l = (Line_Item__c )Database.query(soql);

        return l;
    }

    @AuraEnabled
    public static string deleteLineItem(ID liID, string sID){
       
        if(liID==null){
            return 'Line Item not Found';
        }
        else {
            delete [select id from Line_Item__c where ID = :liID];
            return 'Line Item Deleted - Form ';
        }
    }

    @AuraEnabled
    public static Line_Item__c insertLineItem(string sID, string formName, string formID, string siteUserID, string apiUserID, string liRT){
        system.debug('Starting insertLineItem');
        
        string formAPIname;
        string rtSearch;
        string rtID;
        
        if(liRT==null){
            formAPIname = [select id,developername from recordtype where name = :formName limit 1].developername;
            rtSearch = '%'+formAPIname+'%';
    
            rtID = [select id, developername, name, sObjectType from recordtype where sObjectType = 'Line_Item__c' and name like :rtSearch limit 1].id;
        }
        else{
            system.debug('liRT: '+liRT);
            rtID = liRT;
        }

        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
        }
        catch (exception ex){
        }

        try{
            if (u != null){
                Line_Item__c nli = new Line_Item__c();

                nli.put('RecordTypeId', rtID);
                nli.put('Related_Form__c', formID);
                nli.put('OwnerId', apiUserID);
                insert nli;
               
                UtilityMethods.addFormShare(String.ValueOf(formID), siteUserID);

                System.debug('newLineItems'+nli);
                return nli;
            }
        }
        catch(DMLException ex){
            AuraHandledException e = new AuraHandledException(ex.getMessage() + ' - ' + string.valueOf(ex.getLineNumber()));
            system.debug(ex.getMessage());
            if(!Test.isRunningTest()){
                throw e;
            }
        }
        return null;
    }

    @AuraEnabled
    public static string formSupportInfo(string formID, string formName){

        system.debug('formName received: '+formName);
        formName = formName.replaceAll('[\\s-]+','_');
        formName = 'Support_'+formName+'__c';
        system.debug('formName full: '+formName);
        string soql = 'select '+ formName;
        soql = soql + ' from Forms__c where id = :formID limit 1';
        list<forms__c> formsList = Database.query(soql);
        forms__c theForm = formsList[0];
        string supportInfo = (string)string.valueof(theForm.get(formName));
        return supportInfo;
    }

    
    @AuraEnabled
    public static string getFormName(string formID, string sID){

        string formName = 'unauthorized';

        forms__c theForm = [select id, Form_Type_Name__c, Unauthenticated_Owner__c   from forms__c where id = :formID limit 1];
        user u = [select id, Session_Token__c from user where Session_Token__c = :sID limit 1];
        if(u.id == theForm.Unauthenticated_Owner__c){formName = theForm.Form_Type_Name__c;}
        return formName;
    }



    /**
     * @author Mounika Suram
     * @date 7/17/2018
     * @purpose  Purchase order Type 1 interface. Gets the record types for the order request.
     *
     * @param sID
     *
     * @return List<RecordType>
     */
    @AuraEnabled
    public static List<RecordType> getOrderRecordTypes(string sID){
        //query for permissionsetassignments for this user
        User u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];

        Set<id> psIds = new Set<id>();
        for (PermissionSetAssignment psa : [select id, PermissionSetId from PermissionSetAssignment where AssigneeId = :u.Id]){
            psIds.add(psa.PermissionSetID);
        }

        Set<string> orderNames = new Set<String>();
        for (PermissionSet ps : [select id, Label from PermissionSet where id in :psIDs]){
            orderNames.add('Purchase_Card_Order_Request');
        }
        return [select id, Name, Description from RecordType where sObjectType = 'Order_Request__C' and IsActive = true and developerName in: orderNames];
    }

    /**
    * @author Mounika Suram
    * @date 7/18/2018
    * @purpose  Purchase order Type 1 interface. Checks the session and creates new order request with owner as apiuserID.
    *
    * @param sID
    * @param rtID
    * @param apiUserID
    * @param siteUserID
    *
    * @return Order_Request__c
    */
    @AuraEnabled
    public static Order_Request__c insertNewOrders(string sID, string rtID, string siteUserID, string apiUserID){
        system.debug('Starting insertNewOrders');
        string rtName = [select id, developerName from recordtype where id = :rtID limit 1].developerName;
        Order_Request__c existingOrder;
        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];

            if (u != null){
                Order_Request__c ord = new Order_Request__c();
                ord.put('RecordTypeId', rtID);
                ord.put('Unauthenticated_Owner__c', u.id);
                //Set Owner to "API" user
                ord.put('OwnerId', apiUserID);
                insert ord;
                UtilityMethods.addOrderShare(String.ValueOf(ord.Id), siteUserID);
                System.debug('newOrders'+ord);
                return ord;
            }
        }
        catch(DMLException ex){
            AuraHandledException e = new AuraHandledException(ex.getMessage() + ' - ' + string.valueOf(ex.getLineNumber()));
            system.debug(ex.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * @author Mounika Suram
     * @date 7/18/2018
     * @purpose  Purchase order Type 1 interface. Deletes the specified order from the database.
     *
     * @param orderID
     * @param sID
     *
     * @return string
     */
    @AuraEnabled
    public static string deleteOrder(ID orderID, string sID){

        system.debug('in delete Order');
        string message;
        try { //find any related Line Items
            list<line_item__c> litems = [select id from line_item__c where PCOR_Order_Request__c = :orderID];
            system.debug('Line Items:' + litems);
            Order_Request__c ord = [select id from Order_Request__C where ID = :orderID];
            delete litems;
            Database.DeleteResult dr = Database.delete(ord, false);

            if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted order with id:' + dr.getId());
                message = 'Order Deleted';
            } else {
                // Operation failed, so get all errors
                for (Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Order Request fields that affected this error: ' + err.getFields());
                    message = 'Order Didnt delete';
                }
            }
        }
        catch(DMLException ex){
            system.debug(ex.getMessage());

        }


        return message;
    }

    /**
     * @author Mounika Suram
     * @date 7/18/2018
     * @purpose  Purchase order Type 1 interface. Finds the existing orders for the current user.
     *
     * @param sID
     *
     * @return List<Order_Request__C>
     */
    @AuraEnabled
    public static List<Order_Request__C> findExistingOrders(string sID){
        Order_Request__C existingOrder;
        User u;
        Id pcorRtId = [select id from RecordType where developerName='Purchase_Card_Order_Request'].Id;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
            // Mounika 2/28/2019 - Added assigned to to query
            return [select id, Name, Request_Type__c, Assigned_to__c,Request_Status__c, CreatedDate, LastModifiedDate,Requester__c from Order_Request__C
                    where (Unauthenticated_Owner__c = :u.ID OR Requester__c = :u.name) AND recordTypeId=:pcorRtId order by CreatedDate DESC];

        }
        catch (exception e){
            return null;
        }


    }

    /**
     * @author Mounika Suram
     * @date 7/19/2018
     * @purpose  Purchase order Type 1 interface. Gets the line item record types for the order request.
     *
     * @return string
     */
    @AuraEnabled
    public static string getLineItemRTForOrders(){
        string liRT;
        try{
            liRT = [select id, name from recordtype where sObjectType = 'Line_Item__c' and IsActive = true and  developerName ='PCOR_Items' limit 1].id;
        }
        catch(exception e){}

        return liRT;
    }

    /**
     * @author Mounika Suram
     * @date 7/19/2018
     * @purpose  Purchase order Type 1 interface. Gets the line items for the specified order request.
     *
     * @param orderID
     *
     * @return List<Line_Item__c>
     */
    @AuraEnabled
    public static List<Line_Item__c> getListOfLineItemsForOrders(String orderID) {

        return [select id, RecordTypeId from Line_Item__c where PCOR_Order_Request__c = :orderID order by CreatedDate DESC];

    }

    /**
     * @author Mounika Suram
     * @date 7/20/2018
     * @purpose  Purchase order Type 1 interface. Gets the line item data to be displayed on the view for the specified order request.
     *
     * @param d1
     * @param d2
     * @param d3
     * @param d4
     * @param d5
     * @param orderID
     *
     * @return List<Line_Item__c>
     */
    @AuraEnabled
    public static List<Line_Item__c> getLineItemDataForOrders(String d1, string d2, string d3, string d4, string d5, String orderID) {

        string soql = 'select id, '+d1;
        soql = soql +', '+d2+', '+d3+', '+d4+', '+d5;
        
        soql = soql + ' from Line_Item__c where PCOR_Order_Request__c = :orderID';
        List<Line_Item__c> interim = Database.query(soql);

        for(line_item__c litem : interim) {
            litem.display1__c = (string)string.valueof(litem.get(d1));            
                litem.display2__c = (string)string.valueof(litem.get(d2));
                litem.display3__c = (string)string.valueof(litem.get(d3));
                litem.display4__c = (string)string.valueof(litem.get(d4));
                litem.display5__c = (string)string.valueof(litem.get(d5));           
            update litem;
        }

        List<Line_Item__c> displayData = [select id, display1__c, display2__c, display3__c, display4__c, display5__c from line_item__c where PCOR_Order_Request__c = :orderID];
        return displayData;
    }

    /**
     * @author Mounika Suram
     * @date 7/20/2018
     * @purpose  Purchase order Type 1 interface. Insert new line item for the specified order request.
     *
     * @param sID
     * @param orderID
     * @param siteUserID
     * @param apiUserID
     *
     * @return Line_Item__c
     */
    @AuraEnabled
    public static Line_Item__c insertLineItemForOrder(string sID, string orderID, string siteUserID, string apiUserID){
        system.debug('Starting insertLineItem');

        string rtID = [select id, developername, name, sObjectType from recordtype where sObjectType = 'Line_Item__c' and  developerName ='PCOR_Items'  limit 1].id;

        User u;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
        }
        catch (exception ex){
        }

        try{
            if (u != null){
                Line_Item__c nli = new Line_Item__c();

                nli.put('RecordTypeId', rtID);
                nli.put('PCOR_Order_Request__c', orderID);
                nli.put('OwnerId', apiUserID);
                insert nli;
                // Adding sharing setting to the line item
                List<Line_Item__Share> liShares = new List<Line_Item__Share>();

                liShares.add(new Line_Item__Share(ParentID = nli.Id, UserorGroupID = siteUserID, AccessLevel = 'edit'));
                database.insert(liShares, false);

                System.debug('newLineItems'+nli);
                return nli;
            }
        }
        catch(DMLException ex){
            AuraHandledException e = new AuraHandledException(ex.getMessage() + ' - ' + string.valueOf(ex.getLineNumber()));
            system.debug(ex.getMessage());
            throw e;
        }
        return null;
    }

    /**
     * @author Mounika Suram
     * @date 7/20/2018
     * @purpose  Purchase order Type 1 interface. Gets the Order request data to be displayed on the view .
     *
     * @param orderID
     * @param siteUserID
     *
     * @return Order_Request__c
     */
    @AuraEnabled
    public static Order_Request__c viewOrder(string orderID, string siteUserID) {

        UtilityMethods.addOrderShare(orderID, siteUserID);
        Order_Request__c order = [select id, Name, Request_Type__c, Request_Status__c, CreatedDate, LastModifiedDate,Requester__c from Order_Request__C  where id = :orderID limit 1];
        return order;
    }

    /**
     * @author Mounika Suram
     * @date 7/23/2018
     * @purpose  Purchase order Type 1 interface. Removes the sharing of the order request .
     *
     * @param orderID
     * @param siteUserID
     */
    @AuraEnabled
    public static void removeOrderShare(string orderID, string siteUserID) {
        UtilityMethods.removeOrderShare(orderID, siteUserID);
    }

    /**
     * @author Mounika Suram
     * @date 7/23/2018
     * @purpose  Purchase order Type 1 interface. Clones the specified order and creates new order .
     *
     * @param orderId
     *
     * @return Order_Request__c
     */
    @AuraEnabled
    public static Order_Request__c cloneOrder(string sID,ID orderId) {

        User u;
       
        Id  liRT = [select id, name from recordtype 
                    where sObjectType = 'Line_Item__c' and IsActive = true and  developerName ='PCOR_Items' limit 1].id;
        try{
            u = [select id, Name, Supervisor__c from User where Session_Token__c = :sID];
        }
        catch (exception ex){system.debug('error: '+ex);
        }
       
        String soql = FormPageController.getCreatableFieldsSOQLforOrderRequest('Order_Request__C','id=\''+orderId+'\'');
        Order_Request__c o = (Order_Request__c)Database.query(soql);
        system.debug('query'+soql);
        Order_Request__c o2 = o.clone(false, true);
        //o2.put('Unauthenticated_Owner__c',u.id);
        insert o2;
        
        list<line_item__c> litems = [select id from line_item__c where PCOR_Order_Request__c = :orderId AND System_Created__c=false];
         for(line_item__c litem : litems){
           soql = FormPageController.getCreatableFieldsSOQLforOrderRequest('line_item__c','id=\''+litem.id+'\'');
            line_item__c l = (line_item__c)Database.query(soql);
            line_item__c l2 = l.clone(false, true);
            //l2.put('ownerid', u.id);
            l2.put('PCOR_Order_Request__c', o2.id);
            l2.put('RecordTypeId',liRT);
            insert l2;
        }
        return o2;
    }

    /**
     * @author Mounika Suram
     * @date 7/23/2018
     * @purpose  Purchase order Type 1 interface. Gets the list of attachments for the specified order request .
     *
     * @param orderID
     *
     * @return List<attachment>
     */
    @AuraEnabled
    public static List<attachment> getListOfAttachmentsForOrders(String orderID) {
        return [select id, Name, CreatedDate from Attachment where parentID = :orderID order by CreatedDate DESC];
    }

    /**
     * @author Mounika Suram
     * @date 7/124/2018
     * @purpose  Purchase order Type 1 interface. Gets the list of files for the specified order request .
     *
     * @param orderID
     *
     * @return List<ContentVersion>
     */
    @AuraEnabled
    public static List<ContentVersion> getListOfFilesForOrders(String orderID) {
        list<ContentDocumentLink> filez = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink where LinkedEntityId = :orderID];
        List<ID> fileIDs = new List<ID>();
        for(ContentDocumentLink fil : filez){
            fileIDs.add(fil.ContentDocumentId);
        }
        List<ContentDocument> cdocs = [select id from ContentDocument where id in :fileIDs];
        List<ID> docIDs = new List<ID>();
        for(ContentDocument cd : cdocs){
            docIDs.add(cd.id);
        }

        return [Select Id, ContentDocumentId, Title, createddate, IsLatest FROM ContentVersion where ContentDocumentID in :docIDs AND IsLatest = true];
    }

    /**
     * @author Mounika Suram
     * @date 7/24/2018
     * @purpose  Purchase order Type 1 interface. Submits the order request for the approval .
     *
     * @param orderID
     * @param sID
     *
     * @return string
     */
    @AuraEnabled
    public static string submitForApprovalForOrder(ID orderID, string sID){
        String message = 'Not Submitted - Please add items for the purchase order request and try again';
        try{
            List<Line_Item__c> items = new List<Line_Item__c>();
            items=[select id from Line_Item__c where PCOR_Order_Request__c= :orderID AND System_Created__c=false];//added a flag to check for auto Create Line Items Processbuilder
            if(!items.isEmpty()) {
                system.debug(orderID);
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('Automatically Submitted from Type1 interface');
                req1.setObjectId(orderID);
                Approval.ProcessResult result = Approval.process(req1);
                if (result.IsSuccess()) message = 'Submitted For Approval';
                return message;
            }
            else
                  return message;
        }
        catch(exception ex){
            message = string.valueof(ex); system.debug('submit error: '+ex);
            return message;
        }
    }

    /**
     * @author Mounika Suram
     * @date 7/25/2018
     * @purpose  Purchase order Type 1 interface. Recalls the approval of the submitted order request .
     *
     * @param orderID
     * @param sID
     *
     * @return String
     */
    @AuraEnabled
    public static String recallApprovalForOrder(String orderID, string sID){
        String message = 'Recall Failed';
        try{
            system.debug(orderID);
            Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();
            ProcessInstance x = [select id, status from ProcessInstance where TargetObjectID=:orderID AND status='pending' limit 1];
            ProcessInstanceWorkItem xItem = [select id from ProcessInstanceWorkItem where ProcessInstanceID=:x.id limit 1];

            pwr.setWorkItemId(xItem.id);
            pwr.setComments('Recalled from Type1 interface');
            pwr.setAction('Removed');

            // Execute process request
            Approval.ProcessResult result = Approval.process(pwr);
            if (result.IsSuccess()) {
                message = 'Approval Request Recalled';
            }
            return message;
        }
        catch(exception ex){
            message = string.valueof(ex); system.debug('recall error: '+ex);
            return message;
        }
    }
     /**
     * @author Mounika Suram
     * @date 12/14/2018
     * @purpose  Purchase order Type 1 interface. Gets the support info for the order request.
     *
     * @param orderID
     * @param sID
     *
     * @return String
     */
    @AuraEnabled
    public static string orderSupportInfo(string orderID){

        String orderSupport;
        orderSupport = [select id , Support_Purchase_Order_Request__c from order_request__c where id = :orderID].Support_Purchase_Order_Request__c;
        
        return orderSupport;
    }
    
    /**
     * @author Mounika Suram
     * @date 3/7/2019
     * @purpose  Purchase order Type 1 interface.Returns the query string with all the fields.
     *
     * @param objectName
     * @param whereClause
     *
     * @return String
     */
    public static string getCreatableFieldsSOQLforOrderRequest(String objectName, String whereClause){

        String selects = '';

        if (whereClause == null || whereClause == ''){ return null; }

        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();

        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ 
                Schema.DescribeFieldResult fd = ft.getDescribe(); 
               
                if (fd.isCreateable() && (fd.getName()!='Assigned_to__c' && fd.getName()!='Request_Completed__c'  
                                          && fd.getName()!='Date_Allocated__c' &&fd.getName()!='Date_Ordered__c' && fd.getName()!='Date_Received__c' ))
                {
                    selectFields.add(fd.getName());
                }
            }
        }

        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}

        }

        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;

    }
    
}