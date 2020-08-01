extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	translate()
	set_up_options()
	$ScrollContainer/CenterContainer/Main/Play.grab_focus()

func translate():
	OS.set_window_title(Globals.language.get_value("main_menu", "title", ""))
	Globals.rename_all_children(get_node("ScrollContainer/CenterContainer/Main"), "main_menu")
	Globals.rename_all_children(get_node("ScrollContainer/CenterContainer/Options"), "main_menu")

func hide_all():
	for child in get_node("ScrollContainer/CenterContainer").get_children():
		child.visible = false

func _process(delta):
	if Input.is_action_pressed("quit"):
		if get_node("ScrollContainer/CenterContainer/Main").visible:
			get_tree().quit()
		else: 
			Input.action_release("quit")
			_on_Back_pressed()
	elif Input.is_action_pressed("ui_cancel"):
		Input.action_release("ui_cancel")
		_on_Back_pressed()


func _on_Play_pressed():
	Globals.load_current_level()


func _on_Level_Select_pressed():
	get_tree().change_scene("res://puzzles/Menus/LevelSelect.tscn")


func _on_Credits_pressed():
	get_tree().change_scene("res://puzzles/Menus/Credits.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	hide_all()
	get_node("ScrollContainer/CenterContainer/Options").visible = true
	$"ScrollContainer/CenterContainer/Options/*ScreenSizes".grab_focus()


func _on_Back_pressed():
	hide_all()
	get_node("ScrollContainer/CenterContainer/Main").visible = true
	$ScrollContainer/CenterContainer/Main/Options.grab_focus()	

func set_up_options():
	list_screen_sizes()
	list_languages()
	get_node("ScrollContainer/CenterContainer/Options/VSync").pressed = Globals.settings.options.vsync
	get_node("ScrollContainer/CenterContainer/Options/Fullscreen").pressed = Globals.settings.options.fullscreen
	get_node("ScrollContainer/CenterContainer/Options/Borderless").pressed = Globals.settings.options.borderless
	get_node("ScrollContainer/CenterContainer/Options/Maximize").pressed = Globals.settings.options.maximize_window
	get_node("ScrollContainer/CenterContainer/Options/*Font Scale").value = Globals.settings.options.font_scale

func list_screen_sizes():
	var screen_sizes = get_node("ScrollContainer/CenterContainer/Options/*ScreenSizes")
	var options = [
		"800×480",
		"1024×768",
		"1200×900",
		"1280×720",
		"1280×800",
		"1366×768",
		"1440×900",
		"1536×864",
		"1600×900",
		"1680×1050",
		"1920×1080",
		"2560×1440"
	]
	for option in options:
		screen_sizes.add_item(option)
	screen_sizes.select(options.find("%d×%d" % [Globals.settings.options.width, Globals.settings.options.height]))


func dir_contents(path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func list_languages():
	var dir = Directory.new()
	if dir.open("res://language") == OK:
		dir.list_dir_begin()
		var options = []
		var file_name: String = dir.get_next()
		var conf_type = ".conf"
		var conf_len = conf_type.length()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(conf_type):
				options.append(file_name.substr(0, file_name.length() - conf_len))
			file_name = dir.get_next()
		var languages = get_node("ScrollContainer/CenterContainer/Options/*Languages")
		for option in options:
			languages.add_item(option)
		languages.select(options.find(Globals.settings.options.language))


func _on_ScreenSizes_item_selected(id):
	var screen_sizes = get_node("ScrollContainer/CenterContainer/Options/*ScreenSizes")
	var option_text = screen_sizes.get_item_text(id)
	var size = option_text.split("×")
	Globals.settings.options.width = int(size[0])
	Globals.settings.options.height = int(size[1])
	Globals.apply_options()
	Globals.partial_save_config("options")


func _on_VSync_toggled(button_pressed):
	Globals.settings.options.vsync = button_pressed
	Globals.apply_options()
	Globals.partial_save_config("options")


func _on_Fullscreen_toggled(button_pressed):
	Globals.settings.options.fullscreen = button_pressed
	Globals.apply_options()
	Globals.partial_save_config("options")


func _on_Borderless_toggled(button_pressed):
	Globals.settings.options.borderless = button_pressed
	Globals.apply_options()
	Globals.partial_save_config("options")


func _on_Font_Scale_value_changed(value):
	Globals.settings.options.font_scale = value
	$FontResizer.resize_all()
	Globals.partial_save_config("options")


func _on_Maximize_toggled(button_pressed):
	Globals.settings.options.maximize_window = button_pressed
	Globals.apply_options()
	Globals.partial_save_config("options")


func _on_Language_item_selected(id):
	var languages = get_node("ScrollContainer/CenterContainer/Options/*Languages")
	var option_text = languages.get_item_text(id)
	Globals.settings.options.language = option_text
	Globals.apply_options()
	translate()
	Globals.partial_save_config("options")


func _on_Controls_pressed():
	get_tree().change_scene("res://puzzles/Menus/Controls.tscn")
