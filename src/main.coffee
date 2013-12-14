c = document.getElementById('draw')
ctx = c.getContext('2d')

delta = 0
now = 0
before = Date.now()

sec = 0
frames = 0
fps = 0
enemies = []

c.width = window.innerWidth
c.height = window.innerHeight

keysDown = {}
mouse =
	down: false
	pos:
		x: 0
		y: 0


nextEnemy = 0


addEventListener("keydown", (e) ->
	keysDown[e.keyCode] = true
	console.log(e.keyCode)
, false)

addEventListener("keyup", (e) ->
	delete keysDown[e.keyCode]
, false)

addEventListener("mousemove", (e) ->
	mouse.pos = {x: e.x, y: e.y}
)

addEventListener("mousedown", (e) ->
	mouse.down = true
)

addEventListener("mouseup",(e) ->
	mouse.down = false
)

bodies = []

dirt = new Image()
dirt.src = 'assets/img/dirt.png'


bullets = []

player = new Player(0, 0)

grd = ctx.createRadialGradient(c.width / 2, c.height / 2, 300, c.width / 2, c.height / 2, 600)

grd.addColorStop(0, 'rgba(0, 0, 0, 0)')
grd.addColorStop(1, 'rgba(0, 0, 0, 0.9)')

camera =
	x: 0
	y: 0
	transformX: (x) ->
		return x - @x + c.width / 2
	transformY: (y) ->
		return y - @y + c.height / 2

setDelta = ->
	now = Date.now()
	delta = (now - before) / 1000
	before = now;

update = ->
	setDelta()

	sec += delta
	frames += 1

	if sec >= 1
		fps = frames
		frames = 0
		sec = 0

	if player.hp <= 0
		ctx.font = '120px Visitor'
		ctx.fillText("Game over", 300, 300)
		return

	nextEnemy -= delta
	if nextEnemy < 0
		nextEnemy = 2
		where = Math.random()
		if where < 0.5
			x = player.x + (Math.random() - 0.5) * c.width * 1.5
			y = player.y + if Math.random() < 0.5 then c.height + 100 else -c.height - 100
		else
			x = player.x + if Math.random() < 0.5 then c.width + 100 else -c.width - 100
			y = player.y + (Math.random() - 0.5) * c.height * 1.5
		enemies.push(new Enemy(x, y, new Animation('spider', 3)))

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

	player.x = newPlayer.x
	player.y = newPlayer.y



	if keysDown[69]
		enemies.push(new Enemy(player.x + 100, player.y - 100, new Animation('spider', 3)))

	camera.x = player.x + 16
	camera.y = player.y + 16

	if mouse.down
		vec = new Vector(10, 0)
		vec.rotate(player.vec.angle())
		bullets.push(new Bullet(player.x + 16 + vec.x, player.y + 16 + vec.y, player.vec.x, player.vec.y))


	i = 0
	while i < enemies.length
		if enemies[i].remove
			enemies.splice(i, 1)
			i -= 1

		i += 1


	i = 0
	while i < bullets.length
		if bullets[i].remove
			bullets.splice(i, 1)
			i -= 1

		i += 1

	for enemy in enemies
		enemy.update(delta)

	for bullet in bullets
		bullet.update(delta)

	player.update(delta)

	draw(delta)

	window.requestAnimationFrame(update)


draw = (delta) ->
	ctx.clearRect(0, 0, c.width, c.height)

	for i in [-15..15]
		for j in [-10..10]
			ctx.drawImage(dirt, camera.transformX(i * dirt.width), camera.transformY(j * dirt.height))


	screenX = camera.transformX(player.x) + 16
	screenY = camera.transformY(player.y) + 16

	for body in bodies
		body.draw(ctx)

	for enemy in enemies
		enemy.draw(ctx)

	for bullet in bullets
		bullet.draw(ctx)

	player.draw(ctx)

	ctx.save()

	ctx.fillStyle = grd
	ctx.fillRect(0, 0, c.width, c.height)


	ctx.font = '16px Visitor'
	ctx.fillStyle = 'white'
	ctx.fillText(fps, 10, 10)

	ctx.font = '22px Visitor'
	ctx.fillText("#{player.hp} HP", 20, 20)
	ctx.fillText("#{player.exp} XP", 20, 40)


	ctx.restore()


update()