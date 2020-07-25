extends MultiMeshInstance

export(int) var cols = 1
export(int) var rows = 1
export(float) var spacing = 0
export(float) var mesh_width = 1 
export(float) var mesh_height = 1
export(float) var mesh_depth = 1
export(String) var maze_path

var space_width
var space_height
var width
var height
var multimeshinstance
var last_pressed
var S = 83
var E = 69
var SPACE = 32

var maze_lines = []
var cubes = 0
func loadMaze():
	var f = File.new()
	print(f.file_exists(maze_path))
	f.open(maze_path, File.READ)

	var index = 0
	while not f.eof_reached():
		var line = f.get_line()
		index += 1
		print(line)
		maze_lines.append(line.to_ascii())
		if index > 100:
			break
	f.close()
	
	for line in maze_lines:
		for c in line:
			if c != S and c != E and c != SPACE:
				cubes += 1

func isCube(row, col):
	print(len(maze_lines[row]))
	var c = maze_lines[row][col]
	return c != S and c != E and c != SPACE

# Called when the node enters the scene tree for the first time.
func _ready():
	loadMaze()
	multimeshinstance = self
	multimeshinstance.multimesh.instance_count = cubes
	space_width = mesh_width + spacing
	space_height = mesh_height + spacing
	width = cols * mesh_width + spacing * (cols - 1)
	height = rows * mesh_height + spacing * (rows - 1)
	#collisionshape.shape.extents = Vector3(width/2, height/2, mesh_depth/2)
	var i = 0
	for col in range(cols):
		for row in range(rows):
			if isCube(row, col):
				var pos = Transform()
				pos = pos.translated(Vector3(
					col * space_width - width / 2 + mesh_width / 2,
					row * space_height - height / 2 + mesh_height/2, 
					0))
				multimeshinstance.multimesh.set_instance_transform(i, pos)
				i += 1

			

func distance_ok(a, b):
	return abs(a[0]-b[0]) + abs(a[1]-b[1]) <= 1

func interact(row, col, player):
	var current = [row, col]
	if last_pressed != null:
		if not distance_ok(last_pressed, current) or not get_node("links").link(last_pressed, current):
			current = null
		
	last_pressed = current
