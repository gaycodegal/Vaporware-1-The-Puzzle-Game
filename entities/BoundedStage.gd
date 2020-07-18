extends Spatial

export(String) var title = "Vaporwave Puzzle Game"

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_window_title(title)
