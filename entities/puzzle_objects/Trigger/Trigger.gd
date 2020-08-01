extends StaticBody

export(NodePath) var target

export(String) var name_key = "Rock"
var my_name

func _ready():
	my_name = Globals.language.get_value("puzzle_items", name_key, name_key)

func get_name():
	return my_name
	
func interact(x):
	get_node(target).interact(x)
