/* Author:          John Jenkins
 * Email:           jjenkins@innovateteam.com
 * 
 *
 * Test Class:      LineItemsGrid_e450_Summary_Test
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
public without sharing class LineItemsGrid_e450_Summary_Controller {
    
    //These variables interact with the Visualforce page
    public Boolean readOnlyFlag{get;set;} //used to decided rather to generate outputFields or inputFields
    public List<Line_Item__c> lineItemCollection{get;set;} // collection of Line Item record related to a form
    public List<String> fieldHeader{get;set;} //collection of string that will be used as column headers
    public List<String> apiList{get;set;} //collection of string that will be used to display a field from the Line Item object
    public Forms__c form{get;set;} //a variable that stores the form data that called this class
    public ID lineToDelete{get;set;}// a variable that holds the id of a Line Item record that should be deleted
    public String lineItemIdentifier{get;set;} //a variable that appears in a string in the title
    //Mounika Suram 8/14/2018 Added to capture the timezone of the user
    public TimeZone timeZone{get;set;}
    public Boolean msgOff = false;  //a variable to turn off toast messages
    public String lineItemRT{get;set;} //a variable for user to choose line item record type
    public String lineEditComment{get;set;} //a variable for sending user to correct comment/response page
    public List<Line_Item__c> lineItemSummary1{get;set;} // collection of Line Item record related to a form
    public List<Line_Item__c> lineItemSummary2{get;set;} // collection of Line Item record related to a form
    public List<Line_Item__c> lineItemSummary3{get;set;} // collection of Line Item record related to a form
    public List<Line_Item__c> lineItemSummary4{get;set;} // collection of Line Item record related to a form
    public List<Line_Item__c> lineItemSummary5{get;set;} // collection of Line Item record related to a form
    
    private Integer index; //a variable to hold the index number of which data to use
    private ID newLineItemRT; //a variable to hold recordTypeID for new Line Item records
    public ID formId{get;set;}  //a variable to hold the id of the form that called this class
    private String sessionId; //a variable to hold the sessionid
    private ID userID;  //a variable to hold the userId
    private boolean validSession;   //a boolean variable to decided if a user session is valid
    public String licName {get;set;} // a variable to hold the license of the current user -- used to identify type-1/type-3 users
    public Boolean t1User {get;set;} // a boolean variable to identify if user is type-1 or type-3
    public Boolean t3First {get;set;}
    public string curURL {get;set;}
        
    //Default constructor that initalize the variables in this class.
    //This method also determines if the user session is valid
    public LineItemsGrid_e450_Summary_Controller()
    {
        ID userID = UserInfo.getUserID();
        licName = UtilityMethods.getLicName(userID);
        system.debug('licName: '+licName);
        if(licName != 'Guest User License'){
            t1User=false; 
            curURL=ApexPages.currentPage().getUrl();
            system.debug('curURL: '+curURL);
            if(curURL.contains('formID')){t3First=false;}
            else {t3First=true;}   
         }
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
          }
        else {userID = UserInfo.getUserId(); validSession = true; system.debug('t3 user validSession: '+validSession);} // type-3 user
        
        
        
        lineItemCollection = new List<Line_Item__c>();
        fieldHeader = new List<String>();
        apiList = new List<String>();
        form = new Forms__c();
        readOnlyFlag = false;
        index = -1;
        lineItemIdentifier = null;
        
        //Get formID from URL parameter
        formId = ApexPages.currentPage().getParameters().get('formId');
        if(formId==null){ // type-3 user will not have formId in url params
            formId = ApexPages.currentPage().getParameters().get('Id');
        }
        system.debug('formID: '+formId);
        
        //get the timezone of the user
        timeZone=UserInfo.getTimeZone();
    }
   
    //An method that is called when the visualforce page is generated.
    //Used to determine if a user session is valid.
    //If the user session is valid, call fetchTableData() to fetch data for the table
    //If the user session is not valid, then redirect the user to a blank page
    public pageReference ValidateOrRedirect()
    {
        system.debug('in ValidateOrRedirect');
        
        system.debug('validSession: '+validSession);
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
            //Get formID from URL parameter
            //formId = ApexPages.currentPage().getParameters().get('formId');
            system.debug('formID: '+formId);
            //get form info
            form = [SELECT id, name,Approval_Step__c, RecordTypeId,Unauthenticated_Owner__c  FROM Forms__c WHERE id =: formId LIMIT 1];
            
            //Variables that are used for non-TCTO forms
            String lineItemType = ApexPages.currentPage().getParameters().get('liType');
            //default
            if(lineItemType == '' || lineItemType == null){lineItemType = 'summary';}
                index = 7;
            
            system.debug('validate or redirect index: '+index);
            
            lineitemsummary1 = getLineItemSummary1(formId);
            lineitemsummary2 = getLineItemSummary2(formId);
            lineitemsummary3 = getLineItemSummary3(formId);
            lineitemsummary4 = getLineItemSummary4(formId);
            lineitemsummary5 = getLineItemSummary5(formId);
            }catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There was an error retrieving the Form!'));
            }
            return null; 
        } 
    }
    
    //A method that will update the Line Item table and return to the form site
    public pageReference saveAndReturn()
    {
        pageReference page = new pageReference('/FormPage?sID='+sessionId+'&formID='+formId);
        page.setRedirect(true);

        return page;
    }
    
    public List<SelectOption> getLineItemRTs() {
        system.debug('in getLineItemRTs');
        
        List<SelectOption> lineItemRTOptions = new List<SelectOption>();
        
        //set default based on current Line Item Record Type
        system.debug('index: '+index);
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
    
    public List<line_item__c> getLineItemSummary1(ID relatedFormId) {
        
        id rt1 = [SELECT id, name FROM RecordType WHERE name = 'OGE-450 Part 1 Assets and Income Line Item' LIMIT 1].id;
        lineItemSummary1 = [select Item_Description__c, No_Longer_Held__c, Approver_Comment__c, Filer_s_Response__c from line_item__c where Related_Form__c = :relatedFormId AND recordtypeid = :rt1];
        
        return lineItemSummary1;
   }     
   
   public List<line_item__c> getLineItemSummary2(ID relatedFormId) {
        
        id rt2 = [SELECT id, name FROM RecordType WHERE name = 'OGE-450 Part 2 Liabilities Line Item' LIMIT 1].id;
        lineItemSummary2 = [select Name_of_Creditor__c, Type_of_Liability__c, Approver_Comment__c, Filer_s_Response__c from line_item__c where Related_Form__c = :relatedFormId AND recordtypeid = :rt2];
      
        return lineItemSummary2;
   }
   
   public List<line_item__c> getLineItemSummary3(ID relatedFormId) {
        
        id rt3 = [SELECT id, name FROM RecordType WHERE name = 'OGE-450 Part 3 Outside Positions Line Item' LIMIT 1].id;
        lineItemSummary3 = [select Organization__c, Type_of_Organization__c, Position__c, No_Longer_Held__c, Approver_Comment__c, Filer_s_Response__c from line_item__c where Related_Form__c = :relatedFormId AND recordtypeid = :rt3];
        
        return lineItemSummary3;
   }
   
   public List<line_item__c> getLineItemSummary4(ID relatedFormId) {
        
        id rt4 = [SELECT id, name FROM RecordType WHERE name = 'OGE-450 Part 4 Agreements or Arrangements Line Item' LIMIT 1].id;
        lineItemSummary4 = [select Entity__c, Terms_of_Agreement_or_Arrangement__c, Approver_Comment__c, Filer_s_Response__c from line_item__c where Related_Form__c = :relatedFormId AND recordtypeid = :rt4];
       
        return lineItemSummary4;
   } 
   
   public List<line_item__c> getLineItemSummary5(ID relatedFormId) {
        
        id rt5 = [SELECT id, name FROM RecordType WHERE name = 'OGE-450 Part 5 Gifts and Travel Reimbursements Line Item' LIMIT 1].id;
        lineItemSummary5 = [select Source__c, Description__c, Approver_Comment__c, Filer_s_Response__c from line_item__c where Related_Form__c = :relatedFormId AND recordtypeid = :rt5];
     
        return lineItemSummary5;
   }
   
   public pageReference editComment() {
       pageReference page;
       
       if(t1user){
           page = new pageReference('/LineItemsGrid_e450_'+lineEditComment+'?sID='+sessionId+'&formID='+formId+'&liType='+lineEditComment);    
       }
       else {page = new pageReference('/apex/LineItemsGrid_e450_'+lineEditComment+'?formID='+formId+'&liType='+lineEditComment);}
       
       page.setRedirect(true);
       return page;
   }  
}