/**********************************************************************
Name: FTTA_CalculateTotalInventorAndLabTest()
======================================================
======================================================
Purpose: Unit testing of FTTA_CalculateTotalInventorAndLab trigger.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -   Mounika Suram 09/26/2018 INITIAL DEVELOPMENT CSR: FTTA License
***********************************************************************/
@isTest(SeeAllData=true)
public class FTTA_CalculateTotalInventorAndLabTest {

     @isTest
    private static void whenContactsAdded(){
        id fttaInventorRTId = [select id, developerName from RecordType where developerName='FTTA_License_Inventor'].id;
        id fttaLicenseId = [select id, developerName from RecordType where developerName='FTTA_License'].id;
        // Create mock data
        // Insert epa license
        EPA_Agreement__c license = [select id,Total_Royalties__c from EPA_Agreement__c where recordTypeId=:fttaLicenseId Limit 1];
        //Create accounting lines and associate with license
        List<Contact> conList= new List<Contact>();
        Contact con = new Contact();
        con.LastName='test';
        con.Inventor_Amount__c= 100.0;
        con.Lab_Office_Amount__c = 100.0;
        con.EPA_Agreement_License__c=license.id;
        con.RecordTypeId=fttaInventorRTId;
        conList.add(con);
        Contact con1 = new Contact();
        con1.LastName='test1';
        con1.Inventor_Amount__c= 100.0;
        con1.Lab_Office_Amount__c = 100.0;
        con1.EPA_Agreement_License__c=license.id;
        con1.RecordTypeId=fttaInventorRTId;
        conList.add(con1);
        Contact con2 = new Contact();
        con2.LastName='test2';
        con2.Inventor_Amount__c= 100.0;
        con2.Lab_Office_Amount__c = 100.0;
        con2.EPA_Agreement_License__c=license.id;
        con2.RecordTypeId=fttaInventorRTId;
        conList.add(con2);
        Test.startTest();
        insert conList;
        Decimal totalInventorAmount=[select id,Total_EPA_Inventor_Amount__c from EPA_Agreement__c where id=:license.id].Total_EPA_Inventor_Amount__c ;
        Decimal totalLabAmount=[select id,Total_Lab_Office_Amount__c from EPA_Agreement__c where id=:license.id].Total_Lab_Office_Amount__c ;
        con.Inventor_Amount__c= 200.0;
        con.Lab_Office_Amount__c = 200.0;
        update con;
        system.assertEquals(totalInventorAmount + 100.0, 
                            [select id,Total_EPA_Inventor_Amount__c from EPA_Agreement__c where id=:license.id].Total_EPA_Inventor_Amount__c);
        system.assertEquals(totalLabAmount + 100.0, 
                            [select id,Total_Lab_Office_Amount__c from EPA_Agreement__c where id=:license.id].Total_Lab_Office_Amount__c);
        delete con;
        Test.stopTest();
        
    }
}