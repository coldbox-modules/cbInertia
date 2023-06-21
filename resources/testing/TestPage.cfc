component accessors="true" {

	property name="component";
	property name="localProps";
	property name="sharedProps";
	property name="partialComponentHeader";
	property name="partialDataHeader";

	this.InertiaTestPage = true;

	function init(
		required string component,
		struct localProps = {},
		struct sharedProps = {},
		string partialComponentHeader = "",
		string partialDataHeader = ""
	) {
		variables.component = arguments.component;
		variables.localProps = arguments.localProps;
		variables.sharedProps = arguments.sharedProps;
		variables.partialComponentHeader = arguments.partialComponentHeader;
		variables.partialDataHeader = arguments.partialDataHeader;
		return this;
	}

	function getProp( required string name ) {
		return getProps()[ arguments.name ];
	}

	function getProps() {
		var allProps = {};
		structAppend( allProps, getSharedProps(), true );
		structAppend( allProps, getLocalProps(), true );

        return resolveClosures(
            filterForPartialData(
                getComponent() == variables.partialComponentHeader,
                variables.partialDataHeader.listToArray( "," ),
                allProps
            )
        );
	}

	private any function resolveClosures( any prop ) {
        if ( isNull( arguments.prop ) ) {
            return javacast( "null", "" );
        } else if (
            isClosure( arguments.prop ) || isCustomFunction( arguments.prop )
        ) {
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

}