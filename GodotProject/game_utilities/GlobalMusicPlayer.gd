extends Node

var musics = [
	"res://sounds/music/spookyvibes01.tres",
	"res://sounds/music/spookyvibes02.tres",
	"res://sounds/music/spookyvibes03.tres",
	"res://sounds/music/spookyvibes04.tres"
]

func _ready():
	$Music.stream.loop = false
	$Music.play(0)

func _on_Music_finished():
	$Music.stop()
	$Timer.start(rand_range(10, 30))

func _on_Timer_timeout():
	$Music.stop()
	$Music.stream = load(musics[randi() % musics.size()])
	$Music.stream.loop = false
	$Music.play(0)
