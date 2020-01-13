/**********************************************************************
Name: FTTA_CalculateTotalRoyaltiesAmountTest()
======================================================
======================================================
Purpose: Unit testing of FTTA_CalculateTotalRoyaltiesAmount trigger.
-------
======================================================
======================================================
History
-------
VERSION AUTHOR        DATE       DETAIL              FEATURES/CSR/TTP
1.0 -   Mounika Suram 09/26/2018 INITIAL DEVELOPMENT CSR: FTTA License
***********************************************************************/
@isTest(SeeAllData=true)
public class FTTA_CalculateTotalRoyaltiesAmountTest {
    @isTest
    private static void whenAccountingLinesAdded(){
        id fttaRoyaltiesRTId = [select id, developerName from RecordType where developerName='FTTA_Royalties'].id;
        id fttaLicenseId = [select id, developerName from RecordType where developerName='FTTA_License'].id;
        // Create mock data
        // Insert epa license
        EPA_Agreement__c license = [select id,Total_Royalties__c from EPA_Agreement__c where recordTypeId=:fttaLicenseId Limit 1];
        //Create accounting lines and associate with license
        List<Accounting_Line__c> acList= new List<Accounting_Line__c>();
        Accounting_Line__c ac1 = new Accounting_Line__c();
        ac1.EPA_License__c=license.id;
        ac1.Payment_Amount__c=200.0;
        ac1.RecordTypeId=fttaRoyaltiesRTId;
        acList.add(ac1);
        Accounting_Line__c ac2 = new Accounting_Line__c();
        ac2.EPA_License__c=license.id;
        ac2.Payment_Amount__c=300.0;
        ac2.RecordTypeId=fttaRoyaltiesRTId;
        acList.add(ac2);
        Accounting_Line__c ac3 = new Accounting_Line__c();
        ac3.EPA_License__c=license.id;
        ac3.Payment_Amount__c=100.0;
        ac3.RecordTypeId=fttaRoyaltiesRTId;
        acList.add(ac3);
        Test.startTest();
        insert acList;
        ac1.Payment_Amount__c=100.0;
        Decimal totalRoyalties=[select id,Total_Royalties__c from EPA_Agreement__c where id=:license.id].Total_Royalties__c ;
        update ac1;
        system.assertEquals(totalRoyalties - 100.0, 
                            [select id,Total_Royalties__c from EPA_Agreement__c where id=:license.id].Total_Royalties__c);
        delete ac1;
        Test.stopTest();
        
    }
}