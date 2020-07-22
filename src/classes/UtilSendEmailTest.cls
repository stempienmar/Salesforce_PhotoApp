/**
 * Created by marta.stempien on 22.07.2020.
 */

@isTest
public with sharing class UtilSendEmailTest
{
    @isTest
    private static void sendEmailTest( )
    {
        UtilSendEmail testWrapper = new UtilSendEmail( );
        testWrapper.subject = 'Test';
        testWrapper.body = 'Test';
        testWrapper.toMail = 'test@wp.pl';
        System.assertEquals( 'OK', testWrapper.sendMail( ) );
    }
}