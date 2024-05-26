@IsTest
public with sharing class YS_WebhookDispatcher_Test {

    @isTest
    private static void testDispatchSignatureRequest() {
        // Test data setup
        String testName = 'testDispatchSignatureRequest';

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signature_request');

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        List<Task> tasks = [SELECT Description FROM Task WHERE Subject = 'YS_SignatureRequestService.newEventDebug'];
        Assert.areEqual(1, tasks.size(), testName + ' #1 > Unexpected number of tasks');
        Assert.areEqual('signature_request.done|done|' + YS_DataTestFactory.SR_ID + '|' + YS_DataTestFactory.EVENT_TIME, tasks[0].Description, testName + ' #1.1 > Unexpected task description');
    }
    
    @isTest
    private static void testDispatchSigner() {
        // Test data setup
        String testName = 'testDispatchSigner';

        // construct payload
        YS_WebhookListener.WebhookPayload payload = YS_DataTestFactory.getPayload('signer');

        // Actual test
        Test.startTest();
        YS_WebhookDispatcher.dispatchWebhooks(JSON.serialize(payload));
        Test.stopTest();
    
        // Asserts
        List<Task> tasks = [SELECT Description FROM Task WHERE Subject = 'YS_SignerService.newEventDebug'];
        Assert.areEqual(1, tasks.size(), testName + ' #1 > Unexpected number of tasks');
        Assert.areEqual('signer.done|signed|' + YS_DataTestFactory.SIGNER_ID + '|' + YS_DataTestFactory.EVENT_TIME, tasks[0].Description, testName + ' #1.1 > Unexpected task description');
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
        Assert.areEqual(0, [SELECT Description FROM Task WHERE Subject IN ('YS_SignerService.newEventDebug', 'YS_SignatureRequestService.newEventDebug')].size(), testName + ' #0.1 > Unexpected number of events');
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
        Assert.areEqual(0, [SELECT Description FROM Task WHERE Subject IN ('YS_SignerService.newEventDebug', 'YS_SignatureRequestService.newEventDebug')].size(), testName + ' #0.1 > Unexpected number of events');
        // List<Log__c> errs = [SELECT Id FROM Log__c WHERE Type__c = 'Error'];
        // Assert.areEqual(1, errs.size(), testName + ' #1 > An error log should be created');
        // Assert.areEqual('YS_WebhookDispatcher', errs.get(0).Source__c, testName + ' #2 > Unexpected Error Source');
    }
}