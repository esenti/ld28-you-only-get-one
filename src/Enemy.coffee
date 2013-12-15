class Enemy extends Rect
	constructor: (@x, @y, @animation) ->
		@hp = 15
		@speed = 170 + player.level * 10
		@alive = 0
		@toHit = 0
		@hitPower = 1 + Math.floor(player.level / 4)

		@deadSprite = new Image()
		@deadSprite.src = 'assets/img/spider_dead.png'

		@bloodSprite = new Image()
		@bloodSprite.src = 'assets/img/spider_blood.png'
		super(@x, @y, 32, 32)

	update: (delta) ->

		if @toHit > 0
			@toHit -= delta

		if @hp <= 0
			resourceManager.getSound('enemy_dead.wav').play()
			@remove = true
			window.bodies.push(new Body(@x, @y, @deadSprite))
			window.player.exp += 100

		@alive += delta

		if @collidesWith(window.player.x, window.player.y, 32, 32)
			if @toHit <= 0
				@toHit = 0.5
				window.player.hit(@hitPower)
			return

		@toPlayer = new Vector(window.player.x - @x, window.player.y - @y)
		@toPlayer.normalize()

		newX = @x + @toPlayer.x * delta * @speed
		newY = @y + @toPlayer.y * delta * @speed

		for enemy in window.enemies
			if enemy == this
				continue

			if @collidesWithRect(enemy)

				fromOther = new Vector(@x - enemy.x, @y - enemy.y)
				fromOther.normalize()
				newX = @x + fromOther.x * delta * @speed / 3
				newY = @y + fromOther.y * delta * @speed / 3

				break

		@x = newX
		@y = newY

	draw: (ctx) ->
		ctx.save()
		ctx.translate(camera.transformX(@x) + 16, camera.transformY(@y) + 16)

		ctx.rotate(@toPlayer.angle() * Math.PI / 180);

		ctx.translate(-camera.transformX(@x) - 16, -camera.transformY(@y) - 16)

		ctx.drawImage(@animation.getFrame(@alive), camera.transformX(@x), camera.transformY(@y))

		if @hurt
			@hurt = false
			# ctx.beginPath()
			# ctx.arc(camera.transformX(@x + 16), camera.transformY(@y + 16), 4, 0, Math.PI * 2)
			# ctx.fill()

		ctx.restore()

	hit: (power) ->
		@hurt = true
		@hp -= power
		if @hp > 0
			resourceManager.getSound('enemy_hurt.wav').play()
			window.bodies.push(new Body(@x + 12, @y + 12, @bloodSprite))

		return true