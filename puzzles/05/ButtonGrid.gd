extends MultiMeshInstance

signal win

export(int) var cols = 1
export(int) var rows = 1
export(float) var spacing = 1
export(float) var mesh_width = 1 
export(float) var mesh_height = 1
export(float) var mesh_depth = 1
export(Script) var button_script
export(NodePath) var grid_maze

var space_width
var space_height
var width
var height
var multimeshinstance
var last_pressed
var maze

# Called when the node enters the scene tree for the first time.
func _ready():
	maze = get_node(grid_maze)
	multimeshinstance = self
	multimeshinstance.multimesh.instance_count = cols * rows
	space_width = mesh_width + spacing
	space_height = mesh_height + spacing
	width = cols * mesh_width + spacing * (cols - 1)
	height = rows * mesh_height + spacing * (rows - 1)
	var links = get_node("links")
	links.rows = rows
	links.cols = cols
	links.spacing = spacing
	links.mesh_width = mesh_width
	links.mesh_height = mesh_height
	links.mesh_depth = mesh_depth
	links.space_width = space_width
	links.space_height = space_height
	links.width = width
	links.height = height
	var box_shape = BoxShape.new()
	box_shape.extents = Vector3(mesh_width / 2, mesh_height / 2, mesh_depth / 2)
	#collisionshape.shape.extents = Vector3(width/2, height/2, mesh_depth/2)
	for col in range(cols):
		for row in range(rows):
			var index = col + row * cols
			var pos = Transform()
			pos = pos.translated(Vector3(
				col * space_width - width / 2 + mesh_width / 2,
				row * space_height - height / 2 + mesh_height/2, 
				0))
			multimeshinstance.multimesh.set_instance_transform(index, pos)
			var static_body = StaticBody.new()
			static_body.transform = pos
			static_body.name = "%d : %d" % [row, col]
			static_body.collision_layer = 2
			static_body.collision_mask = 2
			var collision_shape = CollisionShape.new()
			collision_shape.shape = box_shape
			static_body.add_child(collision_shape)
			static_body.set_script(button_script)
			static_body.row = row
			static_body.col = col
			self.add_child(static_body)
			

func distance_ok(a, b):
	return abs(a[0]-b[0]) + abs(a[1]-b[1]) == 1

func interact(row, col, player):
	if last_pressed == null:
		if Vector2(row, col) == maze.start_pos:
			last_pressed = maze.start_pos
		return
	var current = Vector2(row, col)
	var shouldNull = not distance_ok(last_pressed, current)
	if shouldNull:
		return
	shouldNull = shouldNull or not maze.is_allowed(last_pressed, current)
	if shouldNull:
		return
	shouldNull = shouldNull or not get_node("links").link(last_pressed, current)
	if shouldNull:
		return
	if not shouldNull:
		# we want to play C,E,F,G
		# formula's ok but I may have borked it, doesn't sound quite right
		var diff:float
		if last_pressed[1] < current[1]: #North
			diff = 0.0
		elif last_pressed[0] < current[0]: #East
			diff = 2.0
		elif last_pressed[1] > current[1]: #South
			diff = 3.0
		elif last_pressed[0] > current[0]: #Westest
			diff = 4.0
		$AudioStreamPlayer.pitch_scale = 1.0 + diff/8.0
		$AudioStreamPlayer.play(0)
		last_pressed = current
		if current == maze.end_pos:
			emit_signal("win")
