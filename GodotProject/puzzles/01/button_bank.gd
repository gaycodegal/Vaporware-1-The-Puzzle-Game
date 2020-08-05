extends Spatial

signal win

var solved = false
var state = [
	[[false, false, false], [false, false, false], [false, false, false]],
	[[false, false, false], [false, false, false], [false, false, false]],
	[[false, false, false], [false, false, false], [false, false, false]]]
# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(3):
		for y in range(3):
			for z in range(3):
				getSkull(x, y, z).initialize(self, x, y, z)
				setState(x, y, z)

func flipped(x, y, z):
	# figured I'd make the audio higher based on the number of skulls flipped
	# since number of skulls is [4,7] I shift in range [0, 3], 
	# inverted so higher pitch closest to (1,1,1) (where 7 skulls flipped)
	var pitch_shift = float(3 - (abs(x - 1) + abs(y - 1) + abs(z - 1)))
	$AudioStreamPlayer.pitch_scale = 1 + pitch_shift / 3
	$AudioStreamPlayer.play(0)
	
	var deltas = [-1, 1]
	var skull
	for d in deltas:
		maybeFlip(getSkull(x + d, y, z))
		setState(x + d, y, z)
	for d in deltas:
		maybeFlip(getSkull(x, y + d, z))
		setState(x, y + d, z)
	for d in deltas:
		maybeFlip(getSkull(x, y, z + d))
		setState(x, y, z + d)
	checkForWin()
	
func checkForWin():
	var goal: bool = getSkull(0,0,0).is_flipped
	for x in range(3):
		for y in range(3):
			for z in range(3):
				if getSkull(x,y,z).is_flipped != goal:
					solved = false
					return
	emit_signal("win")
	solved = true

func maybeFlip(skull):
	if skull != null:
		skull.slow_flip()

func outOfBounds(x):
	return x < 0 or x >= 3

func setState(x, y, z):
	if outOfBounds(x) or outOfBounds(y) or outOfBounds(z):
		return
	state[x][y][z] = getSkull(x, y, z).is_flipped

func getSkull(x, y, z):
	if outOfBounds(x) or outOfBounds(y) or outOfBounds(z):
		return null
	var childrenX: Spatial = get_child(x)
	var childrenY: Spatial = childrenX.get_child(y)
	var childrenZ: Spatial = childrenY.get_child(z)
	return childrenZ
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
