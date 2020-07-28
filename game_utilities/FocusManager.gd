extends Node

export(Array, NodePath) var control_containers
export(NodePath) var scroll_container_path
export(bool) var wait_to_focus = false

func _ready():
	if not wait_to_focus:
		set_up()

func set_up():
	for container in control_containers:
		for child in get_node(container).get_children():
			child.connect("focus_entered", self, "_on_focus_change")

func _on_focus_change():
	var scroll_container: ScrollContainer = get_node(scroll_container_path)
	var focused:Control = scroll_container.get_focus_owner()
	
	var extra_space = 10
	var focus_offset = focused.get_global_rect().position.y - extra_space
	var height = scroll_container.get_viewport_rect().size.y - focused.get_size().y - extra_space

	if focus_offset < 0 or focus_offset >= height:
		scroll_container.set_v_scroll(scroll_container.get_v_scroll() + focus_offset )
