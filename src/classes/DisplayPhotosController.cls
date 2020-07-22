/**
 * Created by marta.stempien on 20.07.2020.
 */
public with sharing class DisplayPhotosController
{
    private static final String PERCENT = '%';
    private static final String PHOTO_EMAIL_SUBJECT = 'Filtered Photos';
    public static final String ERROR_NULL_INPUT = 'Error Null Input';

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
        PhotoDataWrapper dataWrapper = new PhotoDataWrapper( );
        if ( inPageNumber == null || inNameFilter == null || inRecordToDisplay == null )
        {
            System.debug( LoggingLevel.ERROR, ERROR_NULL_INPUT );
            return dataWrapper;
        }
        String composedFilter = PERCENT + inNameFilter + PERCENT;
        Integer offset = ( inPageNumber - 1 ) * inRecordToDisplay;
        dataWrapper.pageSize = inRecordToDisplay;
        dataWrapper.page = inPageNumber;
        List<Photo__c> photos =
        [
                SELECT AlbumId__c,
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
                SELECT COUNT( )
                FROM Photo__c
                WHERE Title__c LIKE :composedFilter
        ];
        dataWrapper.photos = photos;
        return dataWrapper;
    }

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description: Method collects data for Email message
    * @parameters: String inToEmailAddress, List<Photo__c> inPhotos
    * @returns: String
    */
    @AuraEnabled
    public static String sendEmailMessage( String inToEmailAddress, List<Photo__c> inPhotos )
    {
        if ( inToEmailAddress == null || inPhotos == null )
        {
            System.debug( LoggingLevel.ERROR, ERROR_NULL_INPUT );
            return ERROR_NULL_INPUT;
        }
        UtilSendEmail emailWrapper = new UtilSendEmail( );
        emailWrapper.toMail = inToEmailAddress;
        emailWrapper.body = buildHtml( inPhotos );
        emailWrapper.subject = PHOTO_EMAIL_SUBJECT;
        return emailWrapper.sendMail( );
    }

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description: Method builds html body for email based on Photo list
    * @parameters: List<Photo__c> inPhotos
    * @returns: String
    */
    private static String buildHtml( List<Photo__c> inPhotos )
    {
        String outBody = '<h1 style="color: #5e9ca0;">Photos</h1>' +
                '<table><thead><tr><td>Title</td><td>URL</td><td>Thumbnail</td></tr>' +
                '</thead><tbody>';
        for ( Photo__c loopPhoto : inPhotos )
        {
            outBody += '<tr><td>' + loopPhoto.Title__c + '</td><td><img style="margin: 1px 15px;" src="' + loopPhoto.URL__c + '" alt="laughing" width="40" height="40" /></td>' +
                    '<td><img style="margin: 1px 15px;" src="' + loopPhoto.URL__c + '" alt="laughing" width="40" height="40" /></td>';
        }
        outBody += '</tbody></table>';
        return outBody;
    }


}