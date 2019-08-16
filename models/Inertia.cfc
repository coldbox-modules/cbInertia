component {

    property name="event" inject="provider:coldbox:requestContext";
    property name="config" inject="coldbox:moduleConfig:cbInertia";

    function render( component, props = {} ) {
        event.setPrivateValue( "inertia__isInertia", true );
        event.setPrivateValue( "inertia__component", arguments.component );
        event.setPrivateValue( "inertia__props", arguments.props );
        updatePageVariable();
        return this;
    }

    function share( key, value ) {
        var sharedProps = event.getPrivateValue( "inertia__sharedProps", {} );
        sharedProps[ key ] = value;
        event.setPrivateValue( "inertia__sharedProps", sharedProps );
        return this;
    }

    private function updatePageVariable() {
        event.setPrivateValue( "inertia__page", {
            "component": event.getPrivateValue( "inertia__component" ),
            "props": event.getPrivateValue( "inertia__props" ),
            "url": event.getFullUrl(),
            "version": config.version
        } );
    }

}
