define(["jquery", 'app/Leaftr'], ($, Leaftr) ->
      $.fn.extend
          leaftr: (options) ->
              plugin_div = this

              settings =
                  width: '100%'
                  height: '100%'
                  max_element: 10
                  related_width: '100px'
                  img_width: '100px'
                  max_title_length: 50
                  city_code: []
                  department_code: []

              settings = $.extend settings, options
              leaftr = new Leaftr(plugin_div, settings)
);