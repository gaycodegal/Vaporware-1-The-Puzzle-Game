
extends StaticBody


var tween: Tween

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	tween = get_node("tween")

func interact(relate):
	if not tween.is_active():
		tween.interpolate_property(self, "translation", translation, translation + Vector3(1,0,0), 1.0, Tween.TRANS_CUBIC)
		tween.start()
	
