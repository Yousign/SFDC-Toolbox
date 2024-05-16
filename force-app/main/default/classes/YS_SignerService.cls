/**
 * @description       : Update Signer Status
 * @author            : Simon Persenot
 * @group             : 
 * @last modified on  : 07-12-2023
 * @last modified by  : Simon Persenot
 * @testCoverage      : YS_WebhookDispatcher_Test
**/
public without sharing class YS_SignerService {

    /**
    * @description update signer status if it is not an obsolete message
    * @author Simon Persenot | 07-12-2023 
    * @param status 
    * @param signerId 
    * @param eventTime 
    **/
    public static void newEvent(String status, String signerId, Datetime eventTime)
    {
        YS_Signer__c signer = [SELECT Id, Status__c, LastEventDate__c FROM YS_Signer__c WHERE ExternalId__c = :signerId LIMIT 1];
        if (signer.LastEventDate__c == null || signer.LastEventDate__c < eventTime)
        {
            signer.Status__c = status;
            signer.LastEventDate__c = eventTime;
            update signer;
        }
    }
}