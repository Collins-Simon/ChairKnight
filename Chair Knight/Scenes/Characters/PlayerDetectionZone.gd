extends Area2D


var player: Player = null


func player_detected() -> bool:
	return player != null and not player.destroyed

func _on_PlayerDetectionZone_body_entered(body: Player) -> void:
	player = body

func _on_PlayerDetectionZone_body_exited(body: Player) -> void:
	player = null
