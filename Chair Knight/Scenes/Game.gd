extends Node2D


var rope_scene = preload("res://Scenes/Equipment/Rope.tscn")
var rope: Rope = null

var peg_scene = preload("res://Scenes/Equipment/Peg.tscn")

onready var player = $Player



func _on_GrappleTarget_clicked(target):
	if rope != null: return
	rope = rope_scene.instance()
	rope.init(player, target)
	add_child(rope)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.is_pressed():
		if rope == null: return
		remove_child(rope)
		rope.queue_free()
		rope = null

	elif event is InputEventKey:
		if event.scancode == KEY_R and event.is_pressed():
			get_tree().reload_current_scene()
		elif event.scancode == KEY_SPACE and event.is_pressed():
			attempt_rope_launch()


func attempt_rope_launch():
	if rope == null: return
	var end_body = rope.end_body
	remove_child(rope)
	rope.queue_free()
	rope = null

	player.launch(end_body.global_position)


func _on_Player_attempted_peg(pos):
	if rope == null: return
	var end_body = rope.end_body
	remove_child(rope)
	rope.queue_free()
	rope = null

	var peg = peg_scene.instance()
	peg.global_position = pos;
	add_child(peg)

	var detached_rope = rope_scene.instance()
	detached_rope.init(peg, end_body)
	add_child(detached_rope)
