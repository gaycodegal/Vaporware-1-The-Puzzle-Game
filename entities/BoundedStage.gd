extends Spatial

export(String) var title_key = "1"

# Called when the node enters the scene tree for the first time.
func _ready():
	var title = Globals.language.get_value("puzzle_names", title_key)
	OS.set_window_title(title)
	$Viewport/Label.text = '"%s"' % title
	$InstructionsPlane.material_override.albedo_texture = $Viewport.get_texture()
