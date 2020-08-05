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
var amount_rotated = 0

func _ready():
	iRot = rotation_degrees.x
	
func _process(delta):
	var tolerated = is_tolerated()
	if last_tolerated != tolerated and tolerated == true:
		count += 1
	last_tolerated = tolerated
	rotate_z(speed * delta)
	amount_rotated += speed * delta

func is_tolerated():
	var diff = (rotation_degrees.x - iRot)
	return diff < tolerence_deg or diff > (180 - tolerence_deg)

func interact(relate):
	# if you're a music major this sound will be slightly
	# misleading because we're ignoring steps/halfsteps,
	# and 1 rotation = 1 octave instead of 2 so it's really just a ruse
	$AudioStreamPlayer.pitch_scale = 1 + abs(amount_rotated / (2 * PI))
	$AudioStreamPlayer.play(0)
	if is_tolerated():
		lastN.push_back(String(count))
		if lastN.size() > passcode.length():
			lastN.pop_front()
		if lastN.size() == passcode.length() and PoolStringArray(lastN).join("") == passcode:
			emit_signal("win")
	else:
		lastN.clear()
	count = 0
	amount_rotated = 0
	speed = -speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
