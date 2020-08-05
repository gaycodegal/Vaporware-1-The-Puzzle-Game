extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var time = 5
export(float) var hang_time = 3
export(float) var speed = 1
export(float) var ok_to_reset = true
export(NodePath) var freethrow_ball

var time_left
var target


# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(freethrow_ball)
	reset()

func reset():
	$AudioStreamPlayer.stop()
	time_left = time + hang_time

func _process(delta):
	time_left -= delta * speed
	if (time_left >= 0 or not ok_to_reset) and time_left <= hang_time:
		self.text = "0.0"
		if not $AudioStreamPlayer.playing:
			$AudioStreamPlayer.play(0)
		target.good_to_throw = false
		target.good_to_land = true
	else:
		if time_left < 0:
			reset()
		target.good_to_throw = true
		target.good_to_land = false
		self.text = "%2.1f" % (time_left - hang_time)
	

func _on_FreeThrowBall_thrown():
	ok_to_reset = false
	#print("not ok reset", ok_to_reset)

func _on_FreeThrowBall_pickup():
	ok_to_reset = true
	#print("ok reset", ok_to_reset)

func _on_FreeThrowBall_body_entered(body):
	ok_to_reset = true
	#print("ok reset", ok_to_reset)
