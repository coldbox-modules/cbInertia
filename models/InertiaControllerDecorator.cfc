component extends="coldbox.system.web.ControllerDecorator" {

    function configure() {
    }

    /**
     * Ensures that PUT, PATCH, and DELETE relocations for Inertia requests
     * return a 303 status code.
     */
    function relocate(
        event = getSetting( "DefaultEvent" ),
        queryString = "",
        boolean addToken = false,
        persist = "",
        struct persistStruct = structNew()
        boolean ssl,
        baseURL = "",
        boolean postProcessExempt = false,
        URL,
        URI,
        numeric statusCode = 0
    ) {
        var requestContext = getRequestService().getContext();
        if ( requestContext.getHTTPHeader( "X-Inertia", "" ) != "" ) {
            if (
                arrayContainsNoCase(
                    [ "PUT", "PATCH", "DELETE" ],
                    requestContext.getHTTPMethod()
                )
            ) {
                arguments.statusCode = 303;
            }
        }
        return invoke( variables.originalController, "relocate", arguments );
    }

}
