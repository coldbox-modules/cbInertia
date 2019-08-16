component {

    this.name = "cbInertia";
    this.version = "1.0.0";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cbInertia";
    this.dependencies = [ "vue-helpers" ];

    function configure() {
        interceptors = [
            { class = "#moduleMapping#.interceptors.InertiaLifecycle" }
        ];
    }

    function onLoad() {
        var helpers = controller.getSetting( "applicationHelper" );
        arrayAppend(
            helpers,
            "#moduleMapping#/helpers/Inertia.cfm"
        );
        controller.setSetting( "applicationHelper", helpers );
    }

    function onUnload() {
        controller.setSetting(
            "applicationHelper",
            arrayFilter( controller.getSetting( "applicationHelper" ), function( helper ) {
                return helper != "#moduleMapping#/helpers/Inertia.cfm";
            } )
        );
    }

}
