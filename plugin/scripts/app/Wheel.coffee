define(['jquery'], ($) ->
  class Wheel
    parent: null
    
    constructor: (@parent) ->
      
    display: () ->
      @parent.append("<div id='leaftr-wheel'><img src='assets/img/loading.gif'></div>")
    
    hide: () ->
      $('#leaftr-wheel').remove()
)
