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
                    YS_SignatureRequestService.newEvent(payload.data.signature_request.status, payload.data.signature_request.id, eventTime);
                }
                when 'signer' {
                    YS_SignerService.newEvent(payload.data.signer.status, payload.data.signer.id, eventTime);
                }
                when else {
                    // do nothing as :
                    // - contact updates are not used in our implementation
                    // - approvers are not used in our implementation
                    // - electronic seals are not used in our implementation
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