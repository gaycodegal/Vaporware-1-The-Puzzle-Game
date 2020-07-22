extends MultiMeshInstance

export(int) var cols = 1
export(int) var rows = 1
export(float) var spacing = 1
export(float) var mesh_width = 1 
export(float) var mesh_height = 1
export(float) var mesh_depth = 1
export(Script) var button_script

var space_width
var space_height
var width
var height
var multimeshinstance
var last_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
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
	return abs(a[0]-b[0]) + abs(a[1]-b[1]) <= 1

func interact(row, col, player):
	var current = [row, col]
	if last_pressed != null:
		if not distance_ok(last_pressed, current) or not get_node("links").link(last_pressed, current):
			current = null
		
	last_pressed = current
