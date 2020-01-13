<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ORD_GAS_Delivery_Confirmation</fullName>
        <description>Email sent to GAS Order Request Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GAS_Application/GAS_Cylinder_Ready_for_Pickup</template>
    </alerts>
    <fieldUpdates>
        <fullName>OGE_450_Comment_Signature</fullName>
        <description>Adds identity of commenter, date, time, and Approval Step to Line Item comments for OGE-450 Forms.</description>
        <field>Approver_Comment__c</field>
        <formula>Approver_Comment__c &amp; BR() &amp; $User.FirstName &amp; " " &amp; $User.LastName &amp; ", " &amp; text(TODAY()) &amp;" "&amp; text(HOUR(timevalue(NOW()))) &amp;":"&amp; text(MINUTE(timevalue(NOW())))&amp; "(GMT). Approval Step: " &amp; Related_Form__r.Approval_Step__c</formula>
        <name>OGE-450 Comment Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OGE-450 Update Comment Signature</fullName>
        <actions>
            <name>OGE_450_Comment_Signature</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Adds identity of commenter, date, time, and Approval Step to Line Item comments for OGE-450 Forms.</description>
        <formula>ISCHANGED( Approver_Comment__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
