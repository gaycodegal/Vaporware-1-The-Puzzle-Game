extends Control

func _ready():
	OS.set_window_title("Vaporwave Puzzle Game - Debug Level Select")

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func _on_01Skulls_pressed():
	get_tree().change_scene("res://puzzles/puzzle_01.tscn")

func _on_02Ghost_pressed():
	get_tree().change_scene("res://puzzles/puzzle_02.tscn")

func _on_03SavingThrow_pressed():
	get_tree().change_scene("res://puzzles/puzzle_03.tscn")
	
func _on_04_1312_pressed():
	get_tree().change_scene("res://puzzles/puzzle_04.tscn")

func _on_05_One_Liner_pressed():
	get_tree().change_scene("res://puzzles/puzzle_05.tscn")
