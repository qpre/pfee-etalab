$ = jQuery

$(document).ready ->
	code = '
&lt;link rel="stylesheet" type="text/css" href="http://pfee.leaftr.com/assets/style/leaftr.css"&gt;\n
&lt;script type="text/javascript"\n
            data-main="scripts/app"\n
            src="http://pfee.leaftr.com/bower_components/requirejs/require.js"&gt;&lt;/script&gt;\n
&lt;script type="text/javascript"&gt;\n
  require([\'app/main\'], function(app) {\n
     $(\'#leaftr\').leaftr({\n
##REPLACE##\n
     });\n
  });\n
&lt;/script&gt;\n
'

	$("input").keyup () ->
		options = ''
		if $.isNumeric($("#width").val())
			options += '\twidth: "' + $("#width").val() + 'px",\n'

		if $.isNumeric($("#max_element").val())
			options += '\tmax_element: ' + $("#max_element").val() + ',\n'

		if $.isNumeric($("#related_width").val())
			options += '\trelated_width: "' + $("#related_width").val() + 'px",\n'

		if $.isNumeric($("#img_width").val())
			options += '\timg_width: "' + $("#img_width").val() + 'px",\n'

		if $.isNumeric($("#max_title_length").val())
			options += '\tmax_title_length: ' + $("#max_title_length").val() + ',\n'
            
		if $.isNumeric($("#city_code").val())
			options += '\tcity_code: [\'' + $("#city_code").val() + '\'],\n'
            
		if $.isNumeric($("#department_code").val())
			options += '\tdepartment_code: [\'' + $("#department_code").val() + '\'],\n'

		if options.charAt(options.length - 2) == ','
			options = options.substr(0, options.length - 2);

		$("#leaftr-generated-code>pre>code").html(code.replace("##REPLACE##", options));
		$('#leaftr-generated-code>pre>code').each (i, e) -> hljs.highlightBlock(e)

		false
	false