component {

	function toBeInertiaResponse( expectation, struct args = {} ) {
		if ( isNull( expectation.actual )  ) {
			expectation.message = "Expected a RequestContext instance but received null.";
			return false;
		}

		var event = expectation.actual;

		if ( !isStruct( event ) || !structKeyExists( event, "cbRequestContext" ) ) {
			expectation.message = "The passed in value is not an instance of RequestContext. Pass in the `event` object returned from making a `request`.";
			return false;
		}

		var prc = event.getPrivateContext();

		if ( !expectation.isNot && ( !prc.keyExists( "inertia__isInertia" ) || !prc.inertia__isInertia ) ) {
			expectation.message = "The action did not return an Inertia response.";
			return false;
		}

		if ( expectation.isNot && prc.keyExists( "inertia__isInertia" ) && prc.inertia__isInertia ) {
			expectation.message = "Expected the action to return a non-Inertia response but the action returned an Inertia response.";
			return false;
		}

		if ( structCount( args ) > 0 && ( isClosure( args[ 1 ] ) || isCustomFunction( args[ 1 ] ) ) ) {
			var callback = args[ 1 ];
			var testPage = new TestPage(
				component = prc.inertia__component,
				localProps = prc.inertia__props ?: {},
				sharedProps = prc.inertia__sharedProps ?: {},
				partialComponentHeader = event.getHTTPHeader( "X-Inertia-Partial-Component", "" ),
				partialDataHeader = event.getHTTPHeader( "X-Inertia-Partial-Data", "" )
			);
			callback( testPage );
		}

		return true;
	}

	function toBeInertiaComponent( expectation, struct args = {} ) {
		if ( isNull( expectation.actual )  ) {
			expectation.message = "Expected an InertiaTestPage instance but received null.";
			return false;
		}

		var page = expectation.actual;

		if ( !isStruct( page ) || !structKeyExists( page, "InertiaTestPage" ) ) {
			expectation.message = "The passed in value is not an instance of InertiaTestPage. These assertions should be called inside a callback function passed to `toBeInertiaResponse`.";
			return false;
		}

		if ( structCount( args ) <= 0 ) {
			expectation.message = "No expected component name passed in.";
			return false;
		}

		var expectedComponentName = args[ 1 ];

		if ( !isSimpleValue( expectedComponentName ) ) {
			expectation.message = "Expected component name must be a string.";
			return false;
		}

		if ( !expectation.isNot && page.getComponent() != expectedComponentName ) {
			expectation.message = structCount( args ) > 1 ? args[ 2 ] : "Expected rendered component to be [#expectedComponentName#] but received [#page.getComponent()#].";
			return false;
		}

		if ( expectation.isNot && page.getComponent() == expectedComponentName ) {
			expectation.message = structCount( args ) > 1 ? args[ 2 ] : "Expected rendered component not to be [#expectedComponentName#] but was.";
			return false;
		}

		return true;
	}

	function toHaveProps( expectation, struct args = {} ) {
		if ( isNull( expectation.actual )  ) {
			expectation.message = "Expected an InertiaTestPage instance but received null.";
			return false;
		}

		var page = expectation.actual;

		if ( !isStruct( page ) || !structKeyExists( page, "InertiaTestPage" ) ) {
			expectation.message = "The passed in value is not an instance of InertiaTestPage. These assertions should be called inside a callback function passed to `toBeInertiaResponse`.";
			return false;
		}

		if ( structCount( args ) <= 0 ) {
			expectation.message = "No expected props passed in.";
			return false;
		}

		var expectedProps = args[ 1 ];

		if ( !isStruct( expectedProps ) ) {
			expectation.message = "Expected props must be a struct.";
			return false;
		}

		if ( expectation.isNot ) {
			expectation.getAssert().isNotEqual( expectedProps, page.getProps(), structCount( args ) > 1 ? args[ 2 ] : javacast( "null", "" ) );
		} else {
			expectation.getAssert().isEqual( expectedProps, page.getProps(), structCount( args ) > 1 ? args[ 2 ] : javacast( "null", "" ) );
		}

		return true;
	}

	function toHaveProp( expectation, struct args = {} ) {
		if ( isNull( expectation.actual )  ) {
			expectation.message = "Expected an InertiaTestPage instance but received null.";
			return false;
		}

		var page = expectation.actual;

		if ( !isStruct( page ) || !structKeyExists( page, "InertiaTestPage" ) ) {
			expectation.message = "The passed in value is not an instance of InertiaTestPage. These assertions should be called inside a callback function passed to `toBeInertiaResponse`.";
			return false;
		}

		if ( structCount( args ) <= 0 ) {
			expectation.message = "No expected prop name passed in.";
			return false;
		}

		var expectedPropName = args[ 1 ];

		if ( !isSimpleValue( expectedPropName ) ) {
			expectation.message = "Expected prop name must be a string.";
			return false;
		}

		if ( !expectation.isNot && !structKeyExists( page.getProps(), expectedPropName ) ) {
			expectation.message = structCount( args ) > 2 ? args[ 3 ] : "Expected prop [#expectedPropName#] to exist but it does not.";
			expectation.getSpec().debug( {
				"expectedPropName": expectedPropName,
				"actualProps": page.getProps()
			} );
			return false;
		}

		if ( expectation.isNot && structKeyExists( page.getProps(), expectedPropName ) ) {
			expectation.message = structCount( args ) > 2 ? args[ 3 ] : "Expected prop [#expectedPropName#] not to exist but it does.";
			expectation.getSpec().debug( {
				"expectedPropName": expectedPropName,
				"actualProps": page.getProps()
			} );
			return false;
		}

		if ( structCount( args ) < 2 ) {
			return true;
		}

		var expectedPropValue = args[ 2 ];
		var actualPropValue = page.getProps()[ expectedPropName ];

		if ( expectation.isNot ) {
			expectation.getAssert().isNotEqual( expectedPropValue, actualPropValue, structCount( args ) > 2 ? args[ 3 ] : javacast( "null", "" ) );
		} else {
			expectation.getAssert().isEqual( expectedPropValue, actualPropValue, structCount( args ) > 2 ? args[ 3 ] : javacast( "null", "" ) );
		}

		return true;
	}

}