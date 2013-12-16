class GameState extends State

	constructor: ->
		window.player = new Player(0, 0)

	enter: ->
		@nextEnemy = 0
		window.bodies = []
		window.bullets = []
		window.enemies = []
		window.player = new Player(0, 0)
		window.shake = 0
		@gameover = false
		@powerups = []

		@powerupRects = [
			{
				x: c.width / 2 - 128 - 32 - 60
				y: c.height / 2 - 64 - 16
				width: 128 + 32
				height: 128 + 32
				hl: false
			},
			{
				x: c.width / 2 + 60
				y: c.height / 2 - 64 - 16
				width: 128 + 32
				height: 128 + 32
				hl: false
			}
		]


	update: (delta) ->

		if window.player.hp <= 0
			if not @gameover
				resourceManager.getSound('gameover.wav').play()
			@gameover = true

			if mouse.click
				window.nextState = window.menuState

			return

		if window.player.leveled

			if @powerups.length == 0 and powerups.length > 0

				index = Math.round(Math.random() * (powerups.length - 1))
				@powerups.push(powerups[index])
				window.powerups.splice(index, 1)

				index = Math.round(Math.random() * (powerups.length - 1))
				@powerups.push(powerups[index])
				window.powerups.splice(index, 1)


			if @powerups.length > 0
				ret = true
				for rect, i in @powerupRects
					if mouse.pos.x > rect.x and mouse.pos.x < rect.x + rect.width and mouse.pos.y > rect.y and mouse.pos.y < rect.y + rect.height
						if mouse.click
							@powerups[i].use()
							ret = false
							break
						rect.hl = true
					else
						rect.hl = false

				if ret
					return

				@powerups = []

		@nextEnemy -= delta
		if @nextEnemy < 0
			@nextEnemy = 3 - player.level * 0.15

			if Math.random() > 0.5
				x = player.x + (Math.random() - 0.5) * c.width * 1.5
				y = player.y + if Math.random() < 0.5 then c.height + 100 else -c.height - 100
			else
				x = player.x + if Math.random() < 0.5 then c.width + 100 else -c.width - 100
				y = player.y + (Math.random() - 0.5) * c.height * 1.5

			if Math.random() > 0.3
				window.enemies.push(new Enemy(x, y, new Animation('spider', 3)))
			else
				window.enemies.push(new ShootingEnemy(x, y, new Animation('shooter', 3)))

		newPlayer = {x: player.x, y: player.y}

		if keysDown[65]
			newPlayer.x = player.x - delta * player.speed
		if keysDown[68]
			newPlayer.x = player.x + delta * player.speed
		if keysDown[87]
			newPlayer.y = player.y - delta * player.speed
		if keysDown[83]
			newPlayer.y = player.y + delta * player.speed

		for enemy in enemies
			if enemy.collidesWith(newPlayer.x, newPlayer.y, 32, 32)
				newPlayer.x = player.x
				newPlayer.y = player.y
				break

		window.player.x = newPlayer.x
		window.player.y = newPlayer.y

		camera.x = player.x + 16
		camera.y = player.y + 16

		if window.shake > 0
			window.shake -= delta
			camera.x += (Math.random() - 0.5) * 5
			camera.y += (Math.random() - 0.5) * 5

		if mouse.down
			if player.toShoot <= 0

				resourceManager.getSound('shoot.wav').play()
				player.toShoot = 1 / player.fireRate
				vec = new Vector(10, 0)
				vec.rotate(player.vec.angle())
				bullets.push(new Bullet(player.x + 16 + vec.x, player.y + 16 + vec.y, player.vec.x, player.vec.y))


		i = 0
		while i < window.enemies.length
			if window.enemies[i].remove
				window.enemies.splice(i, 1)
				i -= 1

			i += 1


		i = 0
		while i < window.bullets.length
			if window.bullets[i].remove
				window.bullets.splice(i, 1)
				i -= 1

			i += 1

		for enemy in window.enemies
			enemy.update(delta)

		for bullet in window.bullets
			bullet.update(delta)

		window.player.update(delta)

	draw: (ctx) ->

		dirt = resourceManager.getImage('dirt.png')

		x_num = Math.floor(player.x / dirt.width)
		y_num = Math.floor(player.y / dirt.height)

		for i in [x_num - 3..x_num + 3]
			for j in [y_num - 3..y_num + 3]
				ctx.drawImage(dirt, camera.transformX(i * dirt.width), camera.transformY(j * dirt.height))


		for body in window.bodies
			body.draw(ctx)

		for enemy in window.enemies
			enemy.draw(ctx)

		for bullet in window.bullets
			bullet.draw(ctx)

		window.player.draw(ctx)

		ctx.save()

		ctx.fillStyle = grd
		ctx.fillRect(0, 0, c.width, c.height)

		ctx.fillStyle = 'white'
		ctx.textAlign = 'left'
		ctx.font = '22px Visitor'
		ctx.fillText("HP", 20, 20)
		ctx.fillStyle = '#888888'
		ctx.fillRect(50, 10, 200, 10)
		ctx.fillStyle = 'white'
		ctx.fillRect(50, 10, window.player.hp / window.player.maxHp * 200, 10)
		ctx.fillStyle = '#333333'
		ctx.font = '16px Visitor'
		ctx.textAlign = 'center'
		ctx.fillText("#{player.hp} / #{player.maxHp}", 150, 19)

		ctx.textAlign = 'left'
		ctx.font = '22px Visitor'
		ctx.fillStyle = 'white'
		ctx.fillText("XP", 20, 40)
		ctx.fillStyle = '#888888'
		ctx.fillRect(50, 30, 200, 10)
		ctx.fillStyle = 'white'
		ctx.fillRect(50, 30, window.player.exp / window.player.expToLevel * 200, 10)
		ctx.fillStyle = '#333333'
		ctx.font = '16px Visitor'
		ctx.textAlign = 'center'
		ctx.fillText("#{player.exp} / #{player.expToLevel}", 150, 39)


		ctx.fillStyle = 'white'
		ctx.textAlign = 'center'
		ctx.font = 'bold 40px Visitor'
		ctx.fillText("lvl #{player.level}", c.width / 2, 40)

		if @gameover
			ctx.textAlign = 'center'
			ctx.textBaseline = 'middle'
			ctx.font = '120px Visitor'
			ctx.fillStyle = 'white'
			ctx.fillText("Game over", c.width / 2, c.height / 2)

		if player.leveled and @powerups.length > 0

			@powerupRects[0].x = c.width / 2 - 128 - 32 - 60
			@powerupRects[0].y = c.height / 2 - 64 - 16
			@powerupRects[1].x = c.width / 2 + 60
			@powerupRects[1].y = c.height / 2 - 64 - 16

			ctx.fillStyle = 'rgba(0, 0, 0, 0.4)'
			ctx.fillRect(0, 0, c.width, c.height)
			ctx.fillStyle = 'white'
			ctx.textAlign = 'center'
			ctx.font = '40px Visitor'
			ctx.fillText('Level up!', c.width / 2, c.height / 2 - 160)
			ctx.font = '32px Visitor'
			ctx.fillText('You only get one:', c.width / 2, c.height / 2 - 120)
			ctx.fillText('or', c.width / 2, c.height / 2)

			ctx.fillStyle = if @powerupRects[0].hl then 'rgba(155, 155, 155, 0.9)' else 'rgba(155, 155, 155, 0.4)'
			ctx.fillRect(@powerupRects[0].x, @powerupRects[0].y, @powerupRects[0].width, @powerupRects[0].height)
			ctx.drawImage(resourceManager.getImage(@powerups[0].sprite), c.width / 2 - 128 - 16 - 60, c.height / 2 - 64)
			ctx.fillStyle = 'white'
			ctx.textAlign = 'right'
			ctx.fillText(@powerups[0].name, c.width / 2 - 60, c.height / 2 + 128)

			ctx.fillStyle = if @powerupRects[1].hl then 'rgba(155, 155, 155, 0.9)' else 'rgba(155, 155, 155, 0.4)'
			ctx.fillRect(@powerupRects[1].x, @powerupRects[1].y, @powerupRects[1].width, @powerupRects[1].height)
			ctx.drawImage(resourceManager.getImage(@powerups[1].sprite), c.width / 2 + 16 + 60, c.height / 2 - 64)
			ctx.fillStyle = 'white'
			ctx.textAlign = 'left'
			ctx.fillText(@powerups[1].name, c.width / 2 + 60, c.height / 2 + 128)

		ctx.restore()
