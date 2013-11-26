define(['jquery'], ($) ->
  class Wheel
    parent: null
    
    constructor: (@parent) ->
      
    display: () ->
      @parent.append("<img id='leaftr-wheel' src='assets/img/loading.gif'>")
    
    hide: () ->
      $('#leaftr-wheel').remove()
)
