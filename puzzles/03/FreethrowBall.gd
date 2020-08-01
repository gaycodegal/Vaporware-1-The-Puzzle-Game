
extends RigidBody

signal thrown
signal pickup
signal win

export(bool) var good_to_throw = true
export(bool) var good_to_land = false

var picked_up
var in_goal
var holder
var thrown_well = false
export(String) var name_key = "Ball"
var my_name

func _ready():
	my_name = Globals.language.get_value("puzzle_items", name_key, name_key)

func get_name():
	return my_name
	
func pick_up(player):
	holder = player
	if picked_up:
		leave()
	else:
		carry()

func _process(delta):
	if picked_up:
		var old_scale = scale
		set_global_transform(holder.get_node("Yaw/Camera/pickup_pos").get_global_transform())
		scale = old_scale

func carry():
	holder.carried_object = self
	picked_up = true
	thrown_well = false
	emit_signal("pickup")

func leave():
	if len(get_colliding_bodies()) > 0:
		return
	if good_to_throw:
		thrown_well = true
	holder.carried_object = null
	# reset the forces acting on the object so it doesn't go all weird
	# it's been adding gravity all this time it just has been fixed in place due
	# to updating in _process instead of _integrate_forces
	angular_velocity = Vector3.ZERO
	linear_velocity = Vector3.ZERO
	picked_up = false
	check_for_win()
	emit_signal("thrown")

func throw(power):
	leave()
	apply_impulse(Vector3(), holder.look_vector * Vector3(power, power, power))

func check_for_win():
	if not picked_up and in_goal:
		if thrown_well and good_to_land:
			emit_signal("win")
		else:
			# we don't care about shots that are thrown within the time limit,
			# but enter the goal during throwing time
			thrown_well = false

func _on_Goal_body_entered(body):
	if body == self:
		in_goal = true
	check_for_win()


func _on_Goal_body_exited(body):
	if body == self:
		in_goal = false
