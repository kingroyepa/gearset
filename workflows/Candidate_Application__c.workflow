<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TQB_Candidate_Package_Approved</fullName>
        <description>TQB Candidate Package Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Approved</template>
    </alerts>
    <alerts>
        <fullName>TQB_Candidate_Package_Rejected</fullName>
        <description>TQB Candidate Package Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Rejected</template>
    </alerts>
    <alerts>
        <fullName>TQB_Candidate_Package_Sent_to_2nd_Line_Supervisor</fullName>
        <description>TQB Candidate Package Sent to 2nd Line Supervisor</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Approved_by_1st_Supervisor</template>
    </alerts>
    <alerts>
        <fullName>TQB_Candidate_Package_Sent_to_TQB_Chair</fullName>
        <description>TQB Candidate Package Sent to TQB Chair</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Sent_to_Chair</template>
    </alerts>
    <alerts>
        <fullName>TQB_Candidate_Package_Sent_to_TQB_Coordinator</fullName>
        <description>TQB Candidate Package Sent to TQB Coordinator</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Submitted_to_TQB_Coordinator</template>
    </alerts>
    <alerts>
        <fullName>TQB_Candidate_packae_approved_email_notification_to_coordinator</fullName>
        <description>TQB - Candidate packae approved email notification to coordinator</description>
        <protected>false</protected>
        <recipients>
            <field>TQB_Coordinator_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Coordinator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Approved</template>
    </alerts>
    <alerts>
        <fullName>TQB_Candidate_packae_recalled_email_notification_to_coordinator</fullName>
        <description>TQB - Candidate package recalled email notification to coordinator</description>
        <protected>false</protected>
        <recipients>
            <field>First_Line_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Second_Line_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Chair__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Coordinator_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Coordinator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Candidate_Package_Recalled</template>
    </alerts>
    <alerts>
        <fullName>TQB_Effective_Date_Notification</fullName>
        <description>TQB Effective Date Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Promotion_Effective_Date_Notification</template>
    </alerts>
    <alerts>
        <fullName>TQB_LCO_Director_Approval_Notification</fullName>
        <description>TQB LCO Director Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Second_Line_Supervisor__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Chair__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Coordinator_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>TQB_Coordinator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_LCO_Director_Approval</template>
    </alerts>
    <alerts>
        <fullName>TQB_LOI_Approved_Notification</fullName>
        <description>TQB LOI Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_LOI_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>TQB_LOI_Rejected_Notification</fullName>
        <description>TQB LOI Rejected Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_Letter_of_Intent_Rejected</template>
    </alerts>
    <alerts>
        <fullName>TQB_LOI_Submitted_Notification</fullName>
        <description>TQB LOI Submitted Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TQB_Email_Templates/TQB_LOI_Submitted</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_RT_to_submission</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Candidate_Submission</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change RT to submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQBUpdate_Status_Pending_Chair</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting TQB Chair Approval</literalValue>
        <name>TQBUpdate Status Pending Chair</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQBUpdate_Status_Pending_TQB_Coordinator</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting TQB Coordinator Approval</literalValue>
        <name>TQBUpdate Status Pending TQB Coordinator</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQBUpdate_Status_to_Pending_Supervisor_1</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting 1st Line Supervisor Approval</literalValue>
        <name>TQBUpdate Status to Pending Supervisor 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQBUpdate_Status_to_Pending_Supervisor_2</fullName>
        <field>Status__c</field>
        <literalValue>Awaiting 2nd Line Supervisor Approval</literalValue>
        <name>TQBUpdate Status to Pending Supervisor 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Indicate_Final_Approval</fullName>
        <description>Update hidden checkbox so that validation will prevent editing by anyone except Coordinators and system admin after final approval</description>
        <field>Final_Approved__c</field>
        <literalValue>1</literalValue>
        <name>TQB Indicate Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_SetStatustoComplete</fullName>
        <description>TQB application. Sets the staus of the candidate application to completed.</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>TQB_SetStatustoCompleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Set_Status_to_Complete</fullName>
        <description>TQB application.. Sets the status to completed.</description>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>TQB - Set Status to Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Set_Status_to_TQB_Completed</fullName>
        <description>TQB application.</description>
        <field>Status__c</field>
        <literalValue>TQB Completed</literalValue>
        <name>TQB - Set Status to TQB Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Set_Status_to_TQB_Held</fullName>
        <description>TQB application.. Sets the status to completed.</description>
        <field>Status__c</field>
        <literalValue>TQB Held</literalValue>
        <name>TQB - Set Status to TQB Held</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Set_Status_to_TQB_Scheduled</fullName>
        <description>TQB application.</description>
        <field>Status__c</field>
        <literalValue>TQB Scheduled</literalValue>
        <name>TQB - Set Status to TQB Scheduled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Update_Status_to_Approved_by_Chair</fullName>
        <field>Status__c</field>
        <literalValue>TQB Coordinator Review</literalValue>
        <name>TQB Update Status to Approved by Chair</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Update_Status_to_LOI_Approved</fullName>
        <field>Status__c</field>
        <literalValue>LOI Approved</literalValue>
        <name>TQB Update Status to LOI Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Update_Status_to_Recalled</fullName>
        <description>TQB Application</description>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>TQB Update Status to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Update_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>TQB_Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TQB_Update_to_Candidate_Package</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Candidate_Package</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>TQB Update to Candidate Package</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>TQB -Status set to TQB Completed</fullName>
        <actions>
            <name>TQB_Set_Status_to_TQB_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Candidate_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Candidate Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Candidate_Application__c.Candidate_Package_Finalized__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>TQB application. When final promotion date is entered, status of the candidate application is changed to TQB completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB -Status set to TQB Held</fullName>
        <actions>
            <name>TQB_Set_Status_to_TQB_Held</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Candidate_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Candidate Application,Candidate Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Candidate_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved_by_TQB_Chair</value>
        </criteriaItems>
        <criteriaItems>
            <field>Candidate_Application__c.Promotion_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>TQB application. When promotion date is entered, status of the candidate application is changed to TQB Held.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB -Status set to TQB Scheduled</fullName>
        <actions>
            <name>TQB_Set_Status_to_TQB_Scheduled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Candidate_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Candidate Application,Candidate Submission</value>
        </criteriaItems>
        <criteriaItems>
            <field>Candidate_Application__c.TQB_Scheduled_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>TQB application. When promotion scheduled date is entered, status of the candidate application is changed to TQB scheduled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB -Status set to complete</fullName>
        <actions>
            <name>TQB_Set_Status_to_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Candidate_Application__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Candidate Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Candidate_Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved_by_TQB_Chair</value>
        </criteriaItems>
        <criteriaItems>
            <field>Candidate_Application__c.Promotion_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>TQB application. When promotion date is entered, status of the candidate application is changed to completed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB Director Approval Notification</fullName>
        <actions>
            <name>TQB_LCO_Director_Approval_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Candidate_Application__c.Promotion_Decision__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQB Promotion Effective Date Notification</fullName>
        <actions>
            <name>TQB_Effective_Date_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Candidate_Application__c.Promotion_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TQBChangeSatusToCompleted</fullName>
        <actions>
            <name>TQB_SetStatustoComplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Candidate_Application__c.Promotion_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>TQB application. Changes the status of the candidate application to completed once the promotion effective date is filled.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
