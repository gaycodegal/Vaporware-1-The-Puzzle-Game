extends StaticBody

export(int) var cols = 1
export(int) var rows = 1
export(float) var spacing = 1
export(float) var mesh_width = 1 
export(float) var mesh_height = 1
export(float) var mesh_depth = 1
var space_width
var space_height
var width
var height
var multimeshinstance
var collisionshape

# Called when the node enters the scene tree for the first time.
func _ready():
	multimeshinstance = get_node("multimeshinstance")
	collisionshape = get_node("collisionshape")
	multimeshinstance.multimesh.instance_count = cols * rows
	space_width = mesh_width + spacing
	space_height = mesh_height + spacing
	width = cols * mesh_width + spacing * (cols - 1)
	height = rows * mesh_height + spacing * (rows - 1)
	collisionshape.shape.extents = Vector3(width/2, height/2, mesh_depth/2)
	for col in range(cols):
		for row in range(rows):
			var index = col + row * cols
			var pos = Transform()
			pos = pos.translated(Vector3(col * space_width - width / 2 + mesh_width / 2, row * space_height - height / 2 + mesh_height/2, 0))
			multimeshinstance.multimesh.set_instance_transform(index, pos)


func interact(player):
	var point: Vector3 = player.get_collision_point()
	print(to_local(point))
