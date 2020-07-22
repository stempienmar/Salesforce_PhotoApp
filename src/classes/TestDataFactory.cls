/**
 * Created by marta.stempien on 20.07.2020.
 */
@isTest
public with sharing class TestDataFactory
{
    private static final String TEST_EXTERNAL_ID = '1111';
    private static final String TITLE = 'Test';

    /**
    * @author Marta Stempien
    * @date 20/07/2020
    * @description: Method inserts Photo__c object with all of the required fields
    * @parameters: -
    * @returns: -
    */
    public static void insertPhoto( )
    {
        insert new Photo__c( ExternalID__c = TEST_EXTERNAL_ID, Title__c = TITLE );
    }

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description: Method returns Photo__c object with all of the required fields
    * @parameters: -
    * @returns: Photo__c
    */
    public static Photo__c getPhoto( )
    {
        return new Photo__c( ExternalID__c = TEST_EXTERNAL_ID, Title__c = TITLE );
    }

}