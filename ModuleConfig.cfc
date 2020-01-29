component {

    this.name = "cbInertia";
    this.version = "1.0.0";
    this.author = "Eric Peterson";
    this.webUrl = "https://github.com/elpete/cbInertia";
    this.dependencies = [ "vue-helpers" ];

    function configure() {
        settings = {
            "autoRegisterInterceptor": true,
            "autoRegisterHelpers": true,
            "autoRegisterControllerDecorator": true,
            "defaultViewArgs": {
                "view": "main/index",
                "module": "cbInertia"
            },
            "version": function() {
                return "";
            }
        };
    }

    function onLoad() {
        if ( settings.autoRegisterInterceptor ) {
            controller.getInterceptorService().registerInterceptor(
                interceptorName = "InertiaLifecycleInterceptor",
                interceptorClass = "#moduleMapping#.interceptors.InertiaLifecycle"
            );
        }

        if ( settings.autoRegisterHelpers ) {
            var helpers = controller.getSetting( "applicationHelper" );
            arrayAppend(
                helpers,
                "#moduleMapping#/helpers/Inertia.cfm"
            );
            controller.setSetting( "applicationHelper", helpers );
        }

        if ( settings.autoRegisterControllerDecorator ) {
            if ( controller.getSetting( name = "controllerDecorator", defaultValue = "" ) != "" ) {
                throw( "Cannot auto-register the `InertiaControllerDecorator` when a `controllerDecorator` is already set." );
            }
            controller.setSetting( "controllerDecorator", "#moduleMapping#.models.InertiaControllerDecorator" );
            controller.getLoaderService().createControllerDecorator();
        }
    }

    function onUnload() {
        if ( settings.autoRegisterHelpers ) {
            controller.setSetting(
                "applicationHelper",
                arrayFilter( controller.getSetting( "applicationHelper" ), function( helper ) {
                    return helper != "#moduleMapping#/helpers/Inertia.cfm";
                } )
            );
        }

        if ( settings.autoRegisterInterceptor ) {
            controller.getInterceptorService().unregister(
                interceptorName = "InertiaLifecycleInterceptor"
            );
        }

        if ( settings.autoRegisterControllerDecorator ) {
            controller.setSetting( "controllerDecorator", "" );
        }
    }

}
