extends DampedSpringJoint2D


func set_links(a, b, length):
	node_a = a
	node_b = b
	self.length = length
	rest_length = 1
