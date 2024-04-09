---
title: test
---
<SwmSnippet path="/EmailNotificationHelper.cls" line="7">

---

&nbsp;

```apex
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
```

---

</SwmSnippet>

<SwmMeta version="3.0.0" repo-id="Z2l0aHViJTNBJTNBVEVTVCUzQSUzQXN1dmFyYWo=" repo-name="TEST"><sup>Powered by [Swimm](https://app.swimm.io/)</sup></SwmMeta>
