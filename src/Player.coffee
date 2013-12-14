class Player extends Rect

	constructor: (@x, @y) ->
		@hp = 30
		@exp = 0
		@speed = 100
		@animation = new Animation('player', 2)
		@alive = 0
		super(@x, @y, 32, 32)

	update: (delta) ->
		@alive += delta

		screenX = camera.transformX(@x) + 16
		screenY = camera.transformY(@y) + 16

		@vec = new Vector(mouse.pos.x - screenX, mouse.pos.y - screenY)
		@vec.normalize()

	hit: ->
		@hp -= 1

	draw: (ctx) ->
		ctx.save()
		ctx.translate(camera.transformX(@x) + 16, camera.transformY(@y) + 16)

		ctx.rotate(@vec.angle() * Math.PI / 180);

		ctx.translate(-camera.transformX(@x) - 16, -camera.transformY(@y) - 16)
		ctx.drawImage(@animation.getFrame(@alive), camera.transformX(@x), camera.transformY(@y))

		ctx.restore()