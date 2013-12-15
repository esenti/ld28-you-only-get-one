class LoadingState extends State

	enter: ->
		resourceManager.registerImage('dirt.png')
		resourceManager.registerImage('shooter_0.png')
		resourceManager.registerImage('shooter_1.png')
		resourceManager.registerImage('shooter_2.png')
		resourceManager.registerImage('shooter_3.png')
		resourceManager.registerImage('shooter_dead.png')
		resourceManager.registerImage('spider_0.png')
		resourceManager.registerImage('spider_1.png')
		resourceManager.registerImage('spider_2.png')
		resourceManager.registerImage('spider_blood.png')
		resourceManager.registerImage('spider_dead.png')
		resourceManager.registerImage('player_0.png')
		resourceManager.registerImage('player_1.png')

		resourceManager.registerImage('heart.png')
		resourceManager.registerImage('eye.png')
		resourceManager.registerImage('speed.png')

		resourceManager.registerSound('shoot.wav')
		resourceManager.registerSound('enemy_hurt.wav')
		resourceManager.registerSound('player_hurt.wav')
		resourceManager.registerSound('levelup.wav')
		resourceManager.registerSound('gameover.wav')
		resourceManager.registerSound('enemy_dead.wav')
		resourceManager.registerSound('enemy_shoot.wav')

	update: (delta) ->

		if resourceManager.ready()
			window.nextState = menuState

	draw: (ctx) ->
		ctx.save()
		ctx.fillStyle = 'black'
		ctx.fillRect(0, 0, c.width, c.height)
		ctx.fillStyle = 'white'

		ctx.textAlign = 'center'
		ctx.textBaseline = 'middle'
		ctx.font = '52px Visitor'
		ctx.fillText("Loading…", c.width / 2, c.height / 2)

		ctx.restore()
