extends Node

var musics = [
	"res://sounds/Music/SpookyVibes01.ogg",
	"res://sounds/Music/SpookyVibes02.ogg",
	"res://sounds/Music/SpookyVibes03.ogg",
	"res://sounds/Music/SpookyVibes04.ogg"
]

func _ready():
	$Music.stream.loop = false
	$Music.play(0)
	_on_Timer_timeout()


func _on_Music_finished():
	$Music.stop()
	$Timer.start(rand_range(10, 30))

func _on_Timer_timeout():
	$Music.stop()
	$Music.stream = load(musics[randi() % musics.size()])
	$Music.stream.loop = false
	$Music.play(0)
