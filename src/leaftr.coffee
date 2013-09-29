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
                leaftr = new Leaftr settings
                for value in data.value
                    do (value) ->
                        img = value.related[0].image_url
                        leaftr.display plugin_div, img, value.name

class Leaftr

    constructor: (@options={}) ->

    display: (div, img, name) ->
        div.append "<div>" + "<img src='" + img + "'>" + name + "</div>"