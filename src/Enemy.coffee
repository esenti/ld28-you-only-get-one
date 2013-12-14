class Enemy extends Rect
	constructor: (@x, @y) ->
		@hp = 30
		@speed = 170
		@animation = new Animation('spider', 1)
		@alive = 0
		@toPlayer = 45

		@deadSprite = new Image()
		@deadSprite.src = 'assets/img/spider_dead.png'
		super(@x, @y, 32, 32)

	update: (delta) ->

		if @hp <= 0
			@remove = true
			bodies.push(new Body(@x, @y, @deadSprite))
			player.exp += 100

		@alive += delta

		if @collidesWith(player.x, player.y, 32, 32)
			player.hit()
			return

		@toPlayer = new Vector(player.x - @x, player.y - @y)
		@toPlayer.normalize()

		newX = @x + @toPlayer.x * delta * @speed
		newY = @y + @toPlayer.y * delta * @speed

		for enemy in enemies
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

		ctx.restore()

	hit: ->
		@hp -= 2
		return true