extends Spatial

export(String) var title_key = "1"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title(Globals.language.get_value("puzzle_names", title_key))
