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
	click: false


window.powerups = [
	{
		name: '+10 max HP'
		sprite: 'heart'
		use: ->
			window.player.maxHp = window.player.maxHp + 10
			window.player.hp = window.player.maxHp
	},
	{
		name: 'HP regen'
		sprite: 'heart'
		use: ->
			toRegen = 10

			window.player.hooks.push((self, delta) ->
				toRegen -= delta
				if toRegen <= 0 and self.hp < self.maxHp
					toRegen = 10
					self.hp += 1
			)
	},
	{
		name: '+20% speed'
		sprite: 'speed'
		use: ->
			window.player.speed = window.player.speed * 1.2
	},
	{
		name: '2x fire rate'
		sprite: 'speed'
		use: ->
			window.player.fireRate = window.player.fireRate * 2
	},
	{
		name: 'stronger bullets'
		sprite: 'speed'
		use: ->
			window.player.bulletPower = window.player.bulletPower * 2
	},
	{
		name: 'faster bullets'
		sprite: 'speed'
		use: ->
			window.player.bulletSpeed = window.player.bulletSpeed * 2
	},
	{
		name: 'longer range'
		sprite: 'speed'
		use: ->
			window.player.bulletTtl = window.player.bulletTtl* 2
	},
	{
		name: 'better sight'
		sprite: 'eye'
		use: ->
			window.player.sight = window.player.sight * 1.5
			updateGradient()
	},
]

sounds =
	shoot: new Audio("assets/sound/shoot.wav")
	enemyHurt: new Audio("assets/sound/enemy_hurt.wav")
	playerHurt: new Audio("assets/sound/player_hurt.wav")
	levelUp: new Audio("assets/sound/levelup.wav")
	gameOver: new Audio("assets/sound/gameover.wav")
	enemyDead: new Audio("assets/sound/enemy_dead.wav")
	enemyShoot: new Audio("assets/sound/enemy_shoot.wav")

for powerup in window.powerups
	powerup.img = new Image()
	powerup.img.src = "assets/img/#{powerup.sprite}.png"


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

addEventListener("mouseup", (e) ->
	mouse.down = false
)

addEventListener("click", (e) ->
	mouse.click = true
)


dirt = new Image()
dirt.src = 'assets/img/dirt.png'

window.menuState = new MenuState()
window.gameState = new GameState()
window.currentState = window.menuState
window.nextState = null

currentState.enter()

addEventListener('resize', ->
	c.width = window.innerWidth
	c.height = window.innerHeight

	updateGradient()

	draw(ctx)

, false)

updateGradient = ->

	window.grd = ctx.createRadialGradient(c.width / 2, c.height / 2, window.player.sight, c.width / 2, c.height / 2, window.player.sight + 300)

	window.grd.addColorStop(0, 'rgba(0, 0, 0, 0)')
	window.grd.addColorStop(1, 'rgba(0, 0, 0, 1)')

updateGradient()

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

	if window.nextState
		window.currentState.exit()
		window.nextState.enter()
		window.currentState = window.nextState
		window.nextState = undefined

	currentState.update(delta)

	draw(delta)

	mouse.click = false

	window.requestAnimationFrame(update)


draw = (delta) ->
	ctx.clearRect(0, 0, c.width, c.height)

	currentState.draw(ctx)

	ctx.font = '46px Visitor'
	ctx.fillStyle = '#aaaaaa'
	ctx.fillText(fps, c.width - 80, 40)

	ctx.restore()


update()