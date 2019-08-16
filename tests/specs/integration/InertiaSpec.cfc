component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {
    function run() {
        describe( "Inertia", function() {
            describe( "template rendering", function() {
                it( "renders a view when called normally", function() {
                    var event = execute( event = "Inertia.normal", renderResults = true );
                    var html = event.getValue( "cbox_rendered_content", "" );
                    expect( html ).toMatch( '&quot;component&quot;:&quot;Home&quot;' );
                    expect( html ).toMatch( '&quot;props&quot;:{&quot;foo&quot;:&quot;bar&quot;}' );
                } );

                it( "combines shared props with view props", function() {
                    var event = execute( event = "Inertia.withShared", renderResults = true );
                    var html = event.getValue( "cbox_rendered_content", "" );
                    expect( html ).toMatch( '&quot;component&quot;:&quot;Home&quot;' );
                    expect( html ).toMatch( '&quot;props&quot;:{&quot;shared&quot;:&quot;value&quot;,&quot;foo&quot;:&quot;bar&quot;}' );
                } );
            } );

            describe( "json rendering", function() {
                it( "renders json when called with an X-Inertia header", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" );
                    var event = execute( event = "Inertia.normal", renderResults = true );
                    var actual = deserializeJSON( event.getValue( "cbox_rendered_content", "" ) );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar" } );

                    // TODO: Waiting on https://github.com/ColdBox/coldbox-platform/pull/419 to be merged
                    // expect( actual ).toHaveKey( "url" );
                    // expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "combines shared props with view props", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" );
                    var event = execute( event = "Inertia.withShared", renderResults = true );
                    var actual = deserializeJSON( event.getValue( "cbox_rendered_content", "" ) );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar", "shared": "value" } );

                    // TODO: Waiting on https://github.com/ColdBox/coldbox-platform/pull/419 to be merged
                    // expect( actual ).toHaveKey( "url" );
                    // expect( actual.url ).toBeTypeOf( "url" );
                } );
            } );
        } );
    }
}
