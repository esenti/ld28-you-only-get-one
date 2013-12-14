c = document.getElementById('draw')
ctx = c.getContext('2d')

delta = 0
now = 0
before = Date.now()

sec = 0
frames = 0
fps = 0

c.width = window.innerWidth
c.height = window.innerHeight

keysDown = {}

addEventListener("keydown", (e) ->
	keysDown[e.keyCode] = true
	console.log(e.keyCode)
, false)

addEventListener("keyup", (e) ->
	delete keysDown[e.keyCode]
, false)

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

	ctx.clearRect(0, 0, c.width, c.height)


	ctx.fillText(fps, 10, 10)


	window.requestAnimationFrame(update)

update()