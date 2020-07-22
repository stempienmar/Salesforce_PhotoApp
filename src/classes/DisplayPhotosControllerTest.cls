/**
 * Created by marta.stempien on 20.07.2020.
 */
@isTest
private with sharing class DisplayPhotosControllerTest
{
    @isTest
    private static void retrievePhotosNullInputTest( )
    {
        System.assertEquals( null, DisplayPhotosController.getPhotos( null, 10, 'T' ).total );
    }
    @isTest
    private static void retrievePhotosTest( )
    {
        TestDataFactory.insertPhoto( );
        System.assertEquals( 1, DisplayPhotosController.getPhotos( 1, 10, 'T' ).total );
    }

    @isTest
    private static void sendEmailMessageNullInputTest( )
    {
        System.assertEquals( DisplayPhotosController.ERROR_NULL_INPUT, DisplayPhotosController.sendEmailMessage( null, null ) );
    }

    @isTest
    private static void sendEmailMessageTest( )
    {
        Photo__c testPhoto = TestDataFactory.getPhoto();
        System.assertEquals( 'OK', DisplayPhotosController.sendEmailMessage('xxx@wp.pl', new List<Photo__c>{testPhoto}) );
    }
}