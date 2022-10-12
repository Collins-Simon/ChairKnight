extends DampedSpringJoint2D


#func set_links(a, b):
#	node_a = a
#	node_b = b

func set_links(a, b, length):
	node_a = a
	node_b = b
	self.length = length
	rest_length = 1

func pull():
	rest_length = 1
