extends Node2D
class_name Rope


var link_scene = preload("res://Scenes/Equipment/RopeLink.tscn")
var joint_scene = preload("res://Scenes/Equipment/RopeJoint.tscn")

var links = []
var link_length = 50
var joints = []

var start_body: RigidBody2D = null
var end_body: RigidBody2D = null

onready var line = $Line2D


func init(start, end):
	start_body = start
	end_body = end
	start.attach_rope(self)
	end.attach_rope(self)

func destroy():
	start_body.detach_rope(self)
	end_body.detach_rope(self)
	self.queue_free()

func _ready():
	var start_pos = start_body.global_position
	var end_pos = end_body.global_position
	#var angle = start_pos.angle_to(end_pos)
	var dist = start_pos.distance_to(end_pos)
	var num_links = floor(dist / link_length)
	var num_joints = num_links + 1

	var diff = start_pos - end_pos
	var dist_scaled = num_links * link_length
	var diff_scaled = diff * (dist_scaled / dist)
	var start_pos_scaled = end_pos + diff_scaled

	for i in range(num_links):
		var link = link_scene.instance()
		link.global_position = lerp(start_pos_scaled, end_pos, i / num_links)
		links.append(link)
		add_child(link)

	links.push_front(start_body)
	links.append(end_body)

	for i in range(num_joints):
		var joint = joint_scene.instance()
		var pos
		if i == 0: pos = start_pos
		else: pos = lerp(start_pos_scaled, end_pos, (i-1) / (num_joints-1))
		joint.global_position = pos
		joint.rotation = pos.angle_to_point(links[i+1].global_position) + deg2rad(90)
		#joint.rotate(-angle)
		joints.append(joint)
#		add_child(joint)

	if num_joints == 1:
		joints[0].disable_collision = false

	for i in range(num_joints):
		if i == 0: joints[i].set_links(links[i].get_path(), links[i+1].get_path(), dist - dist_scaled)
		else: joints[i].set_links(links[i].get_path(), links[i+1].get_path(), link_length)
		#joints[i].rotation = joints[i].global_position.angle_to_point(links[i+1].global_position) + deg2rad(90)
		add_child(joints[i])

	for link in links:
		line.add_point(link.global_position)

func _physics_process(delta):
	for i in range(links.size()):
		line.set_point_position(i, links[i].global_position)
