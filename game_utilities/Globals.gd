extends Node

var config = ConfigFile.new()
var language = ConfigFile.new()
var language_dir = "language/"
var game_file = "res://"
var user_file = "user://"
var settings_path = user_file + "config.conf"
var args: Array

var settings = {
	"general" : {
		"version": 1,
	},
	"game" : {
		"level": 0,
	},
	"options" : {
		"language": "en",
		"width": 1600,
		"height": 900,
		"fullscreen": false,
		"vsync": false,
		"borderless": false,
	}
}

var levels = [
	{"path": "res://puzzles/puzzle_01.tscn"},
	{"path": "res://puzzles/puzzle_02.tscn"},
	{"path": "res://puzzles/puzzle_03.tscn"},
	{"path": "res://puzzles/puzzle_04.tscn"},
	{"path": "res://puzzles/puzzle_05.tscn"},
]


func get_arg_value(name, default):
	var index = args.find(name)
	if index == -1 or index >= args.size() - 1:
		return default
	return args[index + 1]

func _ready():
	args = Array(OS.get_cmdline_args())
	load_config()
	apply_options()

func full_save_config():
	config = ConfigFile.new()
	for section in settings:
		var section_map = settings[section]
		for key in section_map:
			config.set_value(section, key, section_map[key])
	config.save(settings_path)

func partial_save_config(section: String):
	var section_map = settings[section]
	for key in section_map:
		config.set_value(section, key, section_map[key])
	config.save(settings_path)
	
func advance_level():
	settings.game.level += 1
	settings.game.level %= levels.size()
	partial_save_config("game")
	load_current_level()
	
func load_current_level():
	get_tree().change_scene(levels[settings.game.level].path)

func load_config():
	var file = File.new()
	if file.file_exists(settings_path):
		config.load(settings_path)
	if settings.general.version != config.get_value("general", "version"):
		print("Bad config version, ignoring.")
		if args.has("--overwrite-bad-values"):
			print("Bad config overwritten.")
			full_save_config()
		return
		
	for section in settings:
		var section_map = settings[section]
		for key in section_map:
			section_map[key] = config.get_value(section, key, section_map[key])
			
func apply_options():
	OS.window_fullscreen = settings.options.fullscreen
	OS.vsync_enabled = settings.options.vsync
	OS.window_size = Vector2(settings.options.width, settings.options.height)
	OS.window_borderless = settings.options.borderless
	load_language()

func load_language():
	var file = File.new()
	var path = game_file + language_dir + settings.options.language + ".conf"
	if file.file_exists(path):
		language.load(path)
	else:
		printerr("Fatal Error: No such language file \"", path, '"')
		get_tree().quit(1)

func rename_all_children(node: Node, section: String):
	var children = node.get_children()
	for child in children:
		if child.name[0] == "*":
			continue
		var text = language.get_value(section, child.name)
		if text != null:
			child.text = text
		else:
			printerr("no name found for '", section, "/", child.name, "'")
