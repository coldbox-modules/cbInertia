component {

    property name="version" inject="coldbox:setting:version@cbInertia";

    function configure() {
        variables.defaultViewArgs = { "view": "main/index", "module": "cbInertia" };
    }

    function preProcess( event ) {
        if ( event.getHTTPHeader( "X-Inertia", "" ) == "" ) {
            return;
        }

        var version = wirebox.getInstance( dsl = "coldbox:setting:version@cbInertia" );
        version = isCallable( version ) ? version() : version;
        if ( event.getHTTPHeader( "X-Inertia-Version", "" ) == version ) {
            return;
        }

        event.noExecution();
        event.setHTTPHeader( statusCode = 409, statusText = "Conflict" );
        event.setHTTPHeader( name = "X-Inertia-Location", value = event.getFullUrl() );
        event.renderData( type = "plain", data = "Conflict", statusCode = 409 );
    }

    function preLayout( event ) {
        if ( !event.getPrivateValue( "inertia__isInertia", false ) ) {
            return;
        }

        var props = event.getPrivateValue( "inertia__props", {} );
        var sharedProps = event.getPrivateValue( "inertia__sharedProps", {} );
        structAppend( sharedProps, props, true );

        var page = event.getPrivateValue( "inertia__page" );

        page.props = resolveClosures( sharedProps );

        if ( event.getHTTPHeader( "X-Inertia", "" ) != "" ) {
            event
                .setHTTPHeader( statusCode = 200, statusText = "OK" )
                .setHTTPHeader( name = "Vary", value = "Accept" )
                .setHTTPHeader( name = "X-Inertia", value = true )
                .renderData( type = "json", data = page );
            return;
        }

        event.setPrivateValue( "inertia__page", page );

        event.setView( argumentCollection = variables.defaultViewArgs );
    }

    private struct function resolveClosures( required struct props ) {
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

    private boolean function isCallable( any value ) {
        return isClosure( arguments.value ) ||
        isCustomFunction( arguments.value );
    }

}
