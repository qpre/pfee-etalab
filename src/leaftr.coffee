$ = jQuery

$.fn.extend
    leaftr: (options) ->
        plugin_div = this

        settings =
            width: '600px'
            max_element: 10
            related_width: '100px'
            img_width: '100px'
            max_description_length: 50

        settings = $.extend settings, options

        $.ajax 'http://cow.etalab2.fr/api/1/datasets/related',
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
        url = tile.url
        console.log tile
        name = tile.description
        name = '' if name == undefined

        if name.length > @options.max_description_length
            name = name.substr(0, @options.max_description_length) + '...'
        @div.append("<a target='_blank' href='" + url + "'><div class='leaftr-tile'><img src='" + img + "'>" + name + "</div></a>")

