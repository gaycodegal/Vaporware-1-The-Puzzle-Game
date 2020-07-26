extends Control

func _ready():
	OS.set_window_title(Globals.language.get_value("main_menu", "title", ""))
	Globals.rename_all_children(get_node("ScrollContainer/CenterContainer/Main"), "main_menu")
	Globals.rename_all_children(get_node("ScrollContainer/CenterContainer/Options"), "main_menu")
	set_up_options()

func hide_all():
	for child in get_node("ScrollContainer/CenterContainer").get_children():
		child.visible = false

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()


func _on_Play_pressed():
	Globals.load_current_level()


func _on_Level_Select_pressed():
	get_tree().change_scene("res://puzzles/Menus/DebugMenu.tscn")


func _on_Credits_pressed():
	printerr("can't do credits yet")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	hide_all()
	get_node("ScrollContainer/CenterContainer/Options").visible = true


func _on_Back_pressed():
	hide_all()
	get_node("ScrollContainer/CenterContainer/Main").visible = true

func set_up_options():
	list_screen_sizes()
	get_node("ScrollContainer/CenterContainer/Options/VSync").pressed = Globals.settings.options.vsync
	get_node("ScrollContainer/CenterContainer/Options/Fullscreen").pressed = Globals.settings.options.fullscreen
	get_node("ScrollContainer/CenterContainer/Options/Borderless").pressed = Globals.settings.options.borderless

func list_screen_sizes():
	var screen_sizes = get_node("ScrollContainer/CenterContainer/Options/ScreenSizes")
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


func _on_ScreenSizes_item_selected(id):
	print(id)
	var screen_sizes = get_node("ScrollContainer/CenterContainer/Options/ScreenSizes")
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
