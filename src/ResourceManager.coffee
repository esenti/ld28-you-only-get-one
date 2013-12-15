class ResourceManager
	constructor: ->
		@images = []
		@sounds = []

	registerImage: (name) ->
		img = new Image()
		img.src = "assets/img/#{name}"
		@images[name] = img

	getImage: (name) ->
		return @images[name]

	registerSound: (name) ->
		@sounds[name] = new Audio("assets/sound/#{name}")

	getSound: (name) ->
		return @sounds[name]


	ready: ->
		for k, v of @images
			if not v.complete
				return false

		for k, v of @sounds
			if v.readyState != 4
				return false

		return true