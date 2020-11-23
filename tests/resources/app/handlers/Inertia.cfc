component {

    function normal( event, rc, prc ) {
        inertia( "Home", { "foo": "bar" } );
    }

    function withNull( event, rc, prc ) {
        inertia( "Home", { "foo": javacast( "null", "" ) } );
    }

    function withShared( event, rc, prc ) {
        inertia().share( "shared", "value" );
        inertia( "Home", { "foo": "bar" } );
    }

    function withSharedClosures( event, rc, prc ) {
        inertia().share( "shared", function() {
            return "value";
        } );
        inertia( "Home", { "foo": "bar" } );
    }

    function withArrayProp( event, rc, prc ) {
        inertia( "Home", { "numbers": [ 1, 2, 3 ] } );
    }

    function relocateTest( event, rc, prc ) {
        relocate( "Inertia.normal" );
    }

}
