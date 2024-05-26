/**
 * @description       : Update Signature Request Status
 * @author            : Simon Persenot
 * @group             : 
 * @last modified on  : 07-12-2023
 * @last modified by  : Simon Persenot
 * @testCoverage      : YS_WebhookDispatcher_Test
**/
public with sharing class YS_SignatureRequestService {

    /**
    * @description update signature request status if it is not an obsolete message
    * @author Simon Persenot | 07-12-2023 
    * @param status 
    * @param srId 
    * @param eventTime 
    **/
    public static void newEvent(YS_WebhookListener.WebhookPayload payload, Datetime eventTime)
    {
        YS_event__e e = new YS_Event__e(
            Type__c = payload.event_name,
            Status__c = payload.data.signature_request.status,
            RecordId__c = payload.data.signature_request.id,
            Datetime__c = eventTime
        );
        if (Test.isRunningTest())
        {
            insert new Task(
                Subject = 'YS_SignatureRequestService.newEventDebug',
                Description = e.Type__c + '|' + e.Status__c + '|' + e.RecordId__c + '|' + e.Datetime__c
            );
        }
        
        EventBus.publish(new List<YS_Event__e> { e });
    }
}