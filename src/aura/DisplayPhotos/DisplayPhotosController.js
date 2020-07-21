/**
 * Created by marta.stempien on 21.07.2020.
 */
({
    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Method called on Init
    */
    onInit : function ( component, event, helper )
    {
       helper.retrieveData( component, 1, "", 10 );
    },

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Method called when select input or filter change
    */
    onChangeInputs : function ( component, event, helper )
    {
       helper.onChangeInputs( component );
    },

    /**
    * @author Marta Stempien
    * @date 22/07/2020
    * @description Method control next/previous page button
    */
    navigate: function(component, event, helper)
    {
       helper.navigate( component, event );
    },
})