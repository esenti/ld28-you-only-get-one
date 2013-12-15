class EnemyBullet extends Rect
	constructor: (@x, @y, @dx, @dy) ->
		@ttl = 5
		@speed = 300
		super(@x, @y, 8, 8)

	update: (delta) ->

		@.x += @.dx * delta * @speed
		@.y += @.dy * delta * @speed

		if @collidesWithRect(window.player)
			window.player.hit(5)
			@remove = true

		@ttl -= delta

		if @ttl <= 0
			@remove = true

	draw: (ctx) ->
		ctx.save()
		ctx.fillStyle = "#ff009c"
		ctx.fillRect(camera.transformX(@x), camera.transformY(@y), 8, 8)
		ctx.restore()