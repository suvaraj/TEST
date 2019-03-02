/*      
        Type        :        Class
        Name        :        EmailNotificationHelper
        Purpose     :        BSD-1037 Undecided Wave email notification helper method
        Author      :        Shradha - Mindtree Dev Team
*/
public without sharing class EmailNotificationHelper {
    //List of users to which email is sent
    public static List<String> listofUsersToEmail;
    //Email template from where template is fetched
    public static List<EmailTemplate> emailTemplateList;
    //Contract Owner to whom mail is sent
    public static User contractOwner;
    //Contact to set into Target Object
    public static Contact contact;

    //This method will send email notification when a contract is finalized, which has a waveSessionLineItem with a TBD wave 
    public static void sendEmailForUndecidedWave(Contract contract, List<WaveSessionLineItem__c> waveSessionLineItemList){
        try{
            if(!waveSessionLineItemList.isEmpty()){             

                listofUsersToEmail = new List<String>(TBDWaveNotifierEmail__c.getAll().keySet());  

                contractOwner = [SELECT Email FROM User WHERE IsActive = true And Id = : contract.OwnerId  LIMIT 1];

                emailTemplateList = [SELECT Id FROM EmailTemplate WHERE Name='TBD Wave Email Notification'];
                                
                contact = [SELECT Id FROM Contact WHERE Email != null And IsEmailBounced != true LIMIT 1];
                
                List<Messaging.SingleEmailMessage> TBDWaveEmailList = new List<Messaging.SingleEmailMessage>();
                                            
                for(WaveSessionLineItem__c waveSessionLineItem : waveSessionLineItemList){
                    Messaging.SingleEmailMessage TBDWaveEMail = new Messaging.SingleEmailMessage();
                    if(!emailTemplateList.isEmpty()){
                        TBDWaveEMail.setTemplateID(emailTemplateList[0].Id);
                    }
                    if(!listofUsersToEmail.isEmpty()){
                        TBDWaveEMail.setToAddresses(listofUsersToEmail);
                    }                   
                    if(contact!=null){
                        TBDWaveEMail.setTargetObjectId(contact.Id);
                    }
                    if(contractOwner!=null){
                        TBDWaveEMail.setCCAddresses(new String[] {contractOwner.Email});
                    }                   
                    TBDWaveEMail.setWhatId(waveSessionLineItem.Id);
                    TBDWaveEMail.setTreatTargetObjectAsRecipient(false);                    
                    TBDWaveEmailList.add(TBDWaveEMail);
                }
                
                //Sending mails in bulk.
                if(!TBDWaveEmailList.isEmpty())//&& !Test.isRunningTest()
                    Messaging.sendEmail(TBDWaveEmailList);
            }
        }
        catch(Exception exp){
               ErrorLogHelper.captureException(exp,contract.id,'EmailNotificationHelper');
        }
    }
    /*  
        Type        :   Method    
        Return Type :   Void
        Arugements  :   List<EmailConfigData>   
        Name        :   sendEmails
        Purpose     :   This method will construct the simple mail messages based on EmailConfigData and send them in bulk.
    */ 
  /*  public static void sendEmails(List<EmailConfigData> emailConfigDatas){    
        try{
            if(!emailConfigDatas.isEmpty()){
                Set<String> eMailTemplateNames = new Set<String>();
                Map<String, EmailTemplate> emailTemplateMap = new Map<String, EmailTemplate>();
                
                for(EmailConfigData emailConfigData : emailConfigDatas){
                    eMailTemplateNames.add(emailConfigData.eMailTemplateName);
                }
                
                List<OrgWideEmailAddress> owEmailAddress = [SELECT Id, Address FROM OrgWideEmailAddress limit 1];
                
                for(EmailTemplate emailTemplate : [SELECT Id, Name FROM EmailTemplate WHERE Name IN :eMailTemplateNames]){
                    emailTemplateMap.put(emailTemplate.Name, emailTemplate);
                }
                
                List<Messaging.SingleEmailMessage> eMailList = new List<Messaging.SingleEmailMessage>();
                for(EmailConfigData emailConfigData : emailConfigDatas){                
                    if(emailConfigData != null){    
                        Messaging.SingleEmailMessage eMail = new Messaging.SingleEmailMessage();
                        
                        if(emailTemplateMap.containsKey(emailConfigData.eMailTemplateName))
                            eMail.setTemplateID(emailTemplateMap.get(emailConfigData.eMailTemplateName).Id);
                        
                        if(!owEmailAddress.isEmpty())
                             eMail.setOrgWideEmailAddressId(owEmailAddress[0].Id);
                        
                        if(emailConfigData.toEmailAddress != null && emailConfigData.toEmailAddress != '')                        
                            eMail.setToAddresses(emailConfigData.toEmailAddress.Split(';'));
                        
                        if(emailConfigData.ccEmailAddress != null && emailConfigData.ccEmailAddress != '')
                            eMail.setCcAddresses(emailConfigData.ccEmailAddress.Split(';'));
                                    
                        if(emailConfigData.bccEmailAddress != null && emailConfigData.bccEmailAddress != '')        
                            eMail.setBccAddresses(emailConfigData.bccEmailAddress.Split(';'));
                        
                        if(emailConfigData.whatId != null && emailConfigData.whatId != '')
                            eMail.setWhatId(emailConfigData.whatId);
                            
                        if(emailConfigData.targetObjectId != null && emailConfigData.targetObjectId != '')
                            eMail.setTargetObjectId(emailConfigData.targetObjectId);
                        
                        if(emailConfigData.blockEmailToTarget != null)                  
                            eMail.setTreatTargetObjectAsRecipient(!emailConfigData.blockEmailToTarget);
                            
                        if(emailConfigData.mailAttachmentRequired != null && emailConfigData.mailAttachmentRequired && emailConfigData.mailAttachmentParentId != null){
                            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                            for (Attachment fa : [select Name, Body, BodyLength from Attachment where ParentId = : emailConfigData.mailAttachmentParentId]){
                                // Add to attachment file list
                                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                                efa.setFileName(fa.Name);
                                efa.setBody(fa.Body);
                                fileAttachments.add(efa);
                            }
                            eMail.setFileAttachments(fileAttachments);
                        }
                        eMailList.add(eMail);                       
                    }
                }
                //Sending mails in bulk.
                if(!eMailList.isEmpty())
                    Messaging.sendEmail(eMailList);
            }
        }catch(Exception exp){
               ErrorLogHelper.captureConfigException(exp,'EmailNotificationHelper');
        }
    }   
        
    public class EmailConfigData{       
        public String eMailTemplateName;
        public String bccEmailAddress;
        public String whatId;
        public String targetObjectId;
        public String ccEmailAddress;
        public String toEmailAddress;
        public Boolean blockEmailToTarget;
        public Boolean mailAttachmentRequired;
        public String mailAttachmentParentId;
    }
    */
}