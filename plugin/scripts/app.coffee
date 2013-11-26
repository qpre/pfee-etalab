requirejs.config({
    baseUrl: "bower_components",
    paths: {
      "app": "../scripts/app",
      'jquery': 'jquery/jquery'
    }
})

requirejs(["app/main"])