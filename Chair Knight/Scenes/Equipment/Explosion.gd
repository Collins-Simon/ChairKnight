extends Node2D
class_name Explosion


onready var anim_player = $AnimationPlayer


func _ready() -> void:
	anim_player.play("Explosion")
