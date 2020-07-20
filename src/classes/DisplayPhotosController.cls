/**
 * Created by marta.stempien on 20.07.2020.
 */
public with sharing class DisplayPhotosController
{
    @AuraEnabled
    public static List<Photo__c> retrievePhotos( )
    {
        return
        [
                SELECT AlbumId__c,
                        Title__c,
                        URL__c,
                        ThumbnailURL__c
                FROM Photo__c
                LIMIT 50000
        ];
    }
}