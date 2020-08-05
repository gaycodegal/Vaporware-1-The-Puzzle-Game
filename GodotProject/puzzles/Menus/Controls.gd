extends Control

var keys = ["Movement", "Interact", "Crouch"]
var values = ["WASD", "E", "C"]

func _ready():
	var text = []
	for i in range(keys.size()):
		var key = Globals.language.get_value("controls", keys[i])
		if key == null:
			printerr("No translation found for 'controls/", keys[i], "'")
			key = keys[i]
		text.append("%s : %s" % [key, values[i]])
	$ScrollContainer/text.text = PoolStringArray(text).join("\n")
	

func _process(delta):
	if Input.is_action_pressed("quit"):
		Globals.tryToQuit()
	elif Input.is_action_pressed("ui_cancel"):
		Input.action_release("ui_cancel")
		get_tree().change_scene("res://puzzles/Menus/MainMenu.tscn")
