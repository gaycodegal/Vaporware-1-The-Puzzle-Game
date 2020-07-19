extends MeshInstance

signal win

export(String) var passcode = "1234"
export(float) var speed = 1
export(float) var tolerence_deg = 20

var iRot
var direction
var last_tolerated = true
var count = 0
var lastN = []

func _ready():
	iRot = rotation_degrees.x
	
func _process(delta):
	var tolerated = is_tolerated()
	if last_tolerated != tolerated and tolerated == true:
		count += 1
	last_tolerated = tolerated
	rotate_z(speed * delta)

func is_tolerated():
	var diff = (rotation_degrees.x - iRot)
	return diff < tolerence_deg or diff > (180 - tolerence_deg)

func interact(relate):
	if is_tolerated():
		lastN.push_back(String(count))
		if lastN.size() > passcode.length():
			lastN.pop_front()
		if lastN.size() == passcode.length() and PoolStringArray(lastN).join("") == passcode:
			emit_signal("win")
	else:
		lastN.clear()
	count = 0
	speed = -speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
