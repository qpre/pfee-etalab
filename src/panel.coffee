$ = jQuery

$(document).ready ->
	$("#leaftr-generate").on 'click', () ->
		if $.isNumeric($("#width").val())
			console.log $("#width").val()
		if $.isNumeric($("#max_element").val())
			console.log $("#max_element").val()
		if $.isNumeric($("#related_width").val())
			console.log $("#related_width").val()
		if $.isNumeric($("#img_width").val())
			console.log $("#img_width").val()
		if $.isNumeric($("#max_title_length").val())
			console.log $("#max_title_length").val()
		false
	false