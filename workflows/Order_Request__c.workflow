<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_Owner_Notification_of_Approval</fullName>
        <description>GAS Order Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GAS_Application/GAS_Order_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Owner_Notification_of_Rejection</fullName>
        <description>GAS Order Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GAS_Application/GAS_Order_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Order_Submitted_for_Approval</fullName>
        <description>GAS Order Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GAS_Application/GAS_Order_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>PCOR_Order_Approval_Notification</fullName>
        <description>PCOR Order Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCOR_Application/PCOR_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>PCOR_Order_Approval_Notification_Cardholder</fullName>
        <description>PCOR Order Approval Notification to Cardholder</description>
        <protected>false</protected>
        <recipients>
            <field>Card_Holder__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCOR_Application/PCOR_Request_Approved_CardHolder</template>
    </alerts>
    <alerts>
        <fullName>PCOR_Order_Rejection_Notification</fullName>
        <description>PCOR Order Rejection Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCOR_Application/Purchase_Order_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>PCOR_Order_Submission_Confirmation</fullName>
        <description>PCOR Order Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PCOR_Application/PCOR</template>
    </alerts>
    <fieldUpdates>
        <fullName>GreenPurchaseEPEAT</fullName>
        <field>Green_Purchases__c</field>
        <literalValue>1</literalValue>
        <name>GreenPurchaseEPEAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ORDGAS_Set_Stage_to_Approved</fullName>
        <field>Stage__c</field>
        <literalValue>Request Approved</literalValue>
        <name>ORDGAS Set Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ORDGAS_Set_Stage_to_Pending</fullName>
        <field>Stage__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>ORDGAS Set Stage to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ORD_GASRejected_Set_Stage_to_New_Order</fullName>
        <field>Stage__c</field>
        <literalValue>New Order</literalValue>
        <name>ORDGAS Rejected - Set Stage to New Order</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_508</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)</formula>
        <name>PCOR-Set Assigned To 508</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_AO</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>Approving_Official__r.FirstName + " "+ Approving_Official__r.LastName</formula>
        <name>PCOR-Set Assigned To AO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Branch_Chief</fullName>
        <description>PCOR Apllication.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)</formula>
        <name>PCOR-Set Assigned To Branch Chief</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Deputy_Director</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
		Deputy_Director__c  &lt;&gt; null,Deputy_Director__r.FirstName+ " "+Deputy_Director__r.LastName,
		IF(
		Division_Director__c   &lt;&gt; null,Division_Director__r.FirstName+ " "+Division_Director__r.LastName,
			IF(
			Human_Resource_Official__c &lt;&gt; null,Human_Resource_Official__r.FirstName+ " "+Human_Resource_Official__r.LastName,		
				IF(
				IT_Official__c &lt;&gt; null,IT_Official__r.FirstName+ " "+IT_Official__r.LastName,
					IF(
					Printing_Reviewer__c  &lt;&gt; null,Printing_Reviewer__r.FirstName+ " "+Printing_Reviewer__r.LastName,
					IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)
				
					)
					)
				)
				
			
			)
		)</formula>
        <name>PCOR-Set Assigned To Deputy Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Director</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
	Director__c &lt;&gt; null,Director__r.FirstName+ " "+Director__r.LastName,
	IF(
		Deputy_Director__c  &lt;&gt; null,Deputy_Director__r.FirstName+ " "+Deputy_Director__r.LastName,
		IF(
		Division_Director__c   &lt;&gt; null,Division_Director__r.FirstName+ " "+Division_Director__r.LastName,
			IF(
			Human_Resource_Official__c &lt;&gt; null,Human_Resource_Official__r.FirstName+ " "+Human_Resource_Official__r.LastName,		
				IF(
				IT_Official__c &lt;&gt; null,IT_Official__r.FirstName+ " "+IT_Official__r.LastName,
					IF(
					Printing_Reviewer__c  &lt;&gt; null,Printing_Reviewer__r.FirstName+ " "+Printing_Reviewer__r.LastName,
					IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)
				
					)
					)
				)
				
			
			)
		)
)</formula>
        <name>PCOR-Set Assigned To Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Division_Director</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
		Division_Director__c   &lt;&gt; null,Division_Director__r.FirstName+ " "+Division_Director__r.LastName,
			IF(
			Human_Resource_Official__c &lt;&gt; null,Human_Resource_Official__r.FirstName+ " "+Human_Resource_Official__r.LastName,		
				IF(
				IT_Official__c &lt;&gt; null,IT_Official__r.FirstName+ " "+IT_Official__r.LastName,
					IF(
					Printing_Reviewer__c  &lt;&gt; null,Printing_Reviewer__r.FirstName+ " "+Printing_Reviewer__r.LastName,
					IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)
				
					)
					)
				)
				
			
			)</formula>
        <name>PCOR-Set Assigned To Division Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_FCO</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>FCO__r.FirstName +" "+ FCO__r.LastName</formula>
        <name>PCOR-Set Assigned To FCO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_FacilitiesReviewer</fullName>
        <description>PCOR Application</description>
        <field>Assigned_to__c</field>
        <formula>IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)</formula>
        <name>PCOR-Set Assigned To FacilitiesReviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_HR</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
			Human_Resource_Official__c &lt;&gt; null,Human_Resource_Official__r.FirstName+ " "+Human_Resource_Official__r.LastName,		
				IF(
				IT_Official__c &lt;&gt; null,IT_Official__r.FirstName+ " "+IT_Official__r.LastName,
					IF(
					Printing_Reviewer__c  &lt;&gt; null,Printing_Reviewer__r.FirstName+ " "+Printing_Reviewer__r.LastName,
					IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)
				
					)
					)
				)</formula>
        <name>PCOR-Set Assigned To HR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Health_Safety</fullName>
        <description>PCOR application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)</formula>
        <name>PCOR-Set Assigned To Health&amp;Safety</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_IMO</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IMO__r.FirstName +" "+ IMO__r.LastName</formula>
        <name>PCOR-Set Assigned To IMO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_IT_Reviewer</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
				IT_Official__c &lt;&gt; null,IT_Official__r.FirstName+ " "+IT_Official__r.LastName,
					IF(
					Printing_Reviewer__c  &lt;&gt; null,Printing_Reviewer__r.FirstName+ " "+Printing_Reviewer__r.LastName,
					IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)
				
					)
					)</formula>
        <name>PCOR-Set Assigned To IT Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Printing_Reviewer</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
					Printing_Reviewer__c  &lt;&gt; null,Printing_Reviewer__r.FirstName+ " "+Printing_Reviewer__r.LastName,
					IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)
				
					)</formula>
        <name>PCOR-Set Assigned To Printing Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_Propert_Reviewer</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>IF(
					Property_Reviewer__c  &lt;&gt; null,Property_Reviewer__r.FirstName+ " "+Property_Reviewer__r.LastName,
					IF(
					Facilities_Reviewer__c &lt;&gt; null,Facilities_Reviewer__r.FirstName+ " "+Facilities_Reviewer__r.LastName,
					IF(
					Health_Safety_Reviewerser__c  &lt;&gt; null,Health_Safety_Reviewerser__r.FirstName+ " "+Health_Safety_Reviewerser__r.LastName,
					IF(
					X508_Approver__c &lt;&gt; null,X508_Approver__r.FirstName+ " "+X508_Approver__r.LastName,
					IF(
					Branch_chief_pcor__c  &lt;&gt; null,Branch_chief_pcor__r.FirstName+ " "+Branch_chief_pcor__r.LastName,
					FCO__r.FirstName+ " "+FCO__r.LastName
				
					)
				
					)
				
					)
				
					)
					)</formula>
        <name>PCOR-Set Assigned To Propert Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Assigned_To_null</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <name>PCOR-Set Assigned To null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Stage_to_Approved</fullName>
        <description>PCOR Application. Set the Stage to Approved.</description>
        <field>Request_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>PCOR Set Stage to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Stage_to_Awaiting_Approval</fullName>
        <description>PCOR Application.Set the current stage to Awaiting Approval.</description>
        <field>Request_Status__c</field>
        <literalValue>Awaiting Approval</literalValue>
        <name>PCOR Set Stage to Awaiting Approval.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Stage_to_Awaiting_Funding</fullName>
        <description>PCOR Application.Set the current stage of the order request to Awaiting Approval.</description>
        <field>Request_Status__c</field>
        <literalValue>Awaiting Funding</literalValue>
        <name>PCOR Set Stage to Awaiting Funding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_Stage_to_New_Order</fullName>
        <description>PCOR Application. Set the Stage to New Order.</description>
        <field>Request_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>PCOR Set Stage to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PCOR_Set_assigned_to_CH</fullName>
        <description>PCOR Application.</description>
        <field>Assigned_to__c</field>
        <formula>Card_Holder__r.FirstName +" "+ Card_Holder__r.LastName</formula>
        <name>PCOR-Set Assigned To CH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_New_Order</fullName>
        <description>PCOR Application. Created to set the request status to New Order when the order is recalled.</description>
        <field>Request_Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Set Status to Draft</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GreenPurchaseEPEAT</fullName>
        <actions>
            <name>GreenPurchaseEPEAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Order_Request__c.EPEAT__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PCOR Amendment,Purchase Card Order Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Order_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>IT/E&amp;IT Purchase</value>
        </criteriaItems>
        <description>needs to automatically check Green Purchase box if EPEAT = Yes</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
