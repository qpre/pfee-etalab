define(()->
  #
  #  TILE CLASS
	#  A delegate for the items' actions
  #
  class Tile
      clss: ''

      constructor: (data, @parent, @offset) ->
          @view_count = data.view_count
          @img = data.image_url
          @img = '../assets/img/notFound.png' if @img == undefined
          @url = data.url
          @name = data.title
          @name = '' if @name == undefined

      display: () ->
          @parent.append("<a target='_blank' href='" + @url + "' id='item" + @offset + "'><div class='" + @clss + "'><img src='" + @img + "'><div class='item-hover'><p><strong>" + @name + "</strong></p></div></div></a>")

)