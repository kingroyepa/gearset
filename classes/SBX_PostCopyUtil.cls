/**********************************************************************
Name: SBX_PostCopyUtil
======================================================
======================================================
Purpose:
-------
Handles logging and error parsing to log on Metadata object/Sandbox Log record type
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
public with sharing class SBX_PostCopyUtil {

	private static final String PICKLIST_STATUS_SUCCESS = 'Success';
	private static final String PICKLIST_STATUS_FAILURE = 'Error';
	private static final String DELIMITER = '|||';
	// Apex Controller for ECMS List Lightning Component
	public static Id stringRt = Schema.SObjectType.Metadata__c.getRecordTypeInfosByName().get('Sandbox Log').getRecordTypeId();

	/**
	* Consider making this util less generic by extracting the log object creation aspect into its own class.
	*/
	public static void createLogObj(String className, Exception e){
		if(e != null){
			Metadata__c errorLog = new Metadata__c();
			errorLog.Status__c = PICKLIST_STATUS_FAILURE;
			errorLog.Name = className;
			errorLog.RecordTypeId = stringRt;
			errorLog.Description__c = getErrorMessage(e);
			insert errorLog;
		} else {
			Metadata__c successLog = new Metadata__c();
			successLog.Status__c = PICKLIST_STATUS_SUCCESS;
			successLog.Name = className;
			successLog.RecordTypeId = stringRT;
			insert successLog;
		}
	}

	/**
	* Required to perform the testRun_UnknownExceptionOccursViaChildClass_VerifyLogObjectCreated method
	* 	in SBX_AdminEmailWorkerTest.
	*/
	public class ForcedException extends Exception{

	}

	private static String getErrorMessage(Exception e){
		return 	  e.getLineNumber() + DELIMITER
				+ e.getMessage() + DELIMITER
				+ e.getStackTraceString();

	}

}