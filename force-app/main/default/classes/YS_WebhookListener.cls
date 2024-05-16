/**
 * @description       : Class called by the webhook on Yousign
 * @author            : Simon Persenot
 * @group             : 
 * @last modified on  : 13-12-2023
 * @last modified by  : Simon Persenot
 * @testCoverage      : YS_WebhookListener_Test
**/
@RestResource(urlMapping='/ys/webhooks')
global with sharing class YS_WebhookListener {
    @testVisible
    private static final String CLASS_NAME = 'YS_WebhookListener';
    
    /**
    * @description Verify the validity of the data given. If valid manage treatment in a future call.
    * @author Simon Persenot | 12-12-2023 
    **/
    @httpPost
    global static void doPost()
    {
        /*
            From Documentation (https://developers.yousign.com/docs/use-webhooks-in-your-app)
            Be aware that if you send a 2XX or 3XX HTTP response after our timeout,
            it will also be considered as a failure and therefore can lead to trigger auto-retry.
            To avoid this issue, you should quickly acknowledge reception of the Webhook and operate
            any time-consuming processing asynchronously.
        */

        RestResponse response = RestContext.response;
        try {
            Blob bodyRequest = RestContext.request.requestBody;
            String signature256 = RestContext.request.headers.containsKey('X-Yousign-Signature-256') ? RestContext.request.headers.get('X-Yousign-Signature-256') : RestContext.request.headers.get('x-yousign-signature-256');
            Blob mac = Crypto.generateMac('HmacSHA256', bodyRequest, Blob.valueOf(YS_Service.getEncodingKey()));
            Boolean verified = 'sha256=' + EncodingUtil.convertToHex(mac) == signature256;
            // if signature couldn't be identified
            if (!verified)
            {
                response.statusCode = 403;
                response.responseBody = Blob.valueOf('Signature could not be verified.');
                return;
            }
            String bodyString = bodyRequest.toString();
            WebhookPayload payload = (WebhookPayload) JSON.deserialize(bodyString, WebhookPayload.class);
            payload.checkValidity();
            YS_WebhookDispatcher.dispatchWebhooks(bodyString);
            response.statusCode = 202;
            response.responseBody = Blob.valueOf('Message received! It will be treated asynchronously.');
        }
        catch (Exception e) {
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(e.getMessage());

            // Errors can also be monitored in the Yousign API Webhooks Logs
            // ! AS LONG AS THE YS_Utils CLASS IS NOT CUSTOMIZED, THE FOLLOWING LINE DO NOTHING
            YS_Utils.insertExceptionsAsLogs(new List<YS_Utils.WrappedException> { new YS_Utils.WrappedException(e, CLASS_NAME) }, true);
        }
    }

    // ============================================================
    // ========               DATA STRUCTURE               ========
    // ============================================================
    global class WebhookPayload extends YS_Utils.DataValidationAbstract
    {
        global String event_id;
        global String event_name;
        global String event_time;
        global String subscription_id;
        global String subscription_description;
        global Boolean sandbox;
        global WebhookPayloadData data;

        public void checkValidity()
        {
            super.checkValidity(
                new Set<String>{ 'event_id', 'event_name', 'event_time', 'subscription_id', 'subscription_description', 'sandbox', 'data' },
                'WebhookPayload'
            );
        }
    }

    global class WebhookPayloadData
    {
        global ExternalService.YS_SignatureRequest signature_request;
        global ExternalService.YS_Signer signer;
        global ExternalService.YS_Approver approver;
        global ExternalService.YS_Contact contact;
    }
}