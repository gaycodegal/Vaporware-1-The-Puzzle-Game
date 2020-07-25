extends MultiMeshInstance
var cols = 1
var rows = 1
var spacing = 1
var mesh_width = 1 
var mesh_height = 1
var mesh_depth = 1
var space_width
var space_height
var width
var height
var used = {}
var positions = []

func _ready():
	positions = []
	used = {}
	multimesh.instance_count = 0

func point_str(point):
	return "%d:%d" % [point[0], point[1]]

func pair_str(a, b):
	a = point_str(a)
	b = point_str(b)
	var pair = [a, b]
	pair.sort()
	return pair

func link(last, current):
	var key = pair_str(last, current)
	if key in used:
		return false
	used[key] = true
	var row = float(last[0] + current[0]) / 2
	var col = float(last[1] + current[1]) / 2
	var index = multimesh.instance_count
	multimesh.instance_count = index + 1
	var pos = Transform()
	var vpos = Vector3(
		col * space_width - width / 2 + mesh_width / 2,
		row * space_height - height / 2 + mesh_height/2, 
		0)
	pos = pos.translated(vpos)
	positions.append(pos)
	for i in range(len(positions)):
		multimesh.set_instance_transform(i, positions[i])
	return true
