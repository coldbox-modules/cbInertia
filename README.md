# cbInertia

[![Master Branch Build Status](https://img.shields.io/travis/elpete/cbInertia/master.svg?style=flat-square&label=master)](https://travis-ci.org/elpete/cbInertia)

## The ColdBox adapter for Inertia.js

### What is Inertia.js?

[Inertia.js](https://inertiajs.com/) lets you, in its own words, "quickly build modern single-page React,
Vue and Svelte apps using classic server-side routing and controllers." Using
Inertia.js is like using your favorite MVC server-side framework (ColdBox, of course)
with Vue as the templating language - no need to build a separate API. You can
learn all about Inertia.js on their website.

### What is this module for?

This module provides the needed lifecycle and ajax responses to integrate Inertia.js
into a ColdBox app on the server. It will let you render Inertia responses, both
for the initial page visit and subsequent client-side transitions, as well as share
data on every Inertia request.

### Requirements, Installation, and Configuration

cbInertia requires ColdFusion 2016+ or Lucee 5+ and ColdBox 5.6.0+.

Install cbInertia into your ColdBox project using CommandBox.

```bash
box install cbInertia
```

By default, no configuration is needed. However, you can disable the automatic
registering of the `InertiaLifecycle` interceptor, the cbInertia application
helper, or the Controller decorator if you wish.  You can also customize the
view arguments for Inertia events.

The one setting you will likely modify is the `version` setting.  You can read
more about it below.

```
// config/ColdBox.cfc
moduleSettings = {
    "cbInertia": {
        "autoRegisterInterceptor": true,
        "autoRegisterHelpers": true,
        "autoRegisterControllerDecorator": true,
        "defaultViewArgs": {
            "view": "main/index",
            "module": "cbInertia"
        }
        "version": function() {
            return "";
        }
    }
}
```

### Usage

You use cbInertia from your handlers/controllers. You can either inject the
`Inertia` model using the `Inertia@cbInertia` dsl or you can use the automatically
loaded (by default) helper: `inertia()`. We'll cover both use cases, but the
choice is just a matter of style preference.

Once available in your handler, you render an Inertia route using the `render` method.

#### `render`

| Name      | Type   | Required | Default | Description                                                                           |
| --------- | ------ | -------- | ------- | ------------------------------------------------------------------------------------- |
| component | string | `true`   |         | The component name to render.                                                         |
| props     | struct | `false`  | `{}`    | Any props to inject in to the component. Any props passed will be serialized to json. |

```cfc
// handlers/Users.cfc
component {

    property name="inertia" inject="@cbInertia";

    function index( event, rc, prc ) {
        inertia.render( "Users/Index", {
            "users" = [ /* ... */ ]
        } );
    }

}
```

You can get an instance of `Inertia` by calling the `inertia()` helper function.

```cfc
// handlers/Users.cfc
component {

    function index( event, rc, prc ) {
        inertia().render( "Users/Index", {
            "users" = [ /* ... */ ]
        } );
    }

}
```

Since `render` is the most common method called, you can pass the arguments to
`render` directly to the `inertia()` helper function.

```cfc
// handlers/Users.cfc
component {

    function index( event, rc, prc ) {
        inertia( "Users/Index", {
            "users" = [ /* ... */ ]
        } );
    }

}
```

The other Inertia method you will use is the `share` method:

#### `share`

| Name  | Type   | Required | Default | Description                                                                                                    |
| ----- | ------ | -------- | ------- | -------------------------------------------------------------------------------------------------------------- |
| key   | string | `true`   |         | The key name for the shared property.                                                                          |
| value | any    | `true`   |         | The shared property value. This can also accept a closure. Closures will be evaluated just prior to rendering. |

The share method is used for values that should be available on every Inertia render.
A common example of this is the authenticated user (or `null` if there is none).
You can set up an interceptor to share your global values, and they will be available
on every Inertia render as a prop.

```cfc
inertia.share( "user", function() {
    return auth.check() ? // auth == cbauth
        auth.user().loadRelationship( "account" ).getMemento() :
        javacast( "null", "" );
} );
```

You can call `share` as many times as you need.

### Customizing the Inertia View

The default view that ships with cbInertia suits most use cases.  If you need
to use a different view for any reason, you can customize the view arguments
sent to the `setView` function using the `defaultViewArgs` setting.

```cfc
moduleSettings = {
    "cbInertia": {
        "defaultViewArgs": {
            "view": "custom/view/page"
        }
    }
};
```

### Controller Decorator

Inertia automatically registers a Controller decorator by default.  This
decorator is used to automate setting the status code for redirects for `PUT`,
`PATCH`, and `DELETE` verbs to 303. ([See here.](https://inertiajs.com/redirects#303-response-code))

If you choose not to use the controller decorator, you will need to ensure
that redirects from `PUT`, `PATCH`, and `DELETE` actions return a 303 status code.

```cfc
relocate( event = "home.index", statusCode = 303 );
```

### Code Splitting and ColdBox Elixir Integration

Using Pages creates a natural code splitting point. You can reduce the javascript
your users have to initially download and speed up your site by only delivering the
javascript for the page they are requesting. You can do this with ColdBox Elixir.

Here is an example client-side boilerplate for Vue.js

```js
import Vue from "vue";
import VueMeta from "vue-meta";
import PortalVue from "portal-vue";
import { InertiaApp } from "@inertiajs/inertia-vue";

Vue.config.productionTip = false;
Vue.use(InertiaApp);
Vue.use(PortalVue);
Vue.use(VueMeta);

let app = document.getElementById("app");

new Vue({
  metaInfo: {
    title: "Loading...",
    titleTemplate: "%s | My Inertia.js App"
  },
  render: h =>
    h(InertiaApp, {
      props: {
        initialPage: JSON.parse(app.dataset.page),
        resolveComponent: name =>
          import(
            /* webpackChunkName: "includes/js/pages/[request]" */ `@/Pages/${name}`
          ).then(module => module.default)
      }
    })
}).$mount(app);
```

The `webpackChunkName` will create each of the pages in a `includes/js/pages` directory
and use the current chunk name in place of `[request]`.

Additionally, you need to add a bit of Webpack config to combine the shared parts
of your pages together. For instance, if two pages each import a `Button` component
you have, you want a shared module for those components.

The configuration sample here will pull out all shared components from your `Pages`
directory into one file. You can tweak the configuration if your needs are different:

```js
const elixir = require("coldbox-elixir");

elixir.config.mergeConfig({
  optimization: {
    splitChunks: {
      cacheGroups: {
        shared: {
          chunks: "async",
          minChunks: 2,
          name: "includes/js/pages/shared"
        }
      }
    }
  }
});

module.exports = elixir(mix => {
  mix.css("app.css");
  mix.vue("app.js");
});
```

### versioning

cbInertia follows the [Inertia.js spec](https://inertiajs.com/the-protocol#asset-versioning)
for versioning.  If you are using ColdBox Elixir, use the following function
as the value for `version` in your `config/ColdBox.cfc`:

```cfc
moduleSettings = {
    "cbInertia": {
        "version": function() {
            return hash( fileRead( "/includes/rev-manifest.json" ) );
        }
    }
};
```

If you are using versioning with ColdBox Elixir (which is the default for a
production build), this will return a unique version string for cbInertia
to compare.
