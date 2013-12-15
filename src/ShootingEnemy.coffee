class ShootingEnemy extends Enemy

	constructor: (@x, @y, @animation) ->
		super(@x, @x, @animation)

		@deadSprite = new Image()
		@deadSprite.src = 'assets/img/shooter_dead.png'

	update: (delta) ->

		if @toHit > 0
			@toHit -= delta

		if @hp <= 0
			resourceManager.getSound('enemy_dead.wav').play()
			@remove = true
			window.bodies.push(new Body(@x, @y, @deadSprite))
			window.player.exp += 200

		@alive += delta

		if @collidesWith(window.player.x, window.player.y, 32, 32)
			if @toHit <= 0
				@toHit = 2
				window.player.hit(@hitPower)
			return

		@toPlayer = new Vector(window.player.x - @x, window.player.y - @y)

		if @toPlayer.length() < 300
			@toPlayer.normalize()
			if @toHit <= 0
				@toHit = 2
				resourceManager.getSound('enemy_shoot.wav').play()
				window.bullets.push(new EnemyBullet(@x + 16, @y + 16, @toPlayer.x, @toPlayer.y))
		else
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