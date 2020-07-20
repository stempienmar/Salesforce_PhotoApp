/**
 * Created by marta.stempien on 20.07.2020.
 */

public with sharing class DataRefreshScheduler implements Schedulable
{
    public void execute(SchedulableContext ctx)
    {
        CalloutProcessor.processPhotosDMLOperations();
    }
}