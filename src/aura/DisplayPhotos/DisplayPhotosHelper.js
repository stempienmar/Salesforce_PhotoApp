/**
 * Created by marta.stempien on 21.07.2020.
 */
({
    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Calls backend to retrieve data
    */
    retrieveData : function ( component, inPageNumber, inNameFilter, inRecordToDisplay )
    {
        let action = component.get("c.getPhotos")
        action.setParams(
        {
            inPageNumber : inPageNumber,
            inRecordToDisplay : inRecordToDisplay,
            inNameFilter : inNameFilter
        });
        action.setCallback(this, $A.getCallback(function (response)
        {
            if ( response.getState() !== "SUCCESS" )
            {
                return;
            }
            let responseValue = response.getReturnValue();
            component.set("v.dataList", responseValue.photos);
            component.set("v.page", responseValue.page);
            let total = responseValue.total;
            component.set("v.total", total);
            component.set("v.pages", Math.ceil( total / inRecordToDisplay ));
            component.set("v.isInitialized", true);
        }));
        $A.enqueueAction(action);
    },

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Called when select input or filter changes
    */
    onChangeInputs : function( component )
    {
       this.retrieveData(component, 1, component.find("nameFilter").get("v.value"), component.find("recordSize").get("v.value"));
    },

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description: Navigates previous/next page
    */
    navigate : function( component, event )
    {
        let page = component.get("v.page");
        var recordToDisply = component.find("recordSize").get("v.value");
        page = event.getSource().get("v.label") === "Previous Page" ? (page - 1) : (page + 1);
        this.retrieveData(component, page, component.find("nameFilter").get("v.value"), component.find("recordSize").get("v.value"));
    },

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Method calls sendEmailMessage backend method
    */
    sendEmail: function(component)
    {
       let action = component.get("c.sendEmailMessage");
       let inputAddress = component.find("emailAddress");
       action.setParams(
       {
           inToEmailAddress : inputAddress.get("v.value"),
           inPhotos : component.get("v.dataList")
       });
       action.setCallback(this, $A.getCallback(function (response)
       {
           if ( response.getState() !== "SUCCESS" )
           {
               this.showToast("Error", "success");
               return;
           }
           this.showToast($A.get("$Label.c.EmailSent"), "success");
           inputAddress.set("v.value", '');

       }));
       $A.enqueueAction(action);
    },

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Show message toast
    */
    showToast: function( message, type, title )
    {
        let toastEvent = $A.get( "e.force:showToast" );
        toastEvent.setParams ({
            message: message,
            type: type,
            title: title,
        } );
        toastEvent.fire( );
    }
})