extends VBoxContainer

func _ready():
	

func list_screen_sizes():
	var screen_sizes = get_node("ScrollContainer/CenterContainer/GraphicsOptions/ScreenSizes")
	var options = [
		"800x480",
		"1024x768",
		"1200x900",
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
