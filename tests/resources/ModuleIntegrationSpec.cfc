component extends="coldbox.system.testing.BaseTestCase" {

    function beforeAll() {
        super.beforeAll();

        getController().getModuleService()
            .registerAndActivateModule( "cbInertia", "testingModuleRoot" );

        if ( listFirst( getController().getColdBoxSetting( "version" ), "." ) == 7 ) {
            getController().getRenderer().loadApplicationHelpers();
        }

    }

    /**
    * @beforeEach
    */
    function setupIntegrationTest() {
        setup();
    }

}
