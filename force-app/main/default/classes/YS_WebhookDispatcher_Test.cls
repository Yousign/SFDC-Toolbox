@IsTest
public with sharing class YS_WebhookDispatcher_Test {

    @isTest
    private static void testDispatchSignatureRequest() {
        // Test data setup
        String testName = 'testDispatchSignatureRequest';

        // construct sr
        YS_SignatureRequest__c sr = YS_DataTestFactory.createSignatureRequest();
        insert sr;

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signature_request');

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        sr = [SELECT Id, Status__c, LastEventDate__c FROM YS_SignatureRequest__c WHERE Id = :sr.Id LIMIT 1];
        Assert.areEqual('done', sr.Status__c, testName + ' #1 > Unexpected status');
        Assert.areEqual(YS_DataTestFactory.EVENT_TIME, sr.LastEventDate__c, testName + ' #2 > Unexpected Last Event Date');
    }

    @isTest
    private static void testDispatchSignatureRequestOldWH() {
        // Test data setup
        String testName = 'testDispatchSignatureRequestOldWH';
        Datetime now = Datetime.now();

        // construct sr
        YS_SignatureRequest__c sr = YS_DataTestFactory.createSignatureRequest();
        sr.Status__c = 'done';
        sr.LastEventDate__c = now;
        insert sr;

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signature_request');
        payload.event_name = 'signature_request.activated';
        payload.data.signature_request.status = 'ongoing';

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        sr = [SELECT Id, Status__c, LastEventDate__c FROM YS_SignatureRequest__c WHERE Id = :sr.Id LIMIT 1];
        Assert.areEqual('done', sr.Status__c, testName + ' #1 > Status should not be updated');
        Assert.areEqual(now, sr.LastEventDate__c, testName + ' #2 > Last Event Date should not be updated');
    }
    
    @isTest
    private static void testDispatchSigner() {
        // Test data setup
        String testName = 'testDispatchSigner';

        // construct sr
        YS_SignatureRequest__c sr = YS_DataTestFactory.createSignatureRequest();
        insert sr;
        YS_Signer__c signer = YS_DataTestFactory.createSigner(sr.Id);
        insert signer;

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signer');

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        signer = [SELECT Id, Status__c, LastEventDate__c FROM YS_Signer__c WHERE Id = :signer.Id LIMIT 1];
        Assert.areEqual('signed', signer.Status__c, testName + ' #1 > Unexpected status');
        Assert.areEqual(YS_DataTestFactory.EVENT_TIME, signer.LastEventDate__c, testName + ' #2 > Unexpected Last Event Date');
    }
    
    @isTest
    private static void testDispatchOther() {
        // Test data setup
        String testName = 'testDispatchOther';

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('approver');

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        // List<Log__c> errs = [SELECT Id FROM Log__c WHERE Type__c = 'Error'];
        // Assert.areEqual(0, errs.size(), testName + ' #1 > No error log should be returned');
    }
    
    @isTest
    private static void testDispatchError() {
        // Test data setup
        String testName = 'testDispatchError';

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('badData');

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        // List<Log__c> errs = [SELECT Id FROM Log__c WHERE Type__c = 'Error'];
        // Assert.areEqual(1, errs.size(), testName + ' #1 > An error log should be created');
        // Assert.areEqual('YS_WebhookDispatcher', errs.get(0).Source__c, testName + ' #2 > Unexpected Error Source');
    }
}