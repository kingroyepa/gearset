<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Abbreviate_Customer_Inquiry</fullName>
        <field>Abbrv_Customer_Inquiry_Input__c</field>
        <formula>LEFT( Customer_Inquiry_Input__c , 25)</formula>
        <name>Abbreviate Customer Inquiry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Abbreviate_SME_Response</fullName>
        <field>Abbrv_SME_Response__c</field>
        <formula>LEFT( SME_Response__c , 25)</formula>
        <name>Abbreviate SME Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Abbreviate Customer Inquiry</fullName>
        <actions>
            <name>Abbreviate_Customer_Inquiry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Submission__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CX Tracker</value>
        </criteriaItems>
        <criteriaItems>
            <field>Submission__c.Abbrv_Customer_Inquiry_Input__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Abbreviate SME Response</fullName>
        <actions>
            <name>Abbreviate_SME_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Submission__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>CX Tracker</value>
        </criteriaItems>
        <criteriaItems>
            <field>Submission__c.SME_Response__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
