@IsTest
public with sharing class YS_WebhookListener_Test {
    
    @isTest
    private static void test202() {
        // data setup
        String testName = 'test202';
        
        // Set global configuration
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        orgDefault.YS_EncodingKey__c = 'myEncodingKey';
        upsert orgDefault;

        // create SR in SF
        insert YS_DataTestFactory.createSignatureRequest();

        // endpoint
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/ys/webhooks';
        RestContext.request.httpMethod = 'POST';
        // body
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signature_request');
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(payload));
        // construct header
        String sha256 = 'sha256=' + EncodingUtil.convertToHex(Crypto.generateMac('HmacSHA256', RestContext.request.requestBody, Blob.valueOf(YS_Service.getEncodingKey())));
        RestContext.request.headers.put('X-Yousign-Signature-256', sha256);

        RestContext.response = new RestResponse();
    
        // Actual test
        Test.startTest();
        YS_WebhookListener.doPost();
        Test.stopTest();
    
        // Asserts
        Assert.areEqual(202, RestContext.response.statusCode, testName + ' #2 > Unexpected reponse status code');
    }
    
    @isTest
    private static void test403() {
        // data setup
        String testName = 'test403';
        
        // Set global configuration
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        orgDefault.YS_EncodingKey__c = 'myEncodingKey';
        upsert orgDefault;

        // create SR in SF
        insert YS_DataTestFactory.createSignatureRequest();

        // endpoint
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/ys/webhooks';
        RestContext.request.httpMethod = 'POST';
        // body
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signature_request');
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(payload));
        // construct header
        String sha256 = 'sha256=' + EncodingUtil.convertToHex(Crypto.generateMac('HmacSHA256', RestContext.request.requestBody, Blob.valueOf('badEncodingKey')));
        RestContext.request.headers.put('X-Yousign-Signature-256', sha256);

        RestContext.response = new RestResponse();
    
        // Actual test
        Test.startTest();
        YS_WebhookListener.doPost();
        Test.stopTest();
    
        // Asserts
        Assert.areEqual(403, RestContext.response.statusCode, testName + ' #2 > Unexpected reponse status code');
    }
    
    @isTest
    private static void test400() {
        // data setup
        String testName = 'test400';
        
        // Set global configuration
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        orgDefault.YS_EncodingKey__c = 'myEncodingKey';
        upsert orgDefault;

        // create SR in SF
        insert YS_DataTestFactory.createSignatureRequest();

        // endpoint
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/ys/webhooks';
        RestContext.request.httpMethod = 'POST';
        // body
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signature_request');
        payload.event_name = null; // should throw an Error cause mandatory
        RestContext.request.requestBody = Blob.valueOf(JSON.serialize(payload));
        // construct header
        String sha256 = 'sha256=' + EncodingUtil.convertToHex(Crypto.generateMac('HmacSHA256', RestContext.request.requestBody, Blob.valueOf(YS_Service.getEncodingKey())));
        RestContext.request.headers.put('X-Yousign-Signature-256', sha256);

        RestContext.response = new RestResponse();
    
        // Actual test
        Test.startTest();
        YS_WebhookListener.doPost();
        Test.stopTest();
    
        // Asserts
        Assert.areEqual(400, RestContext.response.statusCode, testName + ' #2 > Unexpected reponse status code');
    }
}