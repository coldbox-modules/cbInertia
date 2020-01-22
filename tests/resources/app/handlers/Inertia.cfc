component {

    function normal( event, rc, prc ) {
        inertia( "Home", { "foo": "bar" } );
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

    function relocateTest( event, rc, prc ) {
        relocate( "Inertia.normal" );
    }

}
