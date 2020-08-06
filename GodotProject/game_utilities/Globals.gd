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
		"version": 3,
	},
	"game" : {
		"level": 0,
	},
	"options" : {
		"language": "English",
		"width": 1600,
		"height": 900,
		"fullscreen": false,
		"vsync": false,
		"borderless": false,
		"maximize_window": false,
		"font_scale": 1,
	},
	"audio" : {
		"total": 100,
		"music": 100,
		"sfx": 100,
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
	print("loaded")
	args = Array(OS.get_cmdline_args())
	load_config()
	apply_options()
	load_language()
	apply_audio()

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
	
func tryToQuit():
	Input.action_release("quit")
	Input.action_release("ui_cancel")
	if args.has("--escape-exits"):
		get_tree().quit()
	else:
		get_tree().change_scene("res://puzzles/Menus/MainMenu.tscn")

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
	if OS.vsync_enabled != settings.options.vsync:
		OS.vsync_enabled = settings.options.vsync
	if OS.window_fullscreen != settings.options.fullscreen:
		OS.window_fullscreen = settings.options.fullscreen
	else:
		if OS.window_borderless != settings.options.borderless:
			OS.window_borderless = settings.options.borderless
		if OS.window_maximized != settings.options.maximize_window:
			OS.window_maximized = settings.options.maximize_window

	var max_size = OS.get_screen_size()
	# having too large of a window is annoying
	var expected_size = Vector2(
		min(max_size.x, settings.options.width),
		min(max_size.y, settings.options.height))
	OS.min_window_size = Vector2(10, 10)
	if not settings.options.fullscreen and not settings.options.maximize_window and OS.window_size != expected_size:
		OS.window_size = expected_size
		OS.center_window()


func apply_audio():
	apply_channel("Master", settings.audio.total)
	apply_channel("Music", settings.audio.music)
	apply_channel("SFX", settings.audio.sfx)

func apply_channel(channel, volume):
	var ichannel = AudioServer.get_bus_index(channel)
	if volume == 0:
		AudioServer.set_bus_mute(ichannel, true)
	else:
		AudioServer.set_bus_volume_db(ichannel, volume_db_from_value(volume))

func volume_db_from_value(volume):
	return linear2db(volume / 100)

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
