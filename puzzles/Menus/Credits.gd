extends Control

var credits_path = "res://puzzles/Menus/credits.txt"

func _ready():
	var f = File.new()
	f.open(credits_path, File.READ)
	get_node("ScrollContainer/credits").text = f.get_as_text()
	f.close()

func _process(delta):
	if Input.is_action_pressed("quit"):
		Globals.tryToQuit()
