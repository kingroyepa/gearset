<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ORDGAS_SET_STATUS_TO_ARCHIVE_FOR_eOrder</fullName>
        <description>GAs Application.</description>
        <field>Status__c</field>
        <literalValue>Archived</literalValue>
        <name>ORDGAS_SET_STATUS_TO_ARCHIVE_FOR_eOrder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ORDGAS_SET_STATUS_TO_ARCHIVE_FOR_eOrder</fullName>
        <actions>
            <name>ORDGAS_SET_STATUS_TO_ARCHIVE_FOR_eOrder</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>eOrders__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>GAS eOrder Admin,GAS eOrder Return</value>
        </criteriaItems>
        <criteriaItems>
            <field>eOrders__c.Archive__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>GAS Application</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
