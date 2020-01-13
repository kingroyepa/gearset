<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_notification_to_FTTA_Agreement_Active</fullName>
        <ccEmails>FTTA@epa.gov</ccEmails>
        <description>FTTA - Email notification to FTTA- Agreement Active</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_FTTA_Agreement_Active_Using_Html</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_FTTA_Agreement_Pending</fullName>
        <ccEmails>FTTA@epa.gov</ccEmails>
        <description>FTTA - Email notification to FTTA - Agreement Pending</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_FTTA_Agreement_Pending_Using_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_FTTA_Agreement_created</fullName>
        <ccEmails>FTTA@epa.gov</ccEmails>
        <ccEmails>graham.kathleen@epa.gov</ccEmails>
        <description>FTTA - Email notification to FTTA - Agreement created</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_FTTA_Agreement_created_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_FTTA_License_Active</fullName>
        <ccEmails>FTTA@epa.gov</ccEmails>
        <description>FTTA - Email notification to FTTA- License Active</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_FTTA_License_Active_Using_Html</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_FTTA_License_Pending</fullName>
        <ccEmails>FTTA@epa.gov</ccEmails>
        <description>FTTA - Email notification to FTTA - License Pending</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_FTTA_License_Pending_Using_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_FTTA_license_created</fullName>
        <ccEmails>FTTA@epa.gov</ccEmails>
        <ccEmails>graham.kathleen@epa.gov</ccEmails>
        <description>FTTA - Email notification to FTTA - License created</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_FTTA_License_created_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_Lab_Contact_At_Signature</fullName>
        <description>FTTA - Email notification to Lab Contact- At Signature</description>
        <protected>false</protected>
        <recipients>
            <field>Lab_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_Lab_Contact_At_Signature_Using_HTML</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_to_Lab_Contact_Out_for_Signature</fullName>
        <description>FTTA - Email notification to Lab Contact- Signature Prep</description>
        <protected>false</protected>
        <recipients>
            <field>Lab_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_Lab_Contact_Out_for_Signature_Using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_OGC_Attorney_OGC_Review</fullName>
        <description>FTTA - Email notification to OGC Attorney - OGC Review</description>
        <protected>false</protected>
        <recipients>
            <field>OGC_Attorney__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_OGC_Attorney_OGC_Review_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_Owner_Agreement_Assigned</fullName>
        <description>FTTA - Email notification to Owner - Agreement Assigned</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_Owner_Agreement_Assigned_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_Owner_Agreement_Signed</fullName>
        <description>FTTA - Email notification to Owner- Agreement Signed</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_Owner_Agreement_Signed_Using_Html</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_Owner_License_Assigned</fullName>
        <description>FTTA - Email notification to Owner - License Assigned</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_Owner_License_Assigned_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_Owner_License_Signed</fullName>
        <description>FTTA - Email notification to Owner- License Signed</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_Owner_License_Signed_Using_Html</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_Owner_OGC_Concurrence</fullName>
        <description>FTTA - Email notification to Owner - OGC Concurrence</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_notification_to_Owner_OGC_Concurrence_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_PI_and_PM_At_Signature</fullName>
        <description>FTTA - Email notification to PI and PM -At Signature</description>
        <protected>false</protected>
        <recipients>
            <field>Principal_Investigator_1__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Program_Manager_1__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_Notification_to_PI_PM_At_Signature_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_secondary_PI_At_Signature</fullName>
        <description>FTTA - Email notification to secondary PI -At Signature</description>
        <protected>false</protected>
        <recipients>
            <field>Principal_Investigator_2__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_Notification_to_PI_PM_At_Signature_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_Email_notification_to_secondary_PM_At_Signature</fullName>
        <description>FTTA - Email notification to secondary PM -At Signature</description>
        <protected>false</protected>
        <recipients>
            <field>Program_Manager_2__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_Application/Email_Notification_to_PI_PM_At_Signature_using_HTML</template>
    </alerts>
    <alerts>
        <fullName>FTTA_License_Email_notification_to_OGC_Attorney_OGC_Review</fullName>
        <description>FTTA License - Email notification to OGC Attorney - OGC Review</description>
        <protected>false</protected>
        <recipients>
            <field>OGC_Attorney__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_OGC_Attorney_OGC_Review_using_HTML_License</template>
    </alerts>
    <alerts>
        <fullName>FTTA_License_Email_notification_to_Owner_OGC_Concurrence</fullName>
        <description>FTTA License - Email notification to Owner - OGC Concurrence</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FTTA_License/Email_notification_to_Owner_OGC_Concurrence_using_HTML_License</template>
    </alerts>
</Workflow>
