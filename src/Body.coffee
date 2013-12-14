class Body
	constructor: (@x, @y, @sprite) ->

	draw: (ctx) ->
		ctx.save()
		ctx.drawImage(@sprite, camera.transformX(@x), camera.transformY(@y))
		ctx.restore()