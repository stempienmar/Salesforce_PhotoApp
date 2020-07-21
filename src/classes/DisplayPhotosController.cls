/**
 * Created by marta.stempien on 20.07.2020.
 */
public with sharing class DisplayPhotosController
{
    private static final String PERCENT = '%';

    /**
    * @author Marta Stempien
    * @date 21/07/2020
    * @description: Front data wrapper
    */
    public class PhotoDataWrapper
    {
        @AuraEnabled public Integer pageSize;
        @AuraEnabled public Integer page;
        @AuraEnabled public Integer total;
        @AuraEnabled public List<Photo__c> photos;
    }

    /**
    * @author Marta Stempien
    * @date 21/07/2020
    * @description: Method selects data to display in App
    * @parameters: Integer inPageNumber, Integer inRecordToDisplay, String inNameFilter
    * @returns: PhotoDataWrapper
    */
    @AuraEnabled
    public static PhotoDataWrapper getPhotos( Integer inPageNumber, Integer inRecordToDisplay, String inNameFilter )
    {
        String composedFilter = PERCENT + inNameFilter + PERCENT;
        Integer offset = ( inPageNumber - 1 ) * inRecordToDisplay;

        PhotoDataWrapper dataWrapper = new PhotoDataWrapper( );
        dataWrapper.pageSize = inRecordToDisplay;
        dataWrapper.page = inPageNumber;
        List<Photo__c> photos =
        [
                SELECT  AlbumId__c,
                        Title__c,
                        URL__c,
                        ThumbnailURL__c
                FROM Photo__c
                WHERE Title__c LIKE :composedFilter
                ORDER BY ExternalID__c
                LIMIT :inRecordToDisplay
                OFFSET :offset
        ];

        dataWrapper.total =
        [
                SELECT COUNT()
                FROM Photo__c
                WHERE Title__c LIKE :composedFilter
        ];
        dataWrapper.photos = photos;
        return dataWrapper;
    }


}