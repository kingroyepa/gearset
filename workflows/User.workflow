<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_user_of_upcoming_deactivation</fullName>
        <description>Notify user of upcoming deactivation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CommunityLockoutEmailTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>Deactivate_User</fullName>
        <description>Deactivate User</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Auto Deactivate User</fullName>
        <active>false</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Deactivate User after 90 day of last login</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notify_user_of_upcoming_deactivation</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>User.LastLoginDate</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_User</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.LastLoginDate</offsetFromField>
            <timeLength>105</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
