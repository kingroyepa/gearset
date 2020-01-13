<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AAT_ALL_SITLs_CC_Group</fullName>
        <description>AAT - ALL SITLs CC Group</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_ALL_SITLs_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_All_SITLs_Notification</fullName>
        <description>AAT - All SITLs Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_All_Local_SITLs</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_All_SITLs_Notification</template>
    </alerts>
    <alerts>
        <fullName>AAT_Email_to_SITL_Group</fullName>
        <description>AAT - Email to SITL Group</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_Review_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_SITL_Group_Notification</template>
    </alerts>
    <alerts>
        <fullName>AAT_Final_Approval</fullName>
        <description>AAT - Final Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Approval</template>
    </alerts>
    <alerts>
        <fullName>AAT_Final_Reject</fullName>
        <description>AAT - Final Reject</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection</template>
    </alerts>
    <alerts>
        <fullName>AAT_Final_Rejection</fullName>
        <description>AAT Final Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Approval</fullName>
        <description>AAT - Form Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Approval</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Approval_CC_Group</fullName>
        <description>AAT - Form Approval CC Group</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Approval_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Rejection_CC_Group_Owning_SITL</fullName>
        <description>AAT - Form Rejection CC Group (Owning SITL)</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Rejection_CC_Group_Owning_SITL_Owning_SIO</fullName>
        <description>AAT - Form Rejection CC Group (Owning SITL,Owning SIO)</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Rejection_cc_SITL</fullName>
        <description>AAT - Form Rejection - cc SITL</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection_cc_SITL</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Rejection_cc_SITL_SIO</fullName>
        <description>AAT - Form Rejection - cc SITL,SIO</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection_cc_SITL_SIO</template>
    </alerts>
    <alerts>
        <fullName>AAT_Form_Rejection_no_cc</fullName>
        <description>AAT - Form Rejection - no cc</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Form_Rejection_no_cc</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_4_Day_Reminder</fullName>
        <description>AAT - Local SITL - 4 Day Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_4_Day_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_AO_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC AO Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_AO_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_Group</fullName>
        <description>AAT - Local SITL CC Group</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OAR_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OAR Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OAR_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OCFO_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OCFO Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OCFO_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OCSPP_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OCSPP Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OCSPP_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OECA_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OECA Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OECA_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OGC_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OGC Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OGC_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OIG_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OIG Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OIG_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OITA_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OITA Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OITA_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OLEM_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OLEM Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OLEM_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OMS_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OMS Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OMS_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_ORD_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC ORD Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_ORD_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_OW_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC OW Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_OW_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R01_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R01 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R01_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R02_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R02 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R02_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R03_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R03 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R03_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R04_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R04 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R04_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R05_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R05 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R05_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R06_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R06 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R06_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R07_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R07 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R07_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R08_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R08 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R08_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R09_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R09 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R09_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Local_SITL_CC_R10_Pre_Review_Group</fullName>
        <description>AAT - Local SITL CC R10 Pre-Review Group</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_R10_Pre_Review</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Owning_SITL_15_Day_Reminder</fullName>
        <description>AAT - Owning SITL - 15 Day Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Owning_SITL_15_Day_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAT_Pre_Review</fullName>
        <description>AAT - Pre-Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>App_Approval_Review_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>AAT_Pre_Reviewer_CC_Group</fullName>
        <description>AAT - Pre-Reviewer CC Group</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_Reviewer_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_SIO_5_Day_Reminder</fullName>
        <description>AAT - SIO - 5 Day Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_3__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Owning_SIO_5_Day_Reminder</template>
    </alerts>
    <alerts>
        <fullName>AAT_SIO_CC_Group</fullName>
        <description>AAT - SIO CC Group</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Approver_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Owning_SIO_CC_Group</template>
    </alerts>
    <alerts>
        <fullName>AAT_Send_to_Local_SITL</fullName>
        <description>AAT - Send to Local SITL</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Local_SITL_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>AAT_Send_to_OAR_Pre_reviewer</fullName>
        <description>AAT - Send to OAR Pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OAR</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>AAT_Send_to_Pre_Reviewer</fullName>
        <description>AAT - Send to Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>AAT_Sent_to_OEI_Pre_Reviewer</fullName>
        <description>AAT - Sent to OEI Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OEI</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>BAP_OHR_Submission_Confirmation</fullName>
        <description>BAP OHR Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BAP_Forms_OHR_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>BAP_Provisioning_Request_to_Jira</fullName>
        <ccEmails>jira@epabiac.atlassian.net</ccEmails>
        <description>BAP Provisioning Request to Jira</description>
        <protected>false</protected>
        <recipients>
            <recipient>king.roy@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_Provisioning_Request_Form_Approved_Jira</template>
    </alerts>
    <alerts>
        <fullName>BAP_Provisioning_User_Request_Completed</fullName>
        <description>BAP Provisioning User Request Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Technical_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>bap-support@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Approved_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>BAP_USer_Provisioning_Reminder</fullName>
        <description>BAP User Provisioning Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Request_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>BAP_User_Provisioning_Send_reminder_to_Approver_1</fullName>
        <description>BAP User Provisioning - Send reminder to Approver 1</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Reminder_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>BAP_User_Provisioning_Send_reminder_to_BAPM</fullName>
        <description>BAP User Provisioning - Send reminder to BAPM</description>
        <protected>false</protected>
        <recipients>
            <recipient>BAPM_Management</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Reminder_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>BAP_User_Provisioning_Send_reminder_to_BAP_Admin_Queue</fullName>
        <description>BAP User Provisioning - Send reminder to BAP Admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>BAP_Admins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Reminder_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>BAP_User_Provisioning_Send_reminder_to_FCO</fullName>
        <description>BAP User Provisioning - Send reminder to FCO</description>
        <protected>false</protected>
        <recipients>
            <recipient>SF182_AccessApproval</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Reminder_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>BAP_User_Provisioning_Send_reminder_to_Stephanie_Wood</fullName>
        <description>BAP User Provisioning - Send reminder to Stephanie Wood</description>
        <protected>false</protected>
        <recipients>
            <recipient>wood.stephanie2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/BAP_User_Provisioning_Reminder_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Dev_Sandbox_recalled</fullName>
        <description>Dev Sandbox recalled</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>lee.ron2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/Dev_Sandbox_Request_Recall_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>EPA_100_Submission_Confirmation</fullName>
        <description>EPA-100 Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EPA_100_Forms_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>EPA_3160_6v5_Leave_Bank_Approved</fullName>
        <description>EPA-3160-6v5 Leave Bank Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EPA_3160_6v5_Leave_Bank_Approved</template>
    </alerts>
    <alerts>
        <fullName>EPA_3160_6v5_Moving_to_Leave_Bank_Team</fullName>
        <description>EPA-3160-6v5 Moving to Leave Bank Team</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EPA_3160_6v5_Moving_to_Leave_Bank_Team</template>
    </alerts>
    <alerts>
        <fullName>Earned_Hours_Approved</fullName>
        <description>Earned Hours Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>User_Time_Keeper__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TCTO_Email_Templates/TCTO_Earned_Hours_Approved</template>
    </alerts>
    <alerts>
        <fullName>FinalApproval</fullName>
        <description>FinalApproval</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Email_Template_Approved_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Final_Approval_Email</fullName>
        <description>Final Approval Email</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>bap-support@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Forms_Final_Approval</template>
    </alerts>
    <alerts>
        <fullName>Final_Approval_Email_PN_Newspaper</fullName>
        <description>Final Approval Email Public Notice Newspaper Format</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>stokes.dionne2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_508_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_OCGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Public_Notice_Final_Approval_Newspaper_Format_Template</template>
    </alerts>
    <alerts>
        <fullName>Final_Approval_Email_Public_Notice_Webpage_Format</fullName>
        <description>Final Approval Email Public Notice Webpage Format</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>forman.debra2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Public_Notice_Final_Approval_Webpage_Format_Template</template>
    </alerts>
    <alerts>
        <fullName>Final_Approval_Email_Public_Notice_Webpagex_Format</fullName>
        <description>Final Approval Email Public Notice Webpage Format</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Approver_508_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Public_Notice_Final_Approval_Webpage_Format_Template</template>
    </alerts>
    <alerts>
        <fullName>Final_Rejection_Email</fullName>
        <description>Final Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Forms_Final_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Notify_Assigned_to_and_AO_for_Purchase_Card</fullName>
        <description>Notify Assigned to and AO for Purchase Card</description>
        <protected>false</protected>
        <recipients>
            <field>Approver_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Assigned_to__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Notify_Pending_Action_Purchase_Card</template>
    </alerts>
    <alerts>
        <fullName>OGE_450_Certification_Notification</fullName>
        <description>OGE-450 Certification Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>e450techsupport@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>OGE_450/OGE_450_Certification_Notification</template>
    </alerts>
    <alerts>
        <fullName>OGE_450_Confirmation_of_submission</fullName>
        <description>OGE-450 Confirmation of submission</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>e450techsupport@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>OGE_450/OGE_450_Confirmation_of_submission</template>
    </alerts>
    <alerts>
        <fullName>OGE_450_Your_Form_Requires_Changes_or_Clarification</fullName>
        <description>OGE-450 Your Form Requires Changes or Clarification</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>e450techsupport@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>OGE_450/OGE_450_Your_Form_Requires_Changes_or_Clarification</template>
    </alerts>
    <alerts>
        <fullName>OHR_Final_Approval_Email</fullName>
        <description>OHR - Final Approval Email</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/HR_System_Access_Request_Forms_Final_Approval</template>
    </alerts>
    <alerts>
        <fullName>OHR_Final_Rejection_Email</fullName>
        <description>OHR - Final Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Final_Rejection_Email</template>
    </alerts>
    <alerts>
        <fullName>OHR_Form_Approved_Security_Team_Notification</fullName>
        <description>OHR Form Approved - Security Team Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>HR_Access_Request_Security_Team</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Form_Approved_Security_Team_Notification</template>
    </alerts>
    <alerts>
        <fullName>OHR_Moving_to_PMO_RHRO</fullName>
        <description>OHR - Moving to PMO/RHRO</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Moving_to_PMO_RHRO</template>
    </alerts>
    <alerts>
        <fullName>OHR_Moving_to_Security_Team</fullName>
        <description>OHR - Moving to Security Team</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Moving_to_Security_Team</template>
    </alerts>
    <alerts>
        <fullName>OHR_Post_Approval_New_UserID_Notification</fullName>
        <description>OHR Post-Approval New User ID Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Post_Approval_Username_Notification</template>
    </alerts>
    <alerts>
        <fullName>OHR_Post_Approval_Temp_Password_Notification</fullName>
        <description>OHR Post-Approval Temp Password Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Post_Approval_Temp_Password_Notification</template>
    </alerts>
    <alerts>
        <fullName>OHR_Submission_Confirmation_prepared_for_another_user</fullName>
        <description>OHR Submission Confirmation (prepared for another user)</description>
        <protected>false</protected>
        <recipients>
            <field>Prepare_Form_for__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>OHR/OHR_Forms_Submission_Confirm_submitted_by_other_person</template>
    </alerts>
    <alerts>
        <fullName>ORD_111_Submission_Confirmation</fullName>
        <description>ORD-111 Submission Confirmation (prepared for another user)</description>
        <protected>false</protected>
        <recipients>
            <field>Prepare_Form_for__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ORD_111_Forms_Submission_Confirm_submitted_by_other_person</template>
    </alerts>
    <alerts>
        <fullName>Proposed_Hours_Approved</fullName>
        <description>Proposed Hours Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TCTO_Email_Templates/TCTO_Proposed_Hours_Approved</template>
    </alerts>
    <alerts>
        <fullName>Public_Notice_Posting_Submission_Confirmationx</fullName>
        <description>Public Notice Posting Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Public_Notice_Request_Forms_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Public_Notice_ReqPosting_Submission_Confirmation</fullName>
        <description>Public Notice Posting Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Public_Notice_Request_Forms_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Approved_Notice_to_PC_Team_for_Action</fullName>
        <description>Purchase Card Approved Notice to PC Team for Action</description>
        <protected>false</protected>
        <recipients>
            <recipient>bohles.debony2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>creed.suzette2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>guziewicz.thomas2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>long.brian2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lyles.dianne2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>robinson.latonya2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>scott.raoul2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>taylor.regina2@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Team_Action_Needed</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Approver_1_Approved_Notification</fullName>
        <description>Purchase Card Approver 1 Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Approved_by_Approver_1</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Approver_2_Approved_Notification</fullName>
        <description>Purchase Card Approver 2 Approved Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Approved_by_Approver_2</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Owner_Status_Update</fullName>
        <description>Purchase Card Owner Status Update</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Email_Template_PCTeam_Status_Update</template>
    </alerts>
    <alerts>
        <fullName>Purchase_Card_Team_Action_Completion_Notification</fullName>
        <description>Purchase Card Team Action Completion Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Team_Action_Completed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Reject_Request</fullName>
        <description>Reject Request</description>
        <protected>false</protected>
        <recipients>
            <field>Cardholder_AO_Name__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>oarm-oam-purchase_card_team@epa.gov</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Purchase_Card_Provisioning_Templates/Purchase_Card_Email_Template_Rejected_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>SF182_Generic_Submission_Confirmation</fullName>
        <description>SF182 Generic Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unauthenticated_Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/SF182_Forms_Generic_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>SF_182_Final_Approval_to_Funding_Official</fullName>
        <description>SF-182 Final Approval to Funding Official</description>
        <protected>false</protected>
        <recipients>
            <field>User_Funding_Official__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_182_Forms_Final_Approval_to_Funding_Official</template>
    </alerts>
    <alerts>
        <fullName>SF_182_Submission_Confirmation</fullName>
        <description>SF-182 Submission Confirmation (prepared for another user)</description>
        <protected>false</protected>
        <recipients>
            <field>Prepare_Form_for__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SF_182_Forms_Submission_Confirm_submitted_by_other_person</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Approved_Jira_Alert</fullName>
        <ccEmails>jira@epabiac.atlassian.net</ccEmails>
        <description>Sandbox Approved Jira Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>king.roy@epa.gov</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/Development_Sandbox_Request_Form_Approved_Jira</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Approved_Notification_Alert</fullName>
        <ccEmails>BAP_Admins@epa.gov</ccEmails>
        <description>Sandbox Approved Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Technical_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/Development_Sandbox_Request_Form_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Complete_Email_Notification</fullName>
        <ccEmails>BAP_Admins@epa.gov</ccEmails>
        <description>Sandbox Complete Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Technical_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/Development_Sandbox_Request_Form_Approved_Admin_Notification</template>
    </alerts>
    <alerts>
        <fullName>Sandbox_Rejection_Notification_Alert</fullName>
        <description>Sandbox Rejection Notification Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_on_Behalf_Of__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Technical_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BAP_Provisioning/Dev_Sandbox_Request_Rejected_Template</template>
    </alerts>
    <alerts>
        <fullName>Send_to_AO_pre_reviewer</fullName>
        <description>Send to AO pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_AO</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OARM_Pre_Reviewer</fullName>
        <description>Send to OARM Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OARM</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OCFO_Pre_Reviewer</fullName>
        <description>Send to OCFO Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OCFO</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OCSPP_Pre_review</fullName>
        <description>Send to OCSPP Pre-review</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OCSPP</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OECA_Pre_Reviewer</fullName>
        <description>Send to OECA Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OECA</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OGC_Pre_reviewer</fullName>
        <description>Send to OGC Pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OGC</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OIG_pre_reviewer</fullName>
        <description>Send to OIG pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OIG</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OITA_pre_reviewer</fullName>
        <description>Send to OITA pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OITA</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OLEM_Pre_reviewer</fullName>
        <description>Send to OLEM Pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OLEM</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_ORD_pre_approver</fullName>
        <description>Send to ORD pre-approver</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_ORD</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_OW_Pre_Reviewer</fullName>
        <description>Send to OW Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_OW</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R01_Pre_reviewer</fullName>
        <description>Send to R01 Pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R01</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R02_Pre_Reviewer</fullName>
        <description>Send to R02 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R02</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R03_Pre_Reviewer</fullName>
        <description>Send to R03 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R03</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R04_Pre_Reviewer</fullName>
        <description>Send to R04 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R04</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R05_Pre_Reviewer</fullName>
        <description>Send to R05 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R05</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R06_Pre_Reviewer</fullName>
        <description>Send to R06 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R06</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R07_Pre_Reviewer</fullName>
        <description>Send to R07 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R07</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R08_Pre_Reviewer</fullName>
        <description>Send to R08 Pre-Reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R08</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R09_Pre_reviewer</fullName>
        <description>Send to R09 Pre-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R09</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_to_R10_Pro_reviewer</fullName>
        <description>Send to R10 Pro-reviewer</description>
        <protected>false</protected>
        <recipients>
            <field>Application_Owner__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>App_Approval_R10</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AAT/AAT_Pre_review_Stage_Notification</template>
    </alerts>
    <alerts>
        <fullName>Submission_Confirmation</fullName>
        <description>Submission Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Unlicensed_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Forms_Submission_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>TCTO_Earned_Hours_Rejection</fullName>
        <description>TCTO Earned Hours Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TCTO_Email_Templates/TCTO_Request_Earned_Hours_Rejected</template>
    </alerts>
    <alerts>
        <fullName>TCTO_Proposed_Hours_Rejection</fullName>
        <description>TCTO Proposed Hours Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TCTO_Email_Templates/TCTO_Request_Proposed_Hours_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>ARPTool_Set_Step_Expect_Complete_Date</fullName>
        <field>Expected_Date_to_Complete_this_Step__c</field>
        <formula>IF(Application_Status__c = "1. Initiated", 
"n/a", 
IF(Application_Status__c = "2. Pre-Reviewer",
text(CASE( 
  MOD( (today()+3) - DATE( 1900, 1, 7 ), 7 ),
  6, (today()+3) + 2,
  0, (today()+3) +1,
  (today()+3)
)), 
IF(Application_Status__c = "3. Local SITL Review",
text(CASE( 
  MOD( (today()+4) - DATE( 1900, 1, 7 ), 7 ),
  6, (today()+4) + 2,
  0, (today()+4) +1,
  (today()+4)
)), 
IF(Application_Status__c = "4. Review Group Requested",
text(CASE( 
  MOD( (today()+5) - DATE( 1900, 1, 7 ), 7 ),
  6, (today()+5) + 2,
  0, (today()+5) +1,
  (today()+5)
)), 
IF(Application_Status__c = "5. Review Group Decides",
text(CASE(
       CASE(MOD(today()-DATE(1900,1,7),7),
       3,MOD((today()+14)-DATE(1900,1,7),7),
       4,MOD((today()+14)-DATE(1900,1,7),7),
       5,MOD((today()+14)-DATE(1900,1,7),7),
       MOD((today()+12)-DATE(1900,1,7),7)),
  6, (today()+12) + 2,
  0, (today()+12) +1,
  (today()+12)
)), 
IF(Application_Status__c = "6. Ready for Owning SIO to Write Up",
text(CASE( 
  MOD( (today()+5) - DATE( 1900, 1, 7 ), 7 ),
  6, (today()+5) + 2,
  0, (today()+5) +1,
  (today()+5)
)), 
"n/a"))))))</formula>
        <name>ARPTool - Set Step Expect Complete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARPTool_Set_Step_Start_Date</fullName>
        <field>Date_the_app_started_this_step__c</field>
        <formula>text(Today())</formula>
        <name>ARPTool - Set Step Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARPTool_Update_Days_in_Initiated</fullName>
        <field>Days_in_Initiated__c</field>
        <formula>IF( PRIORVALUE(Application_Status__c) = "8. Rejected",
Days_in_Initiated__c + (TODAY() - DATEVALUE(PRIORVALUE(Date_the_app_started_this_step__c))),
TODAY() - DATEVALUE(CreatedDate)
)</formula>
        <name>ARPTool - Update Days in Initiated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARPTool_Update_Days_in_Local_SITL_Rev</fullName>
        <field>Days_in_Local_SITL_Review__c</field>
        <formula>Days_in_Local_SITL_Review__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>ARPTool - Update Days in Local SITL Rev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARPTool_Update_Days_in_Pre_Reviewer</fullName>
        <field>Days_in_Pre_Reviewer__c</field>
        <formula>Days_in_Pre_Reviewer__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>ARPTool - Update Days in Pre-Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARP_Tool_Update_Days_in_Review_Grp_Dec</fullName>
        <field>Days_in_Review_Group_Decides__c</field>
        <formula>Days_in_Review_Group_Decides__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>ARP Tool - Update Days in Review Grp Dec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARP_Tool_Update_Days_in_Review_Grp_Req</fullName>
        <field>Days_in_Review_Group_Requested__c</field>
        <formula>Days_in_Review_Group_Requested__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>ARP Tool - Update Days in Review Grp Req</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ARP_Tool_Update_Days_in_SIO_to_WriteUP</fullName>
        <field>Days_in_Ready_for_Owning_SIO_to_Write_Up__c</field>
        <formula>Days_in_Ready_for_Owning_SIO_to_Write_Up__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>ARP Tool - Update Days in SIO to WriteUP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_508_Approval</fullName>
        <description>Update Status to 508 Approval Complete</description>
        <field>Form_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status 508 Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Initial_Submit</fullName>
        <field>Form_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Approval Status Initial Submit_PN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Supervisor_Approve_PN1</fullName>
        <field>Form_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Supervisor Approve PN_</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Approved</fullName>
        <field>Approval_Step__c</field>
        <formula>"Approved"</formula>
        <name>Approval Step - Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Awaiting_Approval_1</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Supervisor Approval For Proposed Hours"</formula>
        <name>Approval Step - Awaiting Approval 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Awaiting_Approval_2</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Supervisor Approval For Earned Hours"</formula>
        <name>Approval Step - Awaiting Approval 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Awaiting_Security_Team</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting OHR Security Team Approval"</formula>
        <name>Approval Step - Awaiting Security Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Certified</fullName>
        <field>Approval_Step__c</field>
        <formula>"Certified"</formula>
        <name>Approval Step - Certified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Local_SITL_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>"2. Local SITL Rejected"</formula>
        <name>Approval Step - Local SITL Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Owning_SIO_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>"4. Owning SIO Rejected"</formula>
        <name>Approval Step - Owning SIO Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Owning_SITL_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>"3. Owning SITL Rejected"</formula>
        <name>Approval Step - Owning SITL Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Pending_Earned_Hours</fullName>
        <field>Approval_Step__c</field>
        <formula>"Pending Earned Hours Entry"</formula>
        <name>Approval Step - Pending Earned Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Pre_Reviewer_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>"1. Pre-Reviewer Rejected"</formula>
        <name>Approval Step - Pre-Reviewer Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Prepared_As</fullName>
        <field>Approval_Step__c</field>
        <formula>IF( ISBLANK( Unauthenticated_Owner__c ), 
"Form Prepared for " &amp; Prepare_Form_for__r.FirstName  &amp; " " &amp; Prepare_Form_for__r.LastName &amp; " by " &amp;  CreatedBy.FirstName &amp;" "&amp; CreatedBy.LastName &amp;" - Not Submitted", 
"Form Prepared for " &amp; Prepare_Form_for__r.FirstName  &amp; " " &amp; Prepare_Form_for__r.LastName &amp; " by " &amp; Unauthenticated_Owner__r.FirstName &amp;" "&amp; Unauthenticated_Owner__r.LastName &amp;" - Not Submitted")</formula>
        <name>Approval Step - Prepared As</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Recalled</fullName>
        <field>Approval_Step__c</field>
        <formula>"Recalled"</formula>
        <name>Approval Step - Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Rejected</fullName>
        <field>Approval_Step__c</field>
        <formula>"Rejected"</formula>
        <name>Approval Step - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_AO</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting AO Approval"</formula>
        <name>Approval Step - Sent to AO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_DD</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Division Director/Manager Approval"</formula>
        <name>Approval Step - Sent to DD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Dup_Reviewer</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Duplication Reviewer Approval"</formula>
        <name>Approval Step - Sent to Dup Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Escalated_Apprvr</fullName>
        <field>Approval_Step__c</field>
        <formula>IF(  
OR(
   Escalate_to_Chief_Learning_Officer__c = true,
   Training_Start_Date__c &lt;= TODAY(),
   Direct_Cost_Total__c &gt; 25000,
   Indirect_Total__c &gt; 25000
  ),
"Awaiting Sharon Riding's Approval (Escalated Approver)",
"" )</formula>
        <name>Approval Step - Sent to Escalated Apprvr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Funding_Official</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Funding Official Approval"</formula>
        <name>Approval Step - Sent to Funding Official</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Leave_Bank_Team</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Leave Bank Team Approval"</formula>
        <name>Approval Step - Sent to Leave Bank Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Local_SITL</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Local SITL Approval"</formula>
        <name>Approval Step - Sent to Local SITL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver3</fullName>
        <description>ORD-111 checks for Additional Reviewer</description>
        <field>Approval_Step__c</field>
        <formula>IF( ISBLANK( Additional_Reviewer__c ) , 
"Awaiting QA Manager Approval", 
"Awaiting Additional Reviewer Approval")</formula>
        <name>Approval Step - Sent to Next Approver3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver4</fullName>
        <description>EPA-3160-6v5 checks Location field for next approver</description>
        <field>Approval_Step__c</field>
        <formula>"Awaiting " &amp; 
 TEXT(Employee_Location__c) &amp;
