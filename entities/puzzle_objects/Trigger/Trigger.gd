extends StaticBody

export(NodePath) var target

func interact(x):
	get_node(target).interact(x)
