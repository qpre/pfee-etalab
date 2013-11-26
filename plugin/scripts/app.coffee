requirejs.config({
    "baseUrl": "scripts/lib",
    "paths": {
      "app": "../../build/scripts/app",
      "jquery": "jquery",
      "masonry": "masonry",
      "imagesLoaded": "imagesloaded.pkgd.min"
    }
})

requirejs(["app/main"])