class Rect
	constructor: (@x, @y, @width, @height) ->

	collidesWith: (x, y, width, height) ->
		return @x + @width > x and @x < x + width and @y + @height > y and @y < y + height

	collidesWithRect: (rect) ->
		return @collidesWith(rect.x, rect.y, rect.width, rect.height)