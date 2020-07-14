# A skull which you can flip by interacting with it
extends StaticBody

var tween: Tween
var target: MeshInstance
export(bool) var is_flipped = false
var button_bank = null
var x: int
var y: int
var z: int

func initialize(button_bank, x, y, z):
	self.button_bank = button_bank
	self.x = x
	self.y = y
	self.z = z

func _exit_tree():
	if button_bank != null:
		button_bank = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	tween = get_node("tween")
	target = get_node("target")
	if is_flipped:
		self.rotation_degrees = desired_rotation()

func desired_rotation():
	return Vector3(180,0,0) if is_flipped else Vector3.ZERO

func fast_flip():
	is_flipped = not is_flipped
	self.rotation_degrees = desired_rotation()

func slow_flip():
	is_flipped = not is_flipped
	tween.interpolate_property(
		self, 
		"rotation_degrees", 
		rotation_degrees, 
		desired_rotation(), 
		1.0, 
		Tween.TRANS_CUBIC)
	tween.start()
	
func get_name():
	return "Skull"

func interact(relate):
	if not tween.is_active():
		slow_flip()
		if self.button_bank != null:
			self.button_bank.flipped(x, y, z)
	
