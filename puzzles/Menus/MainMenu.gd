extends Control

func _ready():
	OS.set_window_title(Globals.language.get_value("main_menu", "title", ""))
	Globals.rename_all_children(get_node("ScrollContainer/CenterContainer/VBoxContainer"), "main_menu")



func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()


func _on_Play_pressed():
	Globals.load_current_level()


func _on_Level_Select_pressed():
	get_tree().change_scene("res://puzzles/Menus/DebugMenu.tscn")


func _on_Options_pressed():
	printerr("can't do options yet")


func _on_Credits_pressed():
	printerr("can't do credits yet")


func _on_Quit_pressed():
	get_tree().quit()