" Approval"</formula>
        <name>Approval Step - Sent to Next Approver4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Next_Approver_1</fullName>
        <field>Approval_Step__c</field>
        <formula>IF(RecordType.DeveloperName = "SF_182", 
IF( 
ispickval(of_Approval_Supervisors__c, "2"), 
"Awaiting Supervisor 2 Approval", 
"Awaiting Funding Official Approval"), 
"Awaiting Next Approver")</formula>
        <name>Approval Step - Sent to Next Approver1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Owning_SIO</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Owning SIO Approval"</formula>
        <name>Approval Step - Sent to Owning SIO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Owning_SITL</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Owning SITL Approval"</formula>
        <name>Approval Step - Sent to Owning SITL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_PCM</fullName>
        <description>approval step to send to the purchase card manager for review</description>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Purchase Card Manager Approval"</formula>
        <name>Approval Step - Sent to PCM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Pre_Reviewer</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Pre-Reviewer Approval"</formula>
        <name>Approval Step - Sent to Pre-reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_QA_Manager</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting QA Manager Approval"</formula>
        <name>Approval Step - Sent to QA Manager</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Queue_Approval</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting "&amp; TEXT( Approval_Routing_Options__c ) &amp;" Queue Approval"</formula>
        <name>Approval Step - Sent to Queue Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_SITL_Group</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting SITL Group Approval"</formula>
        <name>Approval Step - Sent to SITL Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_SITL_Reviewer</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting SITL Approval"</formula>
        <name>Approval Step - Sent to SITL Reviewer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Supervisor</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Supervisor Approval"</formula>
        <name>Approval Step - Supervisor Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Step_Sent_to_Timekeeper</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting Timekeeper Approval"</formula>
        <name>Approval Step - Sent to Timekeeper</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approve_OCGR_Step</fullName>
        <description>Update Step to OCGR Approval</description>
        <field>Approval_Step__c</field>
        <formula>"Form Approval Step: Sent to OCGR Approval"</formula>
        <name>Approve OCGR Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Awaiting_BAP_Admins</fullName>
        <description>Approval Step = Awaiting BAP Admins</description>
        <field>Approval_Step__c</field>
        <formula>"Awaiting BAP Admin Approval"</formula>
        <name>Awaiting BAP Admins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAPUser_Set_Approval_Step_to_Approver1</fullName>
        <description>BAP User Provisioning.</description>
        <field>Approval_Step__c</field>
        <formula>"Approved by Approver 1"</formula>
        <name>BAPUser -Set Approval Step to Approver1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAPUser_Set_Approval_Step_to_BAP_Admins</fullName>
        <description>BAP User Provisioning.</description>
        <field>Approval_Step__c</field>
        <formula>"BAP Admin"</formula>
        <name>BAPUser-Set Approval Step to BAP Admins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Application_Owner_Approval</fullName>
        <description>Approval Step - BAP Application Owner Approval</description>
        <field>Approval_Step__c</field>
        <formula>"Application Owner Approved"</formula>
        <name>BAP Application Owner Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Final_Approval</fullName>
        <field>Approval_Step__c</field>
        <formula>"Approved"</formula>
        <name>BAP Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Final_Rejection</fullName>
        <field>Approval_Step__c</field>
        <formula>"Rejected"</formula>
        <name>BAP Final Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Program_Approval</fullName>
        <description>Approval by the BAP Program Manager</description>
        <field>Approval_Step__c</field>
        <formula>"Pending Implementation"</formula>
        <name>BAP_Program Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_Request_Submitted_Step</fullName>
        <field>Approval_Step__c</field>
        <formula>"Submitted for Approval"</formula>
        <name>BAP Request Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_User_Recalled</fullName>
        <field>Approval_Step__c</field>
        <formula>"Recalled"</formula>
        <name>BAP User Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_User_Set_Approval_Step_to_SF182</fullName>
        <description>BAP User Provisioning.</description>
        <field>Approval_Step__c</field>
        <formula>"Approved by SF182"</formula>
        <name>BAP User- Set Approval Step to SF182</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BAP_User_Set_Approval_Step_to_Training</fullName>
        <description>BAP User Provisioning.</description>
        <field>Approval_Step__c</field>
        <formula>"Approved by Training Officer"</formula>
        <name>BAP User- Set Approval Step to Training</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_OCGR_Approver</fullName>
        <description>Set Default OCGR Approver</description>
        <field>Approver_OCGR__c</field>
        <lookupValue>patay.gabriel2@epa.gov</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Default OCGR Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Manager_Signature</fullName>
        <field>Immediate_Supervisor_s_Signature__c</field>
        <literalValue>1</literalValue>
        <name>Manager Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Date_Approved</fullName>
        <field>Date_Approved__c</field>
        <formula>TODAY()</formula>
        <name>OHR - Date Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Date_Expires</fullName>
        <field>Date_Expires__c</field>
        <formula>TODAY() + 366</formula>
        <name>OHR - Date Expires</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_New_UserID_Email_Sent_Date_Time</fullName>
        <description>After New User ID email is sent, this updates Email Sent info.</description>
        <field>New_UserID_Email_Sent__c</field>
        <formula>TEXT(NOW())</formula>
        <name>OHR New UserID Email Sent Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Security_Team_Signature</fullName>
        <field>OHR_Security_Team_Signature__c</field>
        <literalValue>1</literalValue>
        <name>OHR Security Team Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Set_Step_Start_Date</fullName>
        <field>Date_the_app_started_this_step__c</field>
        <formula>text(Today())</formula>
        <name>OHR - Set Step Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Temp_Password_Email_Sent_Date_Time</fullName>
        <description>After Temporary Password email is sent, this updates Email Sent info.</description>
        <field>Temporary_Password_Email_Sent__c</field>
        <formula>TEXT(NOW())</formula>
        <name>OHR Temp Password Email Sent Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Uncheck_Send_Password_Email</fullName>
        <description>After New User ID email is sent, this updates field back to false.</description>
        <field>SendTempPasswordEmail__c</field>
        <literalValue>0</literalValue>
        <name>OHR Uncheck Send Password Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Uncheck_Send_User_ID_Email</fullName>
        <description>After New User ID email is sent, this updates field back to false.</description>
        <field>SendUserIDEmail__c</field>
        <literalValue>0</literalValue>
        <name>OHR Uncheck Send User ID Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Update_Days_in_OHR_Security_Queue</fullName>
        <field>Days_in_OHR_Security_Queue__c</field>
        <formula>Days_in_OHR_Security_Queue__c  + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>OHR - Update Days in OHR Security Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Update_Days_in_PMO_RHRO_Queue</fullName>
        <field>Days_in_PMO_RHRO_Queue__c</field>
        <formula>Days_in_PMO_RHRO_Queue__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>OHR - Update Days in PMO/RHRO Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OHR_Update_Days_in_Supervisor_Queue</fullName>
        <field>Days_in_Supervisor_Queue__c</field>
        <formula>Days_in_Supervisor_Queue__c + (TODAY() - DATEVALUE( PRIORVALUE(Date_the_app_started_this_step__c)))</formula>
        <name>OHR - Update Days in Supervisor Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PMO_RHRO_Signature</fullName>
        <field>PMO_RHRO_Signature__c</field>
        <literalValue>1</literalValue>
        <name>PMO/RHRO Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Confirmation</fullName>
        <description>Pending Confirmation</description>
        <field>Approval_Step__c</field>
        <formula>"Pending Confirmation"</formula>
        <name>Pending Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_FCO_Confirmation</fullName>
        <description>Pending FCO Confirmation</description>
        <field>Approval_Step__c</field>
        <formula>"Pending FCO Confirmation"</formula>
        <name>Pending FCO Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_Implementation2</fullName>
        <description>Pending Implementation</description>
        <field>Approval_Step__c</field>
        <formula>"Pending Implementation"</formula>
        <name>Pending Implementation2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_implementation</fullName>
        <field>Approval_Step__c</field>
        <name>Pending implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Remove_Manager_Signature</fullName>
        <field>Immediate_Supervisor_s_Signature__c</field>
        <literalValue>0</literalValue>
        <name>Rejection - Remove Manager Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Remove_PMO_RHRO_Signature</fullName>
        <field>PMO_RHRO_Signature__c</field>
        <literalValue>0</literalValue>
        <name>Rejection - Remove PMO/RHRO Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_to_508_Tech_Review</fullName>
        <description>Sent to Division 508 Technical Review of Documents</description>
        <field>Approval_Step__c</field>
        <formula>"Awaiting 508 Tech Approval"</formula>
        <name>Approval Step  508 Tech Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_508_Approver</fullName>
        <description>Set Defaut 508 Approver</description>
        <field>Approver_508_Reviewer__c</field>
        <lookupValue>patay.gabriel2@epa.gov</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Default 508 Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Earned_Hours_Total</fullName>
        <field>Earned_Travel_Comp_Hours_Total__c</field>
        <formula>Proposed_Travel_Comp_Hours_Total__c</formula>
        <name>Set Earned Hours Total</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_to_Submitted_for_Approval</fullName>
        <description>Update to submitted for approval</description>
        <field>Form_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Status Update to Submitted for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_to_Approved</fullName>
        <field>Form_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Status Updated to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_to_Recalled</fullName>
        <field>Form_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Status Updated to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Updated_to_Rejected</fullName>
        <field>Form_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status Updated to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TCTO_Request_Earned_Hours_Approved</fullName>
        <field>TCTO_Request_Type__c</field>
        <literalValue>Earned Hours Approved</literalValue>
        <name>TCTO Request: Earned Hours Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TCTO_Status_Proposed_Hours_approved</fullName>
        <field>TCTO_Approval_Status__c</field>
        <literalValue>Approved (Proposed Hours)</literalValue>
        <name>TCTO Status - Proposed Hours approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TCTO_Type_Earned_Request</fullName>
        <field>TCTO_Request_Type__c</field>
        <literalValue>Earned Hours Request</literalValue>
        <name>TCTO Type - Earned Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TCTO_Type_Proposed_Hours_Approved</fullName>
        <field>TCTO_Request_Type__c</field>
        <literalValue>Earned Hours</literalValue>
        <name>TCTO Type - Proposed Hours Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dest_to_Integrate</fullName>
        <description>Updates the environment in the BAP deployment form, 2018.06.27</description>
        <field>Deployment_Destination__c</field>
        <literalValue>Integrate</literalValue>
        <name>Update Dest to Integrate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dest_to_Prod</fullName>
        <description>Updates the environment in the BAP deployment form, 2018.06.27</description>
        <field>Deployment_Destination__c</field>
        <literalValue>Production</literalValue>
        <name>Update Dest to Prod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Dest_to_Staging</fullName>
        <description>Updates the environment in the BAP deployment form, 2018.06.27</description>
        <field>Deployment_Destination__c</field>
        <literalValue>Staging</literalValue>
        <name>Update Dest to Staging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Step_to_Integrate</fullName>
        <description>Updates the Approval Step in the BAP deployment form, 2018.06.27</description>
        <field>Approval_Step__c</field>
        <formula>"Deployed to Integrate"</formula>
        <name>Update Step to Integrate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Prod</fullName>
        <description>Updates the Approval Step in the BAP deployment form, 2018.06.27</description>
        <field>Approval_Step__c</field>
        <formula>"Deployed to Prod"</formula>
        <name>Update to Prod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Staging</fullName>
        <description>Updates the Approval Step in the BAP deployment form, 2018.06.27</description>
        <field>Approval_Step__c</field>
        <formula>"Deployed to Staging"</formula>
        <name>Update to Staging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Waiver_Auth_Signature</fullName>
        <field>Waiver_Authorized_Signature__c</field>
        <literalValue>1</literalValue>
        <name>Waiver Auth Signature</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_1st_Approver</fullName>
        <field>Approval_Step__c</field>
        <formula>if(AND(CONTAINS(Intermediate_Review_Method__c, "1st Line Supervisor"),NOT(Supervisor_Approved__c)),"Awaiting 1st Line Supervisor Approval",
if(AND(CONTAINS(Intermediate_Review_Method__c, "2nd Line Supervisor"),NOT(Supervisor_2_Approved__c)),"Awaiting 2nd Line Supervisor Approval",
if(AND(CONTAINS(Intermediate_Review_Method__c, "ADEO only"),NOT(ADEO_Approved__c)),
"Awaiting ADEO Approval","Awaiting DEO Approval")))</formula>
        <name>e450 - 1st Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_2nd_Approver</fullName>
        <field>Approval_Step__c</field>
        <formula>if(CONTAINS(Intermediate_Review_Method__c, "organization's ADEO"),"Awaiting ADEO Approval", 
"Awaiting DEO Approval")</formula>
        <name>e450 - 2nd Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_ADEO_Approved</fullName>
        <field>ADEO_Approved__c</field>
        <literalValue>1</literalValue>
        <name>e450 - ADEO Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Clear_ADEO_Approved</fullName>
        <field>ADEO_Approved__c</field>
        <literalValue>0</literalValue>
        <name>e450 - Clear ADEO Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Clear_Supervisor_2_Approved</fullName>
        <field>Supervisor_2_Approved__c</field>
        <literalValue>0</literalValue>
        <name>e450 - Clear Supervisor 2 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Clear_Supervisor_Approved</fullName>
        <field>Supervisor_Approved__c</field>
        <literalValue>0</literalValue>
        <name>e450 - Clear Supervisor Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Send_to_DEO</fullName>
        <field>Approval_Step__c</field>
        <formula>"Awaiting DEO Approval"</formula>
        <name>e450 - Send to DEO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Set_Step_Start_Date</fullName>
        <field>Date_Ethics_Filing_Entered_Approval_Step__c</field>
        <formula>TODAY()</formula>
        <name>e450 - Set Step Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Supervisor_2_Approved</fullName>
        <field>Supervisor_2_Approved__c</field>
        <literalValue>1</literalValue>
        <name>e450 - Supervisor 2 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>e450_Supervisor_Approved</fullName>
        <field>Supervisor_Approved__c</field>
        <literalValue>1</literalValue>
        <name>e450 - Supervisor Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ARP Tool - Local SITL - 4 Day Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Review Process Tool</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Awaiting Local SITL Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAT_Local_SITL_4_Day_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ARP Tool - Owning SIO Reminder - 5 Day Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Review Process Tool</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Awaiting Owning SIO Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAT_SIO_5_Day_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ARP Tool - Owning SITL - 15 Day Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Application Review Process Tool</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Awaiting Owning SITL Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AAT_Owning_SITL_15_Day_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ARP Tool - Update Day in Review Grp Req</fullName>
        <actions>
            <name>ARP_Tool_Update_Days_in_Review_Grp_Req</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName="Application_Review_Process_Tool", PRIORVALUE(Application_Status__c) = "4. Review Group Requested", Application_Status__c = "5. Review Group Decides", ISCHANGED(Application_Status__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ARP Tool Set Step Deadlines</fullName>
        <actions>
            <name>ARPTool_Set_Step_Expect_Complete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ARPTool_Set_Step_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  RecordType.DeveloperName = 'Application_Review_Process_Tool',  OR(ISCHANGED(Approval_Step__c),     ISCHANGED(Review_Group_Established__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>BAP User Provisioning - Send reminder to Approver 1</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BAP User Provisioning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Form_Type__c</field>
            <operation>equals</operation>
            <value>Permission Set</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Submitted for Approval</value>
        </criteriaItems>
        <description>Bap User Provisioning. Send reminder mail to Approver 1.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_Approver_1</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_Approver_1</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BAP User Provisioning - Send reminder to BAP</fullName>
        <active>true</active>
        <booleanFilter>((1 AND 2) AND (( 3 AND 4) OR (5 AND 6)))</booleanFilter>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BAP User Provisioning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Form_Type__c</field>
            <operation>equals</operation>
            <value>Starter User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Role__c</field>
            <operation>equals</operation>
            <value>Training Officer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Approved by Training Officer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Role__c</field>
            <operation>equals</operation>
            <value>FCO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Approved by SF182</value>
        </criteriaItems>
        <description>Bap User Provisioning. Send reminder mail to BAP.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_BAP_Admin_Queue</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_BAP_Admin_Queue</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BAP User Provisioning - Send reminder to BAP Admin</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BAP User Provisioning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Form_Type__c</field>
            <operation>equals</operation>
            <value>Permission Set</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Approved by Approver 1</value>
        </criteriaItems>
        <description>Bap User Provisioning. Send reminder mail to Bap Admin when they are current approvers.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_BAP_Admin_Queue</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_BAP_Admin_Queue</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BAP User Provisioning - Send reminder to BAPM</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BAP User Provisioning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Form_Type__c</field>
            <operation>equals</operation>
            <value>Starter User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Role__c</field>
            <operation>notEqual</operation>
            <value>FCO,Training Officer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Pending Confirmation</value>
        </criteriaItems>
        <description>Bap User Provisioning. Send reminder mail to BAPM.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_BAPM</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_BAPM</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BAP User Provisioning - Send reminder to FCO</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BAP User Provisioning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Form_Type__c</field>
            <operation>equals</operation>
            <value>Starter User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Role__c</field>
            <operation>equals</operation>
            <value>FCO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Pending Confirmation</value>
        </criteriaItems>
        <description>Bap User Provisioning. Send reminder mail to FCO.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_FCO</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_FCO</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BAP User Provisioning - Send reminder to Training Officer</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>BAP User Provisioning</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Form_Type__c</field>
            <operation>equals</operation>
            <value>Starter User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Role__c</field>
            <operation>equals</operation>
            <value>Training Officer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.Approval_Step__c</field>
            <operation>equals</operation>
            <value>Pending Confirmation</value>
        </criteriaItems>
        <description>Bap User Provisioning. Send reminder mail to FCO.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_Stephanie_Wood</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>BAP_User_Provisioning_Send_reminder_to_Stephanie_Wood</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>OHR - Send Password Email</fullName>
        <actions>
            <name>OHR_Post_Approval_Temp_Password_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>OHR_Temp_Password_Email_Sent_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OHR_Uncheck_Send_Password_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(   ISCHANGED(Temporary_Password__c),   RecordType.DeveloperName = 'HR_System_Access_Request' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OHR - Send Username Email</fullName>
        <actions>
            <name>OHR_Post_Approval_New_UserID_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>OHR_New_UserID_Email_Sent_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OHR_Uncheck_Send_User_ID_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(New_UserID__c), RecordType.DeveloperName = 'HR_System_Access_Request' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Purchase Card Assigned to Notification</fullName>
        <actions>
            <name>Notify_Assigned_to_and_AO_for_Purchase_Card</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Forms__c.Assigned_to__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Purchase Card: Cancellation Check or Card,Purchase Card: Change Cardholder AO,Purchase Card: Change Contact Information,Purchase Card: Change Monthly Limit,Purchase Card: Change Name on Card/Check,Purchase Card: Change Suspension of Card/Check</value>
        </criteriaItems>
        <criteriaItems>
            <field>Forms__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Purchase Card: New Approving Official (AO),Purchase Card: New Convenience Check,Purchase Card: New Purchase Card</value>
        </criteriaItems>
        <description>sends email notification to Assigned to and Approving Official for purchase card provisioning when the assigned to is entered</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Purchase Card Team Action Completed Notification</fullName>
        <actions>
            <name>Purchase_Card_Team_Action_Completion_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Forms__c.Form_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
