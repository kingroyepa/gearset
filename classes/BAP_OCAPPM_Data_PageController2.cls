public class BAP_OCAPPM_Data_PageController2{
    public string sID {get;set;}
    public boolean valid {get;set;}
    public id uID {get;set;}
    public String licName {get;set;}
    public Boolean t1User {get;set;}
    
    public String sortField {get;set;}
        {sortField = 'Inquiry_Date__c';}
    
    public Boolean sortOrderASC {get;set;}
        {sortOrderASC = true;}
    
    public String fileName {get;set;}
        {fileName = 'OCAPPM Export - '+system.today().format();}
            
    private String sortOrder = 'ASC';
    
    public BAP_OCAPPM_Data_PageController2(){
        ID userID = UserInfo.getUserID();
        licName = UtilityMethods.getLicName(userID);
        
        if(licName != 'Guest User License'){t1User=false;}
        else{t1User=true;}
        if(t1User){
        valid = false;
        // Get session ID from URL parameters, get user ID from the matching session
        sID = UtilityMethods.getSessionID();
        uID = UtilityMethods.getUserID(sID);
        
        // Validate Session, temporarily disabled until more user data from proxy 
        valid = UtilityMethods.validateSession(sID, uID);
          }
        else {uID = UserInfo.getUserId(); valid= true;}
    }
    
    public PageReference validateOrRedirect() {
        // 9/21/2017 - Larry Spackman - Disabled for deployment to Production because HeaderLogs custom object not being deployed
        /*
        // Log Header & Parameters
        UtilityMethods.logHeaders();
        // End Log Header & Parameters
        */
       
        // Valid value from Verify Session call above
        if (!valid) {
            PageReference retURL = new PageReference('/');
            return retURL;
        }
        else { return null; }       
    }
    
    public list<submission__c> getissues(){
        
        if(sortOrderASC){sortOrder = 'ASC';}
           else{sortOrder = 'DESC';}
        id rtid = [select id, developername, name, sObjectType from recordtype where sObjectType = 'Submission__c' and developername = 'CX_Tracker' limit 1].id;
        
        list<submission__c> results = Database.query('select id, '+
                                'Name, '+
                                'Inquirer__c, '+
                                'RPIO_Name__c, '+
                                'Organization_Full_Name__c, '+
                                'Inquirer_Phone__c, '+
                                'Inquirer_Email__c, '+
                                'Customer_Inquiry_Input__c, '+
                                'Category_OCAPPM__c, '+
                                'Sub_Category_OCAPPM__c, '+
                                'Responsible_OEI_Office__c, '+
                                'Inquiry_Date__c, '+
                                'SME_Notification_Date__c, '+
                                'SME_Response_Date__c, '+
                                'SME_Response__c, '+
                                'CX_POC_Comments__c, '+
                                'Inquiry_Closeout_Date__c, '+
                                'Status_OCAPPM__c, '+
                                'Abbrv_Customer_Inquiry_Input__c, '+
                                'Abbrv_SME_Response__c, '+
                                'Inquiry_Date_Formatted__c '+
                                'From submission__c '+
                                'WHERE recordtypeid = :rtid '+
                                'Order By '+ sortField + ' ' + sortOrder);  
                                 
                        return results;
        }
    
    public pagereference download(){
        return page.BAP_OCAPPM_Data_Excel3;
    }
    
    public pagereference save(){
        return null;
    }
    
    public pagereference cancel(){
        return null;
    }
    
    public void sortByCustomerInquiryInput() {
        if(sortOrderASC){sortOrderASC=false;}
            else{sortOrderASC=true;}
        this.sortField = 'Abbrv_Customer_Inquiry_Input__c';
        sortField = 'Abbrv_Customer_Inquiry_Input__c';
    }
    
    public void sortByInquiryDate() {
        if(sortOrderASC){sortOrderASC=false;}
            else{sortOrderASC=true;}
        this.sortField = 'Inquiry_Date__c';
        sortField = 'Inquiry_Date__c';
    }
    
    public void sortByInquiryCategory() {
        if(sortOrderASC){sortOrderASC=false;}
            else{sortOrderASC=true;}
        this.sortField = 'Category_OCAPPM__c';
        sortField = 'Category_OCAPPM__c';
    }
    
    public void sortBySMEResponse() {
        if(sortOrderASC){sortOrderASC=false;}
            else{sortOrderASC=true;}
        this.sortField = 'Abbrv_SME_Response__c';
        sortField = 'Abbrv_SME_Response__c';
    }
    
    public void sortByStatus() {
        if(sortOrderASC){sortOrderASC=false;}
            else{sortOrderASC=true;}
        this.sortField = 'Status_OCAPPM__c';
        sortField = 'Status_OCAPPM__c';
    }
    
    public void sortByRPIO() {
        if(sortOrderASC){sortOrderASC=false;}
            else{sortOrderASC=true;}
        this.sortField = 'RPIO_Name__c';
        sortField = 'RPIO_Name__c';
    }
    
}