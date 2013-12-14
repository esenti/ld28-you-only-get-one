class Animation
	constructor: (@name, count) ->
		@frames = []
		for i in [0..count - 1]
			@frames[i] = new Image()
			@frames[i].src = "assets/img/#{@name}_#{i}.png"

		console.log frames

	getFrame: (time) ->
		return @frames[Math.floor(time * 8) % @frames.length]

	width: ->
		return @frames[0].width

	height: ->
		return @frames[0].height