component {

    function configure() {
        variables.defaultViewArgs = {
            "view" = "main/index",
            "module" = "cbInertia"
        };
    }

    function preLayout( event, interceptData, buffer, rc, prc ) {
        if ( ! event.getPrivateValue( "inertia__isInertia", false ) ) {
            return;
        }

        var props = event.getPrivateValue( "inertia__props", {} );
        var sharedProps = event.getPrivateValue( "inertia__sharedProps", {} );
        structAppend( sharedProps, props, true );

        var page = event.getPrivateValue( "inertia__page" );

        page.props = resolveClosures( sharedProps );

        if ( event.getHTTPHeader( "X-Inertia", "" ) != "" ) {
            event.setHTTPHeader( statusCode = 200, statusText = "OK" )
                .setHTTPHeader( name = "Vary", value = "Accept" )
                .setHTTPHeader( name = "X-Inertia", value = true )
                .renderData(
                    type = "json",
                    data = page
                );
            return;
        }

        event.setPrivateValue( "inertia__page", page );

        event.setView( argumentCollection = variables.defaultViewArgs );
    }

    struct function resolveClosures( required struct props ) {
        return arguments.props.map( function( key, value ) {
            if ( isClosure( arguments.value ) || isCustomFunction( arguments.value ) ) {
                return arguments.value();
            } else if ( isStruct( arguments.value ) ) {
                return resolveClosures( arguments.value );
            } else if ( isArray( arguments.value ) ) {
                return arguments.value.map( resolveClosures );
            } else {
                return arguments.value;
            }
        } );
    }

}
