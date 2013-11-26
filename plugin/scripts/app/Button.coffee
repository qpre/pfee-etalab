define(['jquery'], ($) ->
  class Button
    parent: null
    callback: null
    
    constructor: (@parent, @callback) ->
      
    display: () ->
      @parent.append("<img id='leaftr-load-button' width='64' src='assets/img/loadButton.png'>")
      $('#leaftr-load-button').click(@callback())
    
    hide: () ->
      $('#leaftr-load-button').remove()
)