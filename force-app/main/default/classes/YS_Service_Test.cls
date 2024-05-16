@isTest
public with sharing class YS_Service_Test {
    @isTest
    private static void testGetNameCredentials() {
        // Test data setup
        String testName = 'testGetNameCredentials';
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        orgDefault.IsSandbox__c = true;
        upsert orgDefault;
        
        // Actual test
        Test.startTest();
        Assert.areEqual('YS_Sandbox', YS_Service.getNameCredentials(), testName + ' #1 > Expected sandbox credentials');
        orgDefault.IsSandbox__c = false;
        update orgDefault;
        Assert.areEqual('YS_Prod', YS_Service.getNameCredentials(), testName + ' #2 > Expected production credentials');
        Test.stopTest();
    }

    @isTest
    private static void testGetEncodingKey() {
        // Test data setup
        String testName = 'testGetEncodingKey';
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        orgDefault.YS_EncodingKey__c = 'myEncodingKey';
        upsert orgDefault;
        
        // Actual test
        Test.startTest();
        Assert.areEqual('myEncodingKey', YS_Service.getEncodingKey(), testName + ' #1 > Unexpected Encoding Key');
        Test.stopTest();
    }
}