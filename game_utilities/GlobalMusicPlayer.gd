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

func load_ogg(path):
	var ogg_file = File.new()
	ogg_file.open(path, File.READ)
	var bytes = ogg_file.get_buffer(ogg_file.get_len())
	var stream = AudioStreamOGGVorbis.new()
	stream.data = bytes
	$Music.stream = stream
	ogg_file.close()


func _on_Music_finished():
	$Music.stop()
	$Timer.start(rand_range(10, 30))

func _on_Timer_timeout():
	$Music.stop()
	load_ogg(musics[randi() % musics.size()])
	$Music.stream.loop = false
	$Music.play(0)
