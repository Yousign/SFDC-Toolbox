/**
 * @description       : Dispatch events to the service classes
 * @author            : Simon Persenot
 * @group             : 
 * @last modified on  : 07-12-2023
 * @last modified by  : Simon Persenot
 * @testCoverage      : YS_WebhookDispatcher_Test
**/
public with sharing class YS_WebhookDispatcher {

    /**
    * @description Dispatch event to the correct service given a webhook payload
    * @author Simon Persenot | 07-12-2023 
    * @param payload 
    **/
    @future
    public static void dispatchWebhooks(String unparsedPayload) {
        try {
            YS_WebhookListener.WebhookPayload payload = (YS_WebhookListener.WebhookPayload) JSON.deserialize(unparsedPayload, YS_WebhookListener.WebhookPayload.class);
            String eventType = payload.event_name.split('\\.')[0];
            Datetime eventTime = Datetime.newInstance(Long.valueOf(payload.event_time + '000'));
            switch on eventType {
                when 'signature_request' {
                    YS_SignatureRequestService.newEvent(payload, eventTime);
                }
                when 'signer' {
                    YS_SignerService.newEvent(payload, eventTime);
                }
                when else {
                    // - contact updates 
                    // - approvers 
                    // - electronic seals
                    // not done
                    return;
                }
            }
        }
        catch (Exception e)
        {
            YS_Utils.insertExceptionsAsLogs(new List<YS_Utils.WrappedException> { new YS_Utils.WrappedException(e, 'YS_WebhookDispatcher') }, false);
        }
    }
}