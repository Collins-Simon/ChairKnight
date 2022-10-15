extends Node2D
class_name Explosion
# Explosion consists of an area that hurts Characters, and a cool particle effect.


onready var anim_player = $AnimationPlayer


# Play the explosion animation as soon as the Explosion is created.
func _ready() -> void:
	anim_player.play("Explosion")
