extends Control

func _process(delta):
	if Input.is_action_pressed("quit"):
		get_tree().quit()

func _on_01Skulls_pressed():
	get_tree().change_scene("res://puzzles/puzzle_01.tscn")

func _on_02Ghost_pressed():
	get_tree().change_scene("res://puzzles/puzzle_02.tscn")
