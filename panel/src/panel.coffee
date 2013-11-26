$ = jQuery

$(document).ready ->
	code = '
&lt;link rel="stylesheet" type="text/css" href="http://pfee.leaftr.com/leaftr.css"&gt;\n
&lt;script type="text/javascript" src="http://codeorigin.jquery.com/jquery-1.10.2.min.js"&gt;&lt;/script&gt;\n
&lt;script type="text/javascript" src="http://pfee.leaftr.com/scripts/lib/imagesloaded.pkgd.min.js"&gt;&lt;/script&gt;\n
&lt;script type="text/javascript" src="http://pfee.leaftr.com/scripts/lib/masonry.js"&gt;&lt;/script&gt;\n
&lt;script type="text/javascript" src="http://pfee.leaftr.com/scripts/plugin/leaftr.js"&gt;&lt;/script&gt;\n
&lt;script type="text/javascript"&gt;\n
	$(document).ready(function() { \n
		$(\'#leaftr\').leaftr({\n
##REPLACE## \n
		});\n
	}); \n
&lt;/script&gt;\n
'

	$("input").keyup () ->
		options = ''
		if $.isNumeric($("#width").val())
			options += '\t\t\twidth: "' + $("#width").val() + 'px",\n'

		if $.isNumeric($("#max_element").val())
			options += '\t\t\tmax_element: ' + $("#max_element").val() + ',\n'

		if $.isNumeric($("#related_width").val())
			options += '\t\t\trelated_width: "' + $("#related_width").val() + 'px",\n'

		if $.isNumeric($("#img_width").val())
			options += '\t\t\timg_width: "' + $("#img_width").val() + 'px",\n'

		if $.isNumeric($("#max_title_length").val())
			options += '\t\t\tmax_title_length: ' + $("#max_title_length").val() + ',\n'
            
		if $.isNumeric($("#city_code").val())
			options += '\t\t\tcity_code: [\'' + $("#city_code").val() + '\'],\n'
            
		if $.isNumeric($("#department_code").val())
			options += '\t\t\tdepartment_code: [\'' + $("#department_code").val() + '\'],\n'

		if options.charAt(options.length - 2) == ','
			options = options.substr(0, options.length - 2);

		$("#leaftr-generated-code>pre>code").html(code.replace("##REPLACE##", options));
		$('#leaftr-generated-code>pre>code').each (i, e) -> hljs.highlightBlock(e)

		false
	false