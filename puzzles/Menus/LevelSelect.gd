extends Control

func _ready():
	add_all_levels()
	translate()

func _process(delta):
	if Input.is_action_pressed("quit"):
		Globals.tryToQuit()

func translate():
	OS.set_window_title(Globals.language.get_value("level_select", "title", ""))
	Globals.rename_all_children($ScrollContainer/CenterContainer/VBoxContainer, "puzzle_names")
	$"ScrollContainer/CenterContainer/VBoxContainer/*Back".text = Globals.language.get_value("main_menu", "Back", "")

func add_all_levels():
	var container = $ScrollContainer/CenterContainer/VBoxContainer
	var back = container.get_child(0)
	container.remove_child(back)
	for i in range(Globals.levels.size()):
		var button = Button.new()
		button.name = str(i + 1)
		button.rect_min_size = Vector2(300, 50)
		button.size_flags_horizontal = button.SIZE_EXPAND_FILL
		button.size_flags_vertical = button.SIZE_EXPAND_FILL
		button.connect("pressed", self, "_on_level_pressed", [i])
		container.add_child(button, true)
	container.add_child(back)

func _on_level_pressed(id):
	get_tree().change_scene(Globals.levels[id].path)

func _on_Back_pressed():
	get_tree().change_scene("res://puzzles/Menus/MainMenu.tscn")
