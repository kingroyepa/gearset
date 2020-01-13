/**********************************************************************
Name: FTTA_OnStatusUpdatehelper()
======================================================
======================================================
Purpose: FTTA Applictaion. Created for the auto generation of the amendment Id and adding the parent Partners and POCs for the amendments.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE      DETAIL               FEATURES/CSR/TTP
1.0 -   Mounika Suram 9/27/2018 Initial Development  FTTA 
1.0     Mounika Suram 10/1/2018 Upadted              FTTA 
1.0     Mounika Suram 10/24/2018 Added generation for the fiscal year FTTA License
***********************************************************************/
public class FTTA_OnStatusUpdatehelper {
    private static final Integer LICENCE_MIN = Integer.valueOf(EPAFileNumberCS__c.getInstance('LicenseMin').SequenceNumber__c);
    private static final Integer LICENCE_MAX = Integer.valueOf(EPAFileNumberCS__c.getInstance('LicenseMax').SequenceNumber__c);
    private static final Integer AGREEMENT_MIN = Integer.valueOf(EPAFileNumberCS__c.getInstance('AgreementMin').SequenceNumber__c);
    private static final Integer AGREEMENT_MAX = Integer.valueOf(EPAFileNumberCS__c.getInstance('AgreementMax').SequenceNumber__c);
    private static EPAFileNumberCS__c agreementCurrent = EPAFileNumberCS__c.getInstance('AgreementCurrent');
    private static EPAFileNumberCS__c licenseCurrent = EPAFileNumberCS__c.getInstance('LicenseCurrent');
    
    public static String generateEPAFileNumber(Boolean lOra){
        string epaFileNumber;
        String code;
        integer year = (Date.Today()).Month() > 9 ? Date.Today().Year() + 1:Date.Today().Year();
        if(lOra){
            licenseCurrent.SequenceNumber__c
                =(licenseCurrent.SequenceNumber__c == 0)?LICENCE_MIN:licenseCurrent.SequenceNumber__c+1;
            update licenseCurrent;
            code = String.valueOf(Integer.valueOf(licenseCurrent.SequenceNumber__c));
        }
        else{
            agreementCurrent.SequenceNumber__c
                =(agreementCurrent.SequenceNumber__c == 0)?AGREEMENT_MIN:agreementCurrent.SequenceNumber__c+1;
            update agreementCurrent;
            code = String.valueOf(Integer.valueOf(agreementCurrent.SequenceNumber__c));
        }
        epaFileNumber = code +' - '+string.valueof(year).right(2);
        return epaFileNumber;
    }
  
    public static string getParentFileNumber(String lastFileNumber, String name,Integer index){
        System.debug('Is FTTA_OnStatusUpdatehelper : getParentFileNumber');
        List<String> letteringSystem = new List<String>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        String lastLetter; 
        String agreementNumber;
        String parentFileNumber;
        String agreementFileNumber;
        if(lastFileNumber != null){
            System.debug('lastFileNumber'+lastFileNumber);
            String ladtLetter1 = lastFileNumber.substringBeforeLast('-');
            lastLetter = ladtLetter1.substringAfterLast('-').trim(); 
            index = letteringSystem.indexOf(lastLetter);
            System.debug('Current Index'+index);
            index ++;
            System.debug('Next Index'+index);
        }  
        String letter = letteringSystem.get(index);
        integer year = (Date.Today()).Month() > 9 ? Date.Today().Year() + 1:Date.Today().Year();
        agreementNumber = letter + ' - ' + string.valueof(year).right(2);
        parentFileNumber = name.substringBefore('-');
        agreementFileNumber = parentFileNumber +' - '+ agreementNumber;
        System.debug('agreementFileNumber'+agreementFileNumber);
        return agreementFileNumber;
    }
    
    public static void createPartnerforAmendment(EPA_Agreement__C agreement, List<Account> partners){
        try{
            System.debug('Is FTTA_OnStatusUpdatehelper : createPartneforAmendment');
            List<Account> amendmentPartners = new List<Account>();
            for(Account partner : partners){
                Account amendmentPartner =  new Account();
                amendmentPartner.name = (partner.Name <> null)? partner.Name : null;
                amendmentPartner.Short_Description__c = (partner.Short_Description__c <> null)? partner.Short_Description__c : null;
                amendmentPartner.Type = (partner.Type <> null)? partner.Type : null;
                amendmentPartner.Size_of_Business__c = (partner.Size_of_Business__c <> null)? partner.Size_of_Business__c : null;
                amendmentPartner.Description = (partner.Description <> null)? partner.Description : null;
                amendmentPartner.Submitted_by__c = (partner.Submitted_by__c <> null)? partner.Submitted_by__c : null;
                amendmentPartner.Code__c = (partner.Code__c <> null)? partner.Code__c : null;
                amendmentPartner.Phone = (partner.Phone <> null)? partner.Phone : null;
                amendmentPartner.Fax = (partner.Fax <> null)? partner.Fax : null;
                amendmentPartner.Region__c = (partner.Region__c <> null)? partner.Region__c : null;
                amendmentPartner.Foreign_Domestic__c = (partner.Foreign_Domestic__c <> null)? partner.Foreign_Domestic__c : null;
                amendmentPartner.NumberOfEmployees = (partner.NumberOfEmployees <> null)? partner.NumberOfEmployees : null;
                amendmentPartner.Startup_5_yrs__c = (partner.Startup_5_yrs__c <> null)? partner.Startup_5_yrs__c : null;
                amendmentPartner.RecordTypeId = (partner.RecordTypeId <> null)? partner.RecordTypeId : null;
                amendmentPartner.EPA_Agreement__c = agreement.id;
                amendmentPartners.add(amendmentPartner);            
             }
            insert amendmentPartners;
            System.debug('amendmentPartners'+amendmentPartners);
            
       }
       catch(exception ex){
        system.debug('Exception occured in the FTTA_OnStatusUpdatehelper' + ex.getMessage() + ex.getLineNumber());
       }
       
    }
    
