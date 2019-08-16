<cfscript>
function inertia() {
    var inertia = getWireBox().getInstance( "Inertia@cbInertia" );
    if ( structCount( arguments ) > 0 ) {
        return inertia.render( argumentCollection = arguments );
    } else {
        return inertia;
    }
}
</cfscript>
