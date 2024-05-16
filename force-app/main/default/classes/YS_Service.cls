/**
 * @description       : Service class for YS x SF integration
 * @author            : Simon Persenot
 * @group             : 
 * @last modified on  : 13-12-2023
 * @last modified by  : Simon Persenot
 * @testCoverage      : YS_Service_Test
**/
public with sharing class YS_Service {

    /**
    * @description return the name of the NameCredential to use
    * @author Simon Persenot | 12-12-2023 
    * @return String 
    **/
    public static String getNameCredentials()
    {
        String namedCredential;
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        if (orgDefault.IsSandbox__c)
        {
            namedCredential = 'YS_Sandbox';
        }
        else
        {
            namedCredential = 'YS_Prod';
        }
        return namedCredential;
    }

    /**
    * @description return the encoding key of Yousign Webservice
    * @author Simon Persenot | 12-12-2023 
    * @return String 
    **/
    public static String getEncodingKey()
    {
        String key;
        YS_Configuration__c orgDefault = YS_Configuration__c.getOrgDefaults();
        return orgDefault.YS_EncodingKey__c;
    }
}