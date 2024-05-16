/**
 * @description       : Update Signature Request Status
 * @author            : Simon Persenot
 * @group             : 
 * @last modified on  : 07-12-2023
 * @last modified by  : Simon Persenot
 * @testCoverage      : YS_WebhookDispatcher_Test
**/
public without sharing class YS_SignatureRequestService {

    /**
    * @description update signature request status if it is not an obsolete message
    * @author Simon Persenot | 07-12-2023 
    * @param status 
    * @param srId 
    * @param eventTime 
    **/
    public static void newEvent(String status, String srId, Datetime eventTime)
    {
        YS_SignatureRequest__c sr = [SELECT Id, Status__c, LastEventDate__c FROM YS_SignatureRequest__c WHERE ExternalId__c = :srId LIMIT 1];
        if (sr.LastEventDate__c == null || sr.LastEventDate__c < eventTime)
        {
            sr.Status__c = status;
            sr.LastEventDate__c = eventTime;
            update sr;
        }
    }
}