extends Node

export(Array, DynamicFont) var fonts

func _ready():
	resize_all()

func resize_all():
	for font in fonts:
		resize(font)

func resize_viewport(view):
	view.size *= Globals.settings.options.font_scale

func resize_mesh(mesh):
	mesh.scale *= Globals.settings.options.font_scale

func resize(font: DynamicFont):
	var desired_size = font.resource_path.split("_")
	if desired_size.size() < 2:
		return
	desired_size = int(desired_size[1])
	font.set("size", desired_size * Globals.settings.options.font_scale)
	font.update_changes()
