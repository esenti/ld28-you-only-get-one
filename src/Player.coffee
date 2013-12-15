class Player extends Rect

	constructor: (@x, @y) ->
		@hp = 30
		@maxHp = 30
		@exp = 0
		@expToLevel = 1000
		@speed = 100
		@animation = new Animation('player', 2)
		@alive = 0
		@leveled = false
		super(@x, @y, 32, 32)

	update: (delta) ->
		@alive += delta

		screenX = camera.transformX(@x) + 16
		screenY = camera.transformY(@y) + 16

		@vec = new Vector(mouse.pos.x - screenX, mouse.pos.y - screenY)
		@vec.normalize()

		@leveled = false
		if @exp >= @expToLevel
			@leveled = true
			@exp = @exp - @expToLevel
			@expToLevel = @expToLevel * 1.1

	hit: ->
		@hp -= 1

	draw: (ctx) ->
		ctx.save()
		ctx.translate(camera.transformX(@x) + 16, camera.transformY(@y) + 16)

		ctx.rotate(@vec.angle() * Math.PI / 180);

		ctx.translate(-camera.transformX(@x) - 16, -camera.transformY(@y) - 16)
		ctx.drawImage(@animation.getFrame(@alive), camera.transformX(@x), camera.transformY(@y))

		ctx.restore()