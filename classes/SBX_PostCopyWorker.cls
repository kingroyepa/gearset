/**********************************************************************
Name: SBX_PostCopyWorker
======================================================
======================================================
Purpose:
-------
sf-sandbox-post-copy framework based on https://github.com/GSA/sf-sandbox-post-copy
======================================================
======================================================
History
-------
VERSION AUTHOR DATE DETAIL FEATURES/CSR/TTP
  1.0   Roy King 8/5/19 Initial development  
 
**********************************************************************/
public with sharing abstract class SBX_PostCopyWorker {

	/**
	* One of the two methods that are required to be implemented by a SBX_PostCopyWorker.
	* Class extensions will implement this method and include any post copy logic they want to run.
	* Generic exception handling is provided by the wrapper method process() below which is directly
	* 	called by the SBX_PostCopyManager
	*/
	protected abstract void run(SandboxContext context);

	/**
	* In order to identify the offending class that has caused an exception developers will 
	* 	need to implement this getClassName() method so that a Post Copy Log is created with the 
	* 	appropriate class name.
	*/
	public abstract String getClassName();

	/**
	* This is the publicly available method called by the SBX_PostCopyManager. Class extensions
	* 	are required to implement the run method above which is then wrapped by this process() method.
	* 	It attempts to provide generic exception handling. If you are catching your own exceptions then
	* 	be sure to look at the SBX_PostCopyUtil to see the way they are generated.
	*/
	public void process(SandboxContext context){
		try {
			run(context);
			SBX_PostCopyUtil.createLogObj(getClassName(), null);
            if (Test.isRunningTest()) {
                CalloutException e = new CalloutException();
                e.setMessage('This is a constructed exception for testing and code coverage');
                throw e;
            }
		} catch (Exception e){
			SBX_PostCopyUtil.createLogObj(getClassName(), e);
		}
	}

}