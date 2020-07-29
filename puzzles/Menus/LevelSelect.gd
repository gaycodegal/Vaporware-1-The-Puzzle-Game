extends Control

func _ready():
	add_all_levels()
	translate()
	$FocusManager.set_up()

func _process(delta):
	if Input.is_action_pressed("quit"):
		Globals.tryToQuit()
	elif Input.is_action_pressed("ui_cancel"):
		Input.action_release("ui_cancel")
		_on_Back_pressed()

func translate():
	OS.set_window_title(Globals.language.get_value("level_select", "title", ""))
	Globals.rename_all_children($ScrollContainer/CenterContainer/VBoxContainer, "puzzle_names")

func add_all_levels():
	var container = $ScrollContainer/CenterContainer/VBoxContainer
	var back = $ScrollContainer/CenterContainer/VBoxContainer/Back
	container.remove_child(back)
	for i in range(Globals.levels.size()):
		var button = Button.new()
		button.name = str(i + 1)
		button.rect_min_size = Vector2(300, 50)
		button.size_flags_horizontal = button.SIZE_EXPAND_FILL
		button.size_flags_vertical = button.SIZE_EXPAND_FILL
		button.connect("pressed", self, "_on_level_pressed", [i])
		container.add_child(button, true)
	var sep = HSeparator.new()
	sep.name = "*sep"
	container.add_child(sep)
	container.add_child(back)
	container.get_child(1).grab_focus()

func _on_level_pressed(id):
	Globals.settings.game.level = id
	get_tree().change_scene(Globals.levels[id].path)

func _on_Back_pressed():
	get_tree().change_scene("res://puzzles/Menus/MainMenu.tscn")
