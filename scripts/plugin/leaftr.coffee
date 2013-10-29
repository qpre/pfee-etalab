$ = jQuery

$.fn.extend
    leaftr: (options) ->
        plugin_div = this

        settings =
            width: '600px'
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
                leaftr.display()

###
    TILE CLASS
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

    display: (parent) ->
        parent.append("<a target='_blank' href='" + @url + "'><div class='" + @clss+ "'><img src='" + @img + "'><div class='leaftr-tile-hover'>" + @name + "</div></div></a>")

###
    LEAFTR MAIN CLASS
###

class Leaftr
    tiles: null
    max_view: 0
    min_view: 0

    constructor: (@data, @div, @options) ->
        @loadTiles()
        @div.css({
            'width' : @options.width
            #'height' : @options.height
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

            console.log "class: " + tile.clss + " for view_count: " + tile.view_count

    getViewMinMax: ->
        self = this
        for value in @data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        self.max_view = related.view_count if related.view_count > self.max_view
                        self.min_view = related.view_count if self.min_view == 0
                        self.min_view = related.view_count if related.view_count < self.min_view

    display: () ->
        @getViewMinMax()
        @setClasses()
        console.log @max_view
        console.log @min_view

        for i in [0..@options.max_element] by 1
            @tiles[i].display(@div)

        @div.masonry({
                columnWidth: 50
                itemSelector: '.item'
            })

        self = this
        @div.imagesLoaded(() ->
                console.log 'images loaded'
                self.div.masonry({
                    columnWidth: @options.related_width
                    itemSelector: '.item'
                    gutter: 5
                })
            )
        

    ###
    display_div: (tile) ->
        img = tile.image_url
        img = 'assets/img/notFound.png' if img == undefined
        url = tile.url
        name = tile.title
        name = '' if name == undefined

        if name.length > @options.max_title_length
            name = name.substr(0, @options.max_title_length) + '...'
        @div.append("<a target='_blank' href='" + url + "'><div class='leaftr-tile'><img src='" + img + "'><div class='leaftr-tile-hover'>" + name + "</div></div></a>")
    ###
