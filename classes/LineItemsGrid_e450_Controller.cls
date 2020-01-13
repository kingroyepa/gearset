/* Author:          Trellis Sherman
 * Email:           trellis.sherman@csra.com
 * 
 *Updated:          John Jenkins -- added/edited code for OGE-450 LineItems
 *
 * Test Class:      LineItemsGrid_e450_Controller_Test
 * 
 * Description:     An Apex class that will dynamically generate a table for Line Items
 * 
 * 
 * How To Use:      1. In the fetchTableData() method, add an if statement, before the common methods comment, that will set an index number. Only use an index number that is not in used
 *                  2. In the queryDBForFields(ID) method, add an if statement that checks to see if the index matches the index from step one. If it does, return a list of fields you want to query
                    3. In the setFields() method, add an if statement that checks to see if the index matches the index from step one. If it does, return a list of fields you want to use as table headers.
                    4. In the setApiName() method, add an if statement that checks to see if the index matches the index from step one. If it does, return a list of API Name fields you want to display in the table
                    5. In the setNewLineItemRecordType() method, add an if statement that checks to see if the index matches the index from step one. If it does, return a the RecordType ID you want to use to create new Line Item reocrd
 */
public without sharing class LineItemsGrid_e450_Controller {
    
    //These variables interact with the Visualforce page
    public Boolean readOnlyFlag{get;set;} //used to decided rather to generate outputFields or inputFields
    public List<Line_Item__c> lineItemCollection{get;set;} // collection of Line Item record related to a form
    public List<String> fieldHeader{get;set;} //collection of string that will be used as column headers
    public List<String> apiList{get;set;} //collection of string that will be used to display a field from the Line Item object
    public Forms__c form {get;set;} //a variable that stores the form data that called this class
    public ID lineToDelete {get;set;}// a variable that holds the id of a Line Item record that should be deleted
    public String lineItemIdentifier {get;set;} //a variable that appears in a string in the title
    //Mounika Suram 8/14/2018 Added to capture the timezone of the user
    public TimeZone timeZone {get;set;}
    public Boolean msgOff = false;  //a variable to turn off toast messages
    public String lineItemRT{get;set;} //a variable for user to choose line item record type
    public List<Line_Item__c> lineItemSummary {get;set;}
    public Boolean isEdit{get;set;} //used for flagging edit of line item by approver
    
    private Integer index; //a variable to hold the index number of which data to use
    public ID newLineItemRT; //a variable to hold recordTypeID for new Line Item records
    public ID formId {get;set;}  //a variable to hold the id of the form that called this class
    private String sessionId; //a variable to hold the sessionid
    private ID userID;  //a variable to hold the userId
    private boolean validSession;   //a boolean variable to decided if a user session is valid
    public String licName {get;set;} // a variable to hold the license of the current user -- used to identify type-1/type-3 users
    public Boolean t1User {get;set;} // a boolean variable to identify if user is type-1 or type-3
        
    //Default constructor that initalize the variables in this class.
    //This method also determines if the user session is valid
    public LineItemsGrid_e450_Controller()
    {
        ID userID = UserInfo.getUserID();
        licName = UtilityMethods.getLicName(userID);
        system.debug('licName: '+licName);
        if(licName != 'Guest User License'){t1User=false;}
        else{t1User=true;}
        system.debug('t1User: '+t1User);
        if(t1User){
            validSession = false;
            // Get session ID from URL parameters, get user ID from the matching session
            sessionId = UtilityMethods.getSessionID();
            userID = UtilityMethods.getUserID(sessionId);
            
            // Validate Session, temporarily disabled until more user data from proxy 
            validSession = UtilityMethods.validateSession(sessionId, userID);
            system.debug('t1 user validSession: '+validSession);
            isEdit=false;
          }
        else {userID = UserInfo.getUserId(); validSession = true; system.debug('t3 user validSession: '+validSession); isEdit=true;} // type-3 user
        
        lineItemCollection = new List<Line_Item__c>();
        fieldHeader = new List<String>();
        apiList = new List<String>();
        form = new Forms__c();
        readOnlyFlag = false;
        if(isEdit){readOnlyFlag=true;}
        index = -1;
        
        lineItemIdentifier = null;
        
        //Get formID from URL parameter
        formId = ApexPages.currentPage().getParameters().get('formId');
        if(formId==null){ // type-3 user will not have formId in url params
            formId = ApexPages.currentPage().getParameters().get('Id');
        }
        system.debug('formID: '+formId);
        lineitemsummary = getLineItemSummary(formId);

        //get the timezone of the user
        timeZone=UserInfo.getTimeZone();
        
        // Validate Session, temporarily disabled until more user data from proxy 
  /*      try{
        validSession = UtilityMethods.validateSession(sessionId, userId);
        }
        catch(Exception e)
        {
            validSession = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
    */    
    }
    
    //A method that is called if the user session is valid
    //If valid the form and the form recordtype is stored into variables.
    //Based on a conditional statement, set the index and populate other variables needed to generate the table
    public void fetchTableData()
    {
    system.debug('in fetchTableData');
    
        //The form record that launch the visualforce page from the form.cmp
        form = [SELECT id, name,TCTO_Request_Type__c,Approval_Step__c, RecordTypeId,Unauthenticated_Owner__c FROM Forms__c WHERE id =: formId LIMIT 1];
        system.debug('form name: '+form.name);
        //The recordType of the form
        Recordtype recType = [SELECT id, name FROM RecordType WHERE id =: form.RecordTypeId LIMIT 1]; 
        
        //Variable that are used to check rather to make the table read only or editable
        String tctoRequestType = form.TCTO_Request_Type__c;
        String formApprovalStep = form.Approval_Step__c;
        
        //Variables that are used for non-TCTO forms
        String lineItemType = ApexPages.currentPage().getParameters().get('liType');
        //default
            if(lineItemType == '' || lineItemType == null){lineItemType = 'assets_income';}
            
        if(formApprovalStep == null) //have to check or else null.contains doesnt work right
        {
            formApprovalStep = 'null';
        }
        
        if(recType.Name == 'OGE-450'){
            if(lineItemType == 'assets_income'){
                index = 2;
            }
            if(lineItemType == 'liabilities'){
                index = 3;
            }
            if(lineItemType == 'outside_positions'){
                index = 4;
            }
            if(lineItemType == 'agreement_arrangement'){
                index = 5;
            }
            if(lineItemType == 'gifts_travel'){
                index = 6;
            }
            
        } 
            
        //Common Method calls
        newLineItemRT = setNewLineItemRecordType();
        lineItemCollection = queryDBForFields(form.id);
        //fieldHeader = setFields();  //not using this method in order to manually set formatting of table headers
        apiList = setApiName();
         
        //If there are no Line Items related to form, create blank line
        system.debug('lineItemCollection: '+lineItemCollection);
        if(lineItemCollection==null || lineItemCollection.isEmpty()){
            msgOff = true;
            addRow();
        }

        //If the form record is approved or in the approval process, set the flag to true
        if(form.Approval_Step__c != '' && form.Approval_Step__c != null && !form.Approval_Step__c.containsIgnoreCase('recalled') && !form.Approval_Step__c.containsIgnoreCase('rejected'))
        {
            if(isEdit){readOnlyFlag = false;}
            else {readOnlyFlag = true;}
        }
    }
    
    //An method that is called when the visualforce page is generated.
    //Used to determine if a user session is valid.
    //If the user session is valid, call fetchTableData() to fetch data for the table
    //If the user session is not valid, then redirect the user to a blank page
    public pageReference ValidateOrRedirect()
    {
    system.debug('in ValidateOrRedirect');
        if (!validSession) 
        {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else 
        { 
            //Try to populate variables for the table
            //If an error is found, then display the error
            try{
            fetchTableData();
            }catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There was an error retrieving the Form!'));
            }
            return null; 
        } 
    }
    
    //An method to add a new Line Item row that is related to the form that called this page.
    //The recordtype for the new Line Item record is based on the index and the id that is store in the setNewLineItemRecordType() method
    public pageReference addRow()
    {
        update lineItemCollection;
        system.debug('newLineItemRT: '+newLineItemRT);
        Line_Item__c newLineItem = new Line_Item__c(Related_Form__c=form.Id,RecordTypeId=newLineItemRT);
        try{
            insert newLineItem;
            if(!msgOff){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'A Line Item was successfully created!'));
            }
        }catch(Exception e)
        {
            system.debug('error: '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        lineItemCollection = queryDBForFields(form.id);
        msgOff = false; //reset messaging boolean
        return null;
    }
    
    //A method to delete a Line Item record
    public pageReference deleteRow()
    {
        Line_Item__c itemToDel = new Line_Item__c(id=lineToDelete);
        try{
            delete itemToDel;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Line Item was successfully deleted!'));
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        lineItemCollection = queryDBForFields(form.id);
        return null;
        //return new pageReference('?sid='+sessionId+'&formID='+formId);
    }
    
    //A method that will update the Line Item table
    //This will display a message if the table was able to save or if there's an error
    public pageReference saveTable()
    {
        try{
            update lineItemCollection;
            lineItemCollection = queryDBForFields(form.id);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Line Item Table was saved successfully!'));
        }catch(Exception e)     
        
        {  
            system.debug('error: '+e);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));        
        }
        return null;
        
    }
    
    //A method that will update the Line Item table and return to the form site
    public pageReference saveAndReturn()
    {
        try{
            update lineItemCollection;
            lineItemCollection = queryDBForFields(form.id);
           // pageReference page = new pageReference('/FormPage?sID='+sessionId);
            pageReference page = new pageReference('/FormPage?sID='+sessionId+'&formID='+formId);
            page.setRedirect(true);
            return page;
        }catch(Exception e)
        {  
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
        return null;
        //
    }
    
    //A method to store a collection of Line Item records, based on an index
    ////Information retrieved is based on index and list provided by dev
    public List<Line_Item__c> queryDBForFields(ID relatedFormId)
    {
        
        if(index == 2) //Index 2 => e450 Assets and Income
        {
            return [SELECT id, Item_Description__c, No_Longer_Held__c, Approver_Comment__c, Filer_s_Response__c FROM Line_Item__c where Related_Form__c =:relatedFormId AND recordtypeid = :newLineItemRT];
        }
        else if(index == 3) //Index 3 => e450 Liabilities
        {
            return [SELECT id, Name_of_Creditor__c, Type_of_Liability__c, Approver_Comment__c, Filer_s_Response__c FROM Line_Item__c where Related_Form__c =:relatedFormId AND recordtypeid = :newLineItemRT];
        }
        else if(index == 4) //Index 4 => e450 Outside Organizations
        {
            return [SELECT id, Organization__c, Type_of_Organization__c, Position__c, No_Longer_Held__c, Approver_Comment__c, Filer_s_Response__c FROM Line_Item__c where Related_Form__c =:relatedFormId AND recordtypeid = :newLineItemRT];
        }
        else if(index == 5) //Index 5 => e450 Agreements or Arrangements
        {
            return [SELECT id, Entity__c, Terms_of_Agreement_or_Arrangement__c, Approver_Comment__c, Filer_s_Response__c FROM Line_Item__c where Related_Form__c =:relatedFormId AND recordtypeid = :newLineItemRT];
        }
        else if(index == 6) //Index 6 => e450 Gifts and Travel Reimbursements
        {
            return [SELECT id, Source__c, Description__c, Approver_Comment__c, Filer_s_Response__c FROM Line_Item__c where Related_Form__c =:relatedFormId AND recordtypeid = :newLineItemRT];
        }
        else
        {
            return null;
        }
    }
    
    //A method to return a list of String that will be used as table headers
    //Information retrieved is based on index and list provided by dev
    
    //Not Using this method for OGE-450 in order to control formatting of table headers
    /*
    public List<String> setFields()
    {
        
        if(index == 0 || index == 1) //Index 0 => TCTO Proposed Hours
        {
            lineItemIdentifier = form.TCTO_Request_Type__c +' - ';
            //Mounika Suram 9/17/2018 Added the blank value for the delete action in the data table
            return (new List<String>{'','TCTO Type', 'Date', 'Day', 
                                    'Travel Comp Applicable', 'Ignore Workday Hours', 
                                    'Normal Workday Start Time', 'Normal Workday End Time*', 'Travel Start Time*', 
                                    'Travel End Time*', 'Offset', 'Travel Comp', 'Note'});
        }
        
        else if(index == 2) //Index 2 => e450 Assets and Income
        {
            lineItemIdentifier = 'Part 1: Assets and Income - ';
            //Mounika Suram 9/17/2018 Added the blank value for the delete action in the data table
            return (new List<String>{'','Type', 'Specific stock, bond, sector mutual fund, type/location of real estate, etc. '+
            '(Indicate the full name of each specific asset or investment. You may add the ticker symbol to the full name.) \n\n'+
            'Name of Employer or Business; Source of Fees, Commissions, or Honoraria (Include brief description.) \n'+
            'You may distinguish any entry for a family member by preceding it with S for spouse, DC for dependent child, or J for jointly held.', 'No Longer Held'});
        }
        
        else if(index == 3) //Index 3 => e450 Liabilities
        {
            lineItemIdentifier = 'Part 2: Liabilities - ';
            //Mounika Suram 9/17/2018 Added the blank value for the delete action in the data table
            return (new List<String>{'','Type', 'Name of Creditor', 'Type of Liability'});
        }
        
        else if(index == 4) //Index 4 => e450 Outside Organizations
        {
            lineItemIdentifier = 'Part 3: Outside Organizations - ';
            //Mounika Suram 9/17/2018 Added the blank value for the delete action in the data table
            return (new List<String>{'','Type', 'Organization', 'Type of Organization', 'Position', 'No Longer Held'});
        }
        
        else if(index == 5) //Index 5 => e450 Agreements or Arrangements
        {
            lineItemIdentifier = 'Part 4: Agreements or Arrangements - ';
            //Mounika Suram 9/17/2018 Added the blank value for the delete action in the data table
            return (new List<String>{'','Type', 'Entity', 'Type of Organization', 'Terms of Agreement or Arrangement'});
        }
        
        else if(index == 6) //Index 6 => e450 Gifts and Travel Reimbursements
        {
            lineItemIdentifier = 'Part 5: Gifts and Travel Reimbursements - ';
            //Mounika Suram 9/17/2018 Added the blank value for the delete action in the data table
            return (new List<String>{'','Type', 'Source', 'Description'});
        }
        
        else
        {
            return null;
        }
    }
    */
    
    //**NOTE: EACH STRING POSITION IN THIS METHOD MUST MATCH THE STRING POSITION OF setFields()
    //A method to return a list of String that will be used as to bind the line item fields to the visualforce page
    //Information retrieved is based on index and list provided by dev
    public List<String> setApiName()
    {
        
        if(index == 2) //Index 2 => e450 Assets and Income
        {
            //return (new List<String>{'Hidden_RecordType_Name__c', 'Item_Description__c', 'No_Longer_Held__c', 'Approver_Comment__c', 'Filer_s_Response__c'});
            return (new List<String>{'Item_Description__c', 'No_Longer_Held__c', 'Approver_Comment__c', 'Filer_s_Response__c'});
        }
        else if(index == 3) //Index 3 => e450 Liabilities
        {
            return (new List<String>{'Name_of_Creditor__c', 'Type_of_Liability__c', 'Approver_Comment__c', 'Filer_s_Response__c'});
        }
        else if(index == 4) //Index 4 => e450 Outside Organizations
        {
            return (new List<String>{'Organization__c', 'Type_of_Organization__c', 'Position__c', 'No_Longer_Held__c', 'Approver_Comment__c', 'Filer_s_Response__c'});
        }
        else if(index == 5) //Index 5 => e450 Agreements or Arrangements
        {
            return (new List<String>{'Entity__c', 'Terms_of_Agreement_or_Arrangement__c', 'Approver_Comment__c', 'Filer_s_Response__c'});
        }
        else if(index == 6) //Index 6 => e450 Gifts and Travel Reimbursements
        {
            return (new List<String>{'Source__c', 'Description__c', 'Approver_Comment__c', 'Filer_s_Response__c'});
        }
        else
        {
            return null;
        }
    }
    
    //A method to return the recordtype Id that will be used to create new line item records
    //How to use: Copy Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('').getRecordTypeId()), set a condition with an index, inside '' of .get('') enter the RECORD TYPE LABEL NAME, NOT THE DEVELOPER NAME
    public ID setNewLineItemRecordType()
    {
        if(index == 2) //Index 2 => e450 Assets and Income
        {
            return (Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('OGE-450 Part 1 Assets and Income Line Item').getRecordTypeId());
        }
        else if(index == 3) //Index 3 => e450 Liabilities
        {
            return (Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('OGE-450 Part 2 Liabilities Line Item').getRecordTypeId());
        }
        else if(index == 4) //Index 4 => e450 Outside Organizations
        {
            return (Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('OGE-450 Part 3 Outside Positions Line Item').getRecordTypeId());
        }
        else if(index == 5) //Index 5 => e450 Agreements or Arrangements
        {
            return (Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('OGE-450 Part 4 Agreements or Arrangements Line Item').getRecordTypeId());
        }
        else if(index == 6) //Index 6 => e450 Gifts and Travel Reimbursements
        {
            return (Schema.SObjectType.Line_Item__c.getRecordTypeInfosByName().get('OGE-450 Part 5 Gifts and Travel Reimbursements Line Item').getRecordTypeId());
        }
        else
        {
            return null;
        }
    }
    
    public List<SelectOption> getLineItemRTs() {
        List<SelectOption> lineItemRTOptions = new List<SelectOption>();
        
        //set default based on current Line Item Record Type
        if(index == 2){lineItemRT = 'assets_income';}
        else if(index == 3){lineItemRT = 'liabilities';}
        else if(index == 4){lineItemRT = 'outside_positions';}
        else if(index == 5){lineItemRT = 'agreement_arrangement';}
        else if(index == 6){lineItemRT = 'gifts_travel';}
        else if(index == 7){lineItemRT = 'summary';}
        
        lineItemRTOptions.add(new SelectOption('assets_income','Part 1: Assets and Income'));
        lineItemRTOptions.add(new SelectOption('liabilities','Part 2: Liabilities'));
        lineItemRTOptions.add(new SelectOption('outside_positions','Part 3: Outside Positions'));
        lineItemRTOptions.add(new SelectOption('agreement_arrangement','Part 4: Agreements or Arrangements'));
        lineItemRTOptions.add(new SelectOption('gifts_travel','Part 5: Gifts and Travel Reimbursements'));
        lineItemRTOptions.add(new SelectOption('summary','View All'));

        return lineItemRTOptions;
    }
    
    public PageReference go(){    
        update lineItemCollection; //saves current line items on page
        pageReference page;
        
        if(t1user){
            page = new pageReference('/LineItemsGrid_e450_'+lineItemRT+'?sID='+sessionId+'&formID='+formId+'&liType='+lineItemRT);
         }
        else { // type-3 user
            page = new pageReference('/apex/LineItemsGrid_e450_'+lineItemRT+'?formID='+formId+'&liType='+lineItemRT);
         } 
        page.setRedirect(true);
        return page;
    }
   
    public List<line_item__c> getLineItemSummary(ID relatedFormId) {
        
        id rt1 = [SELECT id, name FROM RecordType WHERE name = 'OGE-450 Part 5 Gifts and Travel Reimbursements Line Item' LIMIT 1].id;
        
        lineItemSummary = [select Item_Description__c, No_Longer_Held__c, Approver_Comment__c, Filer_s_Response__c from line_item__c where Related_Form__c = :relatedFormId AND recordtypeid = :rt1];
        return lineItemSummary;
   }     
   
}