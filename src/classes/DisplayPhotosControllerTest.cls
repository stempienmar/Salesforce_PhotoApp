/**
 * Created by marta.stempien on 20.07.2020.
 */
@isTest
private with sharing class DisplayPhotosControllerTest
{
    @isTest
    private static void retrievePhotosTest( )
    {
        TestDataFactory.insertPhoto( );
        System.assert( !DisplayPhotosController.retrievePhotos( ).isEmpty( ) );
    }
}