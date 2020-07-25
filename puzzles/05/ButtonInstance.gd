extends StaticBody

var row
var col

func interact(actor):
	get_parent().interact(row, col, actor)


