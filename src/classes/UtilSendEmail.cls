/**
 * Created by marta.stempien on 22.07.2020.
 */
public with sharing class UtilSendEmail
{
    private static final String EMPTY_TEXT = '';
    private static final String OK_TEXT = 'OK';
    public String toMail { get; set; }
    public String subject { get; set; }
    public String body { get; set; }

    public UtilSendEmail( )
    {
        this.toMail = EMPTY_TEXT;
        this.subject = EMPTY_TEXT;
        this.body = EMPTY_TEXT;
    }

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description: Method sends email message
    * @parameters: -
    * @returns: String
    */
    public String sendMail( )
    {
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage( );
        emailMessage.setToAddresses( new List<String> {this.toMail} );
        emailMessage.setSubject( this.subject );
        emailMessage.setHtmlBody( this.body );
        try
        {
            Messaging.sendEmail( new Messaging.SingleEmailMessage[] {emailMessage} );
            return 'OK';
        } catch ( exception e )
        {
            return e.getMessage( );
        }
    }

}