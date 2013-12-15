class Bullet extends Rect
	constructor: (@x, @y, @dx, @dy) ->
		@ttl = player.bulletTtl
		@speed = player.bulletSpeed
		super(@x, @y, 10, 10)

	update: (delta) ->

		@.x += @.dx * delta * @speed
		@.y += @.dy * delta * @speed

		for enemy in window.enemies
			if @collidesWithRect(enemy)
				if enemy.hit(player.bulletPower)
					@remove = true
					break

		@ttl -= delta

		if @ttl <= 0
			@remove = true

	draw: (ctx) ->
		ctx.save()
		ctx.fillStyle = "#ffffaa"
		ctx.fillRect(camera.transformX(@x), camera.transformY(@y), 5, 5)
		ctx.restore()