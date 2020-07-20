/**
 * Created by marta.stempien on 20.07.2020.
 */

public with sharing class CalloutProcessor
{
    private static final String URL = 'https://jsonplaceholder.typicode.com/photos';
    private static final String GET_METHOD = 'GET';
    private static final Integer STATUS_200 = 200;
    private static final String ERROR_MESSAGE = 'The following error occured: ';

    /**
    * @author Marta Stempien
    * @date 20/07/2020
    * @description: Wrapper class for external system photo object
    */
    public class PhotoWrapper
    {
        private String id;
        private String albumId;
        private String title;
        private String url;
        private String thumbnailUrl;
    }

    /**
    * @author Marta Stempien
    * @date 20/07/2020
    * @description: Method gets data from external service and executes Upsert and Delete operations on Photo__C
    * @parameters: -
    * @returns: -
    */
    public static void processPhotosDMLOperations( )
    {
        HttpResponse response = photosGetCallout( );
        if ( response.getStatusCode( ) == STATUS_200 )
        {
            Map<String, Photo__c> existingSFDCPhotosByExternalIds = getSFDCPhotosByExternalIds( );
            List<Photo__c> photosToDelete = new List<Photo__c>( );

            Map<String, Photo__c> photosToUpsertByExternalIds = new Map<String, Photo__c>( );
            for ( PhotoWrapper loopPhotoWrapper : ( List<PhotoWrapper> ) JSON.deserialize( response.getBody( ), List<PhotoWrapper>.class ) )
            {
                String externalId = loopPhotoWrapper.id;
                Photo__c photoToUpsert = existingSFDCPhotosByExternalIds.keySet( ).contains( externalId ) ? existingSFDCPhotosByExternalIds.get( externalId ) : new Photo__c( );
                photoToUpsert.ExternalID__c = externalId;
                photoToUpsert.AlbumId__c = loopPhotoWrapper.albumId;
                photoToUpsert.Title__c = loopPhotoWrapper.title;
                photoToUpsert.URL__c = loopPhotoWrapper.url;
                photoToUpsert.ThumbnailURL__c = loopPhotoWrapper.thumbnailUrl;
                photosToUpsertByExternalIds.put( externalId, photoToUpsert );
            }

            for ( String loopExternalId : existingSFDCPhotosByExternalIds.keySet( ) )
            {
                if ( !photosToUpsertByExternalIds.keySet( ).contains( loopExternalId ) )
                {
                    photosToDelete.add( existingSFDCPhotosByExternalIds.get( loopExternalId ) );
                }
            }

            try
            {
                delete photosToDelete;
                upsert photosToUpsertByExternalIds.values( );
            } catch ( Exception exc )
            {
                System.debug( LoggingLevel.ERROR, ERROR_MESSAGE + exc.getMessage( ) + ' ' + exc.getStackTraceString( ) );
            }
        }
    }

    /**
    * @author Marta Stempien
    * @date 20/07/2020
    * @description: Method executes GET callout request for retrieving JSON list of photos
    * @parameters: -
    * @returns: HttpResponse
    */
    private static HttpResponse photosGetCallout( )
    {
        Http http = new Http( );
        HttpRequest request = new HttpRequest( );
        request.setEndpoint( URL );
        request.setMethod( GET_METHOD );
        return http.send( request );
    }


    /**
    * @author Marta Stempien
    * @date 20/07/2020
    * @description: Method selects for Photo__c and returns map of photos by external ids
    * @parameters: -
    * @returns: Map<String, Photo__c>
    */
    private static Map<String, Photo__c> getSFDCPhotosByExternalIds( )
    {
        Map<String, Photo__c> outPhotosByExternalIds = new Map<String, Photo__c>( );
        for ( Photo__c loopPhoto : [ SELECT Id, ExternalID__c FROM Photo__c LIMIT 50000 ] )
        {
            outPhotosByExternalIds.put( loopPhoto.ExternalID__c, loopPhoto );
        }
        return outPhotosByExternalIds;
    }

}