extends Control

func _ready():
	OS.set_window_title("Vaporwave Puzzle Game - Debug Level Select")

func _process(delta):
	if Input.is_action_pressed("quit"):
		Globals.tryToQuit()

func _on_01Skulls_pressed():
	Globals.settings.game.level = 0
	get_tree().change_scene("res://puzzles/puzzle_01.tscn")

func _on_02Ghost_pressed():
	Globals.settings.game.level = 1
	get_tree().change_scene("res://puzzles/puzzle_02.tscn")

func _on_03SavingThrow_pressed():
	Globals.settings.game.level = 2
	get_tree().change_scene("res://puzzles/puzzle_03.tscn")
	
func _on_04_1312_pressed():
	Globals.settings.game.level = 3
	get_tree().change_scene("res://puzzles/puzzle_04.tscn")

func _on_05_One_Liner_pressed():
	Globals.settings.game.level = 4
	get_tree().change_scene("res://puzzles/puzzle_05.tscn")
