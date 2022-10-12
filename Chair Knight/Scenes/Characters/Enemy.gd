extends KinematicBody2D


signal died

func _on_Hurtbox_body_entered(body):
	if body is Player:
		#print(body.prev_velocity.length())
		if body.prev_velocity.length() > 1000:
			call_deferred("emit_signal", "died")