    public static void createPartnePocsforAmendment(EPA_Agreement__C agreement){
        try{
            System.debug('Is FTTA_OnStatusUpdatehelper : createPartneforAmendment');
            List<Account> amendmentPartners = [select id, Name,Short_Description__c,Type,Size_of_Business__c,Region__c,Foreign_Domestic__c,NumberOfEmployees,Startup_5_yrs__c,
                               RecordTypeId, BillingCity,BillingCountry,BillingGeocodeAccuracy,
                               BillingLatitude,BillingLongitude,BillingPostalCode,BillingState, BillingStreet 
                               from Account where EPA_Agreement__c =:agreement.Agreement__c];
            System.debug('amendmentPartners'+amendmentPartners);
            List<Contact> amendmentPOCs = new List<Contact>();
            Id fttaPartnerPOCRTId = [select id from RecordType where developerName= 'FTTA_Partner_POC'].Id;
            for(Account partner : amendmentPartners){
                 for(Contact poc : [select Id,Salutation,FirstName,MiddleName,Suffix,LastName,Email,Phone,MobilePhone,Fax,AccountId,RecordTypeId from contact where AccountId = :partner.Id]){
                        Contact amendmentPoc = new Contact();
                        amendmentPoc.Salutation = (poc.Salutation <> null)? poc.Salutation : null;
                        amendmentPoc.FirstName = (poc.FirstName <> null)? poc.FirstName : null;
                        amendmentPoc.MiddleName = (poc.MiddleName <> null)? poc.MiddleName : null;
                        amendmentPoc.LastName = (poc.LastName <> null)? poc.LastName : null;
                        amendmentPoc.Suffix = (poc.Suffix <> null)? poc.Suffix : null;
                        amendmentPoc.Email = (poc.Email <> null)? poc.Email : null;
                        amendmentPoc.Phone = (poc.Phone <> null)? poc.Phone : null;
                        amendmentPoc.MobilePhone = (poc.MobilePhone <> null)? poc.MobilePhone : null;
                        amendmentPoc.Fax = (poc.Fax <> null)? poc.Fax : null;
                        amendmentPoc.AccountId=[select id from Account where name=:partner.Name and EPA_Agreement__c=:agreement.id ].id;
                        amendmentPoc.RecordTypeId =fttaPartnerPOCRTId;
                        amendmentPOCs.add(amendmentPoc);
                     
                  }
            }  
            insert amendmentPOCs;
            System.debug('amendmentPOCs'+amendmentPOCs);
        }
        catch(exception ex){
         system.debug('Exception occured in the createPartneforAmendment' + ex.getMessage() + ex.getLineNumber());
        }
       
    }
    
    public static void createProductsForAmendment(EPA_Agreement__C agreement){
        System.debug('Is FTTA_OnStatusUpdatehelper : createProductsForAmendment');
        List<Line_Item__C> products= [Select id,Item_Name__c,Product_Type__c,URL__C,
                                      Software_Developed__c, recordTypeId from Line_item__C where EPA_Agreement__c = :agreement.Agreement__c];
        List<Line_Item__c> productsForAmendment = new List<Line_Item__c>();
        if(!products.isEmpty()){
            for(Line_Item__C product: products){
                Line_Item__C productForAmendment = new Line_Item__C();
                productForAmendment.Item_Name__c = (product.Item_Name__c <> null)?product.Item_Name__c: null;
                productForAmendment.recordTypeId= (product.RecordTypeId <> null)?product.RecordTypeId: null;
                productForAmendment.Product_Type__c= (product.Product_Type__c <> null)?product.Product_Type__c: null;
                productForAmendment.URL__c= (product.URL__c <> null)?product.URL__c: null;
                productForAmendment.Software_Developed__c= (product.Software_Developed__c <> null)?product.Software_Developed__c: null;
                productForAmendment.EPA_Agreement__c= agreement.Id;
                productsForAmendment.add(productForAmendment);
            }
            insert productsForAmendment;
            System.debug('productsForAmendment'+productsForAmendment);
        }
        
    }
    
}