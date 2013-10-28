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

class Leaftr
    max_view: 0
    min_view: 0

    constructor: (@data, @div, @options) ->
        @div.css({
            'width' : @options.width
            'height' : @options.height
            'column-width' : '120px'
            '-webkit-column-width' : '120px'
            '-webkit-moz-width' : '120px'
        })

    display: ->
        self = this
        self.getViewMinMax()
        nb_element = 0
        for value in @data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        if nb_element++ < self.options.max_element
                            self.display_div related

        $('.leaftr-tile').each ->
            $(this).css({'width' : self.options.related_width})
            $(this).children().css({'width' : self.options.img_width})

    getViewMinMax: ->
        self = this
        for value in @data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        @max_view = related.view_count if related.view_count > @max_view
                        @min_view = related.view_count if @min_view == 0
                        @min_view = related.view_count if related.view_count < @min_view

    display_div: (tile) ->
        img = tile.image_url
        img = 'assets/img/notFound.png' if img == undefined
        url = tile.url
        name = tile.title
        name = '' if name == undefined

        ###        
        tile_coef = if tile.view_count > 0 then tile.view_count else 1
        console.log tile_coef
        tile_width =  @options.related_width * tile_coef
        ###

        if name.length > @options.max_title_length
            name = name.substr(0, @options.max_title_length) + '...'
        @div.append("<a target='_blank' href='" + url + "'><div class='leaftr-tile'><img src='" + img + "'>" + name + "</div></a>")

