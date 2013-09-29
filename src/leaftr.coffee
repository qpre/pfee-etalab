$ = jQuery

$.fn.extend
    leaftr: (options) ->
        plugin_div = this

        settings =
            min_width: '75px'
            max_width: '120px'

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

    max_view = 0
    min_view = 0

    constructor: (@data, @div, @options) ->

    display: ->
        self = this
        self.getViewMinMax()
        # for value in @data.value
        #     do (value) ->
        #         img = value.related[0].image_url
        #         self.display_div img, value.name

    getViewMinMax: ->
        self = this
        for value in @data.value
            do (value) ->
                for related in value.related
                    do (related) ->
                        @max_view = related.view_count if related.view_count > @max_view
                        @min_view = related.view_count if @min_view == 0
                        @min_view = related.view_count if related.view_count < @min_view
        console.log @max_view
        console.log @min_view

    display_div: (img, name) ->
        @div.append "<div>" + "<img src='" + img + "'>" + name + "</div>"