extends Area2D
# PlayerDetectionZone keeps track of whether the Player is within range.


var player: Player = null


# Returns if the Player is detected.
func player_detected() -> bool:
	return player != null and not player.destroyed

# Stores a Player reference when they enter the area.
func _on_PlayerDetectionZone_body_entered(body: Player) -> void:
	player = body

# Removes the stored Player reference when they leave the area.
func _on_PlayerDetectionZone_body_exited(body: Player) -> void:
	player = null
