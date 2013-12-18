class Player extends Rect

	constructor: (@x, @y) ->
		@hp = 30
		@maxHp = 30
		@exp = 0
		@expToLevel = 800
		@speed = 100
		@animation = new Animation('player', 2)
		@alive = 0
		@leveled = false
		@level = 1
		@hooks = []
		@fireRate = 2
		@toShoot = 0
		@bulletTtl = 1.5
		@bulletPower = 3
		@bulletSpeed = 150
		@sight = 150
		super(@x, @y, 32, 32)

	update: (delta) ->
		@alive += delta
		@toShoot -= delta

		screenX = camera.transformX(@x) + 16
		screenY = camera.transformY(@y) + 16

		@vec = new Vector(mouse.pos.x - screenX, mouse.pos.y - screenY)
		@vec.normalize()

		@leveled = false
		if @exp >= @expToLevel
			resourceManager.getSound('levelup.wav').play()
			@leveled = true
			@exp = @exp - @expToLevel
			@expToLevel = @expToLevel + 100
			@level += 1
			@hp = @maxHp

		for hook in @hooks
			hook(this, delta)

	hit: (power) ->
		resourceManager.getSound('player_hurt.wav').currentTime = 0
		resourceManager.getSound('player_hurt.wav').play()
		@hp = Math.max(0, @hp - power)
		window.shake = 0.5

	draw: (ctx) ->
		ctx.save()
		ctx.translate(camera.transformX(@x) + 16, camera.transformY(@y) + 16)

		ctx.rotate(@vec.angle() * Math.PI / 180);

		ctx.translate(-camera.transformX(@x) - 16, -camera.transformY(@y) - 16)
		ctx.drawImage(@animation.getFrame(@alive), camera.transformX(@x), camera.transformY(@y))

		ctx.restore()