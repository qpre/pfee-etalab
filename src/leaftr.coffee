$ = jQuery

$.fn.extend
    leaftr: (options) ->
        $.ajax 'http://cow.etalab2.fr/api/1/datasets/related',
            type: 'GET'
            dataType: 'json'
            error: (jqXHR, textStatus, errorThrown) ->
                console.log "AJAX Error: #{textStatus}"
            success: (data, textStatus, jqXHR) ->
                for value in data.value
                    do (value) ->
                        img = value.related[0].image_url
                        $("#leaftr").append "<div>" + "<img src='" + img + "'>" + value.name + "</div>"
                        console.log value
