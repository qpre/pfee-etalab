$ = jQuery

$.fn.extend
    leaftr: (options) ->
        plugin_div = this

        settings =
            width: '600px'
            height: '600px'
            max_element: 10
            related_width: '100px'
            img_width: '100px'
            max_title_length: 50
            city_code: []
            department_code: []

        settings = $.extend settings, options
        
        url = 'http://cow.etalab2.fr/api/1/datasets/related'
        
        settings.city_code.forEach((city) ->
            unless city == 0 then url += '?territory=CommuneOfFrance/' + city)
            
        settings.department_code.forEach((department) ->
            unless department == 0 then url += '?territory=DepartmentOfFrance/' + department)
            
        $.ajax url,
            type: 'GET'
            dataType: 'json'
            error: (jqXHR, textStatus, errorThrown) ->
                console.log "AJAX Error: #{textStatus}"
            success: (data, textStatus, jqXHR) ->
                leaftr = new Leaftr(data, plugin_div, settings)
                leaftr.displayFromOffset(0)

###
    TILE CLASS
	Delegate for the items' actions
###

class Tile
    clss: ''

    constructor: (data) ->
        @view_count = data.view_count
        @img = data.image_url
        @img = 'assets/img/notFound.png' if @img == undefined
        @url = data.url
        @name = data.title
        @name = '' if @name == undefined

    display: (parent, @offset) ->
        parent.append("<a target='_blank' href='" + @url + "' id='item" + @offset + "'><div class='" + @clss + "'><img src='" + @img + "'><div class='leaftr-tile-hover'>" + @name + "</div></div></a>")

###
    LEAFTR MAIN CLASS
	Handling the containers' lifecycle
###

class Leaftr
    tiles: null
    max_view: 0
    min_view: 0
    isLoading: false

    constructor: (@data, @div, @options) ->
        @loadTiles()
        @div.css({
            'width' : @options.width
            'max-height' : @options.height
        })
        @div.masonry({
          #columnWidth: @options.related_width
          itemSelector: '.item'
          gutter: 5
        })

    loadTiles: () ->
        @tiles = new Array()
        self = this
        for value in @data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        self.tiles.push(new Tile(related))

    setClasses: () ->
        for tile in @tiles
            if @max_view == 0
                tile.clss = 'item'
            else
                if tile.view_count < (@max_view / 2)
                    tile.clss = 'item'
                if tile.view_count >= (@max_view / 2)
                    tile.clss = 'item w2'

    getViewMinMax: ->
        self = this
        for value in @data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        self.max_view = related.view_count if related.view_count > self.max_view
                        self.min_view = related.view_count if self.min_view == 0
                        self.min_view = related.view_count if related.view_count < self.min_view

    displayFromOffset: (offset) ->
        @getViewMinMax()
        @setClasses()
        @offset = offset

		    # Add max_elements to the div
        for i in [offset..(offset + @options.max_element)] by 1
            @tiles[i].display(@div, i)
            @div.masonry('appended', $('#item'+i))

        self = this

		    # Let's apply some masonry when the heights are ready
        @div.imagesLoaded(() ->
                console.log 'images loaded'
                self.isLoading = false
                self.div.masonry('layout')
            )

		    # let's listen to that scroll thing
        @div.scroll(() ->
            scrollPos = (self.div[0].scrollHeight - self.div.scrollTop())
            if (scrollPos - self.div.height() == 0)
                if ((self.offset + 10 < self.tiles.length) && (self.isLoading != true))
                    self.displayFromOffset(self.offset + 10)
                    self.isLoading = true
            )
