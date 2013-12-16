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
		sprite: 'heart.png'
		use: ->
			window.player.maxHp = window.player.maxHp + 10
			window.player.hp = window.player.maxHp
	},
	{
		name: 'HP regen'
		sprite: 'heart_half.png'
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
		sprite: 'speed.png'
		use: ->
			window.player.speed = window.player.speed * 1.2
	},
	{
		name: '2x fire rate'
		sprite: '2x.png'
		use: ->
			window.player.fireRate = window.player.fireRate * 2
	},
	{
		name: 'stronger bullets'
		sprite: 'bullet.png'
		use: ->
			window.player.bulletPower = window.player.bulletPower * 2
	},
	{
		name: 'faster bullets'
		sprite: 'fast_bullet.png'
		use: ->
			window.player.bulletSpeed = window.player.bulletSpeed * 2
			window.player.bulletTtl = window.player.bulletTtl * 0.5
	},
	{
		name: 'longer range'
		sprite: 'range.png'
		use: ->
			window.player.bulletTtl = window.player.bulletTtl * 2
	},
	{
		name: 'better sight'
		sprite: 'eye.png'
		use: ->
			window.player.sight = window.player.sight * 1.5
			updateGradient()
	},
]

window.addEventListener("keydown", (e) ->
	keysDown[e.keyCode] = true
, false)

window.addEventListener("keyup", (e) ->
	delete keysDown[e.keyCode]
, false)

window.addEventListener("mousemove", (e) ->
	mouse.pos = {x: e.clientX, y: e.clientY}
)

window.addEventListener("mousedown", (e) ->
	mouse.down = true
)

window.addEventListener("mouseup", (e) ->
	mouse.down = false
)

window.addEventListener("click", (e) ->
	mouse.click = true
)

window.resourceManager = new ResourceManager()

window.menuState = new MenuState()
window.gameState = new GameState()
window.loadingState = new LoadingState()
window.currentState = window.loadingState
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

window.shake = 0

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

	# ctx.font = '46px Visitor'
	# ctx.fillStyle = '#aaaaaa'
	# ctx.fillText(fps, c.width - 80, 40)

	ctx.restore()


update()