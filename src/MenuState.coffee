class MenuState extends State

	enter: ->

	update: (delta) ->
		if mouse.click
			window.nextState = window.gameState

	draw: (ctx) ->
		ctx.save()
		ctx.fillStyle = 'black'
		ctx.fillRect(0, 0, c.width, c.height)
		ctx.fillStyle = 'white'

		ctx.textAlign = 'center'
		ctx.textBaseline = 'middle'
		ctx.font = '52px Visitor'
		ctx.fillText("Start", c.width / 2, c.height / 2)

		ctx.textAlign = 'center'
		ctx.textBaseline = 'bottom'
		ctx.font = '18px Visitor'
		ctx.fillStyle = '#555555'
		ctx.fillText("ld28/esenti", c.width / 2, c.height - 10)


		ctx.restore()