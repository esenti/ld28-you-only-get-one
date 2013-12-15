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
		name: 'atest'
		sprite: 'heart'

	},
	{
		name: 'another test'
		sprite: 'heart'
	}
]

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

addEventListener('resize', ->
	c.width = window.innerWidth
	c.height = window.innerHeight

	draw(ctx)

, false)


dirt = new Image()
dirt.src = 'assets/img/dirt.png'

grd = ctx.createRadialGradient(c.width / 2, c.height / 2, 300, c.width / 2, c.height / 2, 600)

grd.addColorStop(0, 'rgba(0, 0, 0, 0)')
grd.addColorStop(1, 'rgba(0, 0, 0, 0.9)')

window.menuState = new MenuState()
window.gameState = new GameState()
window.currentState = window.menuState
window.nextState = null

currentState.enter()

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

	ctx.font = '16px Visitor'
	ctx.fillStyle = 'white'
	ctx.fillText(fps, 10, 10)

	ctx.restore()


update()