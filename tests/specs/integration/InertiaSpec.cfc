component extends="tests.resources.ModuleIntegrationSpec" appMapping="/app" {

    function run() {
        describe( "Inertia", function() {
            describe( "template rendering", function() {
                it( "renders a view when called normally", function() {
                    var event = execute(
                        event = "Inertia.normal",
                        renderResults = true
                    );
                    var html = event.getValue( "cbox_rendered_content", "" );
                    expect( html ).toMatch(
                        "&quot;component&quot;:&quot;Home&quot;"
                    );
                    expect( html ).toMatch(
                        "&quot;props&quot;:{&quot;foo&quot;:&quot;bar&quot;}"
                    );
                } );

                it( "combines shared props with view props", function() {
                    var event = execute(
                        event = "Inertia.withShared",
                        renderResults = true
                    );
                    var html = event.getValue( "cbox_rendered_content", "" );
                    expect( html ).toMatch(
                        "&quot;component&quot;:&quot;Home&quot;"
                    );
                    expect( html ).toMatch(
                        "&quot;props&quot;:{&quot;shared&quot;:&quot;value&quot;,&quot;foo&quot;:&quot;bar&quot;}"
                    );
                } );
            } );

            describe( "json rendering", function() {
                it( "renders json when called with an X-Inertia header", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );

                    var event = execute(
                        event = "Inertia.normal",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "renders a view with a null prop", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );

                    var event = execute(
                        event = "Inertia.normal",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "combines shared props with view props", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    ;
                    var event = execute(
                        event = "Inertia.withShared",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar", "shared": "value" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "can resolve closures in props", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    ;
                    var event = execute(
                        event = "Inertia.withSharedClosures",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar", "shared": "value" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "can pass arrays in props", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    ;
                    var event = execute(
                        event = "Inertia.withArrayProp",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "numbers": [ 1, 2, 3 ] } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "can request partial data", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "foo" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    var event = execute(
                        event = "Inertia.withShared",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "can request a list of partial data", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Home" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    var event = execute(
                        event = "Inertia.withShared",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar", "shared": "value" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );

                it( "returns all the data if the component does not match", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Component", "" )
                        .$results( "Wrong" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Partial-Data", "" )
                        .$results( "foo" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    var event = execute(
                        event = "Inertia.withShared",
                        renderResults = true
                    );
                    var actual = deserializeJSON(
                        event.getValue( "cbox_rendered_content", "" )
                    );

                    expect( actual ).toHaveKey( "component" );
                    expect( actual.component ).toBe( "Home" );

                    expect( actual ).toHaveKey( "props" );
                    expect( actual.props ).toBe( { "foo": "bar", "shared": "value" } );

                    expect( actual ).toHaveKey( "url" );
                    expect( actual.url ).toBeTypeOf( "url" );
                } );
            } );

            describe( "status codes", function() {
                it( "returns a 303 status code automatically for PUT or PATCH or DELETE verbs when relocating", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPMethod", "DELETE" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "" );
                    var event = execute(
                        event = "Inertia.relocateTest",
                        renderResults = true
                    );
                    expect( event.getValue( "relocate_STATUSCODE", "" ) ).toBe(
                        303
                    );
                } );
            } );

            describe( "version", function() {
                it( "returns a 409 Conflict with a X-Inertia-Location header when the versions don't match", function() {
                    prepareMock( getRequestContext() )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia", "" )
                        .$results( "true" )
                        .$( "getHTTPHeader" )
                        .$args( "X-Inertia-Version", "" )
                        .$results( "not-matching-version" );
                    var event = execute(
                        event = "Inertia.normal",
                        renderResults = true
                    );
                    expect( event.getStatusCode() ).toBe( 409 );
                    var headers = event.getValue( "cbox_headers", {} );
                    expect( headers ).toHaveKey( "X-Inertia-Location" );
                    expect( headers[ "X-Inertia-Location" ] ).toBe(
                        event.getFullUrl()
                    );
                } );
            } );
        } );
    }

}
