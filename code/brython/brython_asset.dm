/datum/asset/simple/brython
	assets = list(
		"brython.js" = 'html/brython/brython.js',
		"brython_stdlib.js" = 'html/brython/brython_stdlib.js',
		"brython_temp.css" = 'html/brython/brython_temp.css'
	)

ADMIN_VERB(html_test, R_DEBUG, "View HTML BRYTHON", "Opens the runtime viewer.", ADMIN_CATEGORY_DEBUG)
	var/datum/asset/brython_asset = get_asset_datum(/datum/asset/simple/brython)
	brython_asset.send(user)
	var/html = {"
<html>
<head>
	<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
	<script type='text/javascript' src='[SSassets.transport.get_asset_url("brython.js")]'>
	</script>
	<script type='text/javascript' src='[SSassets.transport.get_asset_url("brython_stdlib.js")]'>
	</script>
	<title>Some Funny Test Thing</title>
	<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url("brython_temp.css")]'>
</head>
<body>

<script type='text/python'>

from browser import document, html
from interpreter import Inspector

# Construction de la calculatrice
calc = html.TABLE()
calc <= html.TR(html.TH(html.DIV('0', id='result'), colspan=3) +
				html.TD('C') + html.TD('D'))
lines = \['789/', '456*', '123-', '0.=+']

calc <= (html.TR(html.TD(x) for x in line) for line in lines)

document <= calc

result = document\['result'] # direct acces to an element by its id

def action(event):
	#'''Handles the 'click' event on a button of the calculator.'''
	# The element the user clicked on is the attribute 'target' of the
	# event object
	element = event.target
	# The text printed on the button is the element's 'text' attribute
	value = element.text
	if value not in '=CD':
		# update the result zone
		if result.text in \['0', 'error']:
			result.text = value
		else:
			result.text = result.text + value
	elif value == 'C':
		# reset
		result.text = '0'
	elif value == 'D':
		Inspector()
	elif value == '=':
		# execute the formula in result zone
		try:
			result.text = eval(result.text)
		except:
			result.text = 'error'

# Associate function action() to the event 'click' on all buttons
for button in document.select('td'):
	button.bind('click', action)
</script>

</body>
</html>"}

	user << browse(html, "window=somefunnything;size=600x600")
