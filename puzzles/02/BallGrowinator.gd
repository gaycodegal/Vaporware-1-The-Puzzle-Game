extends Spatial

export(NodePath) var target_to_grow_path
export(float) var growth_factor
export(float) var max_scale
export(float) var min_scale
var target: Spatial
var camera: Spatial
func _ready():
	target = get_node(target_to_grow_path)
	camera = get_viewport().get_camera()
	
func _physics_process(delta):
	if target.scale.x <= min_scale:
		return #lock once small
	#var invisibility_ray = get_world().direct_space_state.intersect_ray(camera.global_transform.origin, target.global_transform.origin, [target])
	var target_pos = target.to_global(Vector3.ZERO)
	var camera_pos = camera.to_global(Vector3.ZERO)
	# distance from camera to target
	var distance1 = camera_pos - target_pos
	# distance from 1 unit behind the camera to target 
	var distance2 = camera.get_camera_transform().basis.z + distance1
	
	if distance1.length_squared() < distance2.length_squared():
		# target is visible, so grow
		if target.scale.x < max_scale:
			var scalar = growth_factor * delta
			target.scale += Vector3(scalar, scalar, scalar)
	else:
		if target.scale.x > min_scale:
			var scalar = growth_factor * delta
			target.scale -= Vector3(scalar, scalar, scalar)

