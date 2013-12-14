class Vector
	constructor: (@x, @y) ->

	normalize: ->
		len = Math.sqrt(@x * @x + @y * @y)
		if len != 0
			@x = @x / len
			@y = @y / len

	angle: ->
		dot = @x
		a =  Math.acos(dot) / Math.PI * 180
		return if @y > 0 then a else 360 - a

	rotate: (angle) ->
		theta = angle * Math.PI / 180;

		cs = Math.cos(theta)
		sn = Math.sin(theta)

		@x = @x * cs - @y * sn
		@y = @x * sn + @y * cs

	length: ->
		return Math.sqrt(@x * @x + @y * @y)