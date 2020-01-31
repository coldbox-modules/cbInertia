component {

    property name="version" inject="coldbox:setting:version@cbInertia";
    property
        name="defaultViewArgs"
        inject="coldbox:setting:defaultViewArgs@cbInertia";

    function preProcess( event ) {
        if ( event.getHTTPHeader( "X-Inertia", "" ) == "" ) {
            return;
        }

        if ( event.getHTTPMethod() != "GET" ) {
            return;
        }

        var version = wirebox.getInstance(
            dsl = "coldbox:setting:version@cbInertia"
        );
        version = isCallable( version ) ? version() : version;
        if ( event.getHTTPHeader( "X-Inertia-Version", "" ) == version ) {
            return;
        }

        event.noExecution();
        event.setHTTPHeader( statusCode = 409, statusText = "Conflict" );
        event.setHTTPHeader(
            name = "X-Inertia-Location",
            value = event.getFullUrl()
        );
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

        page.props = resolveClosures(
            filterForPartialData(
                page.component == event.getHTTPHeader(
                    "X-Inertia-Partial-Component",
                    ""
                ),
                event
                    .getHTTPHeader( "X-Inertia-Partial-Data", "" )
                    .listToArray( "," ),
                sharedProps
            )
        );

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

    private any function resolveClosures( required any prop ) {
        if ( isClosure( arguments.prop ) || isCustomFunction( arguments.prop ) ) {
            return arguments.prop();
        } else if ( isStruct( arguments.prop ) ) {
            return arguments.prop.map( function( key, value ) {
                return resolveClosures( arguments.value );
            } );
        } else if ( isArray( arguments.prop ) ) {
            return arguments.prop.map( resolveClosures );
        } else {
            return arguments.prop;
        }
    }

    private struct function filterForPartialData(
        required boolean isSameComponent,
        array only = [],
        struct props = {}
    ) {
        if ( !arguments.isSameComponent || arguments.only.isEmpty() ) {
            return arguments.props;
        }

        return arguments.props.filter( function( key ) {
            return arrayContainsNoCase( only, arguments.key );
        } );
    }

    private boolean function isCallable( any value ) {
        return isClosure( arguments.value ) ||
        isCustomFunction( arguments.value );
    }

}
