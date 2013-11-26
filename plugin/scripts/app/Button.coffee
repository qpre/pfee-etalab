define(['jquery'], ($) ->
  class Button
    container: null
    parent: null
    callback: null
    
    constructor: (@container, @callback) ->
      
    display: () ->
      @container.append("<img id='leaftr-load-button' width='64' src='assets/img/loadButton.png'>")
      $('#leaftr-load-button').click(@callback)
    
    hide: () ->
      $('#leaftr-load-button').remove()
)