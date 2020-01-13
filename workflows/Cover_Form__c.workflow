<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_sent_to_Owner_Approval_NO</fullName>
        <description>Email sent to Owner (Approval) (NO)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>STAA_Application/STAA_Nominating_Official_Approval_NO</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_Owner_Rejection_NO</fullName>
        <description>Email sent to Owner (Rejection) (NO)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>STAA_Application/STAA_Rejection_NO</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_Owner_Rejection_SC</fullName>
        <description>Email sent to Owner and Nominating Official (Rejection) (SC)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Nominating_Official__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>STAA_Application/STAA_Rejection_from_STAA_Coordinator</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_Owner_to_Confirm_Submission</fullName>
        <description>Email sent to Owner to Confirm Submission</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>STAA_Application/STAA_Author_Confirmation_Submission</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_STAA_Coordinator</fullName>
        <description>Email sent to STAA Coordinator</description>
        <protected>false</protected>
        <recipients>
            <field>STAA_Coordinator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>STAA_Application/STAA_STAA_Coordinato_Approval_Required</template>
    </alerts>
    <fieldUpdates>
        <fullName>Draft_Status_NO</fullName>
        <field>Status__c</field>
        <literalValue>DRAFT</literalValue>
        <name>DRAFT Status (NO)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Draft_Status_SC</fullName>
        <field>Status__c</field>
        <literalValue>DRAFT</literalValue>
        <name>DRAFT Status (SC)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Status_SC</fullName>
        <field>Status__c</field>
        <literalValue>FINAL</literalValue>
        <name>FINAL Status (SC)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Locked2_Status</fullName>
        <field>Status__c</field>
        <literalValue>LOCKED2</literalValue>
        <name>LOCKED - Pending SC Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Locked_Status</fullName>
        <field>Status__c</field>
        <literalValue>LOCKED</literalValue>
        <name>LOCKED - Pending NO Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
