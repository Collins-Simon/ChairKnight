extends Node2D
class_name Bullet


export(bool) var enemy_bullet = true
var velocity := Vector2.ZERO

onready var hitbox = $Hitbox
onready var lifetime_timer = $LifetimeTimer


func init(initial_position: Vector2, initial_velocity: Vector2 = Vector2.ZERO, from_enemy: bool = true) -> void:
	global_position = initial_position
	velocity = initial_velocity
	enemy_bullet = from_enemy

func _ready() -> void:
	if enemy_bullet: hitbox.collision_mask = 0b10 # scan for player
	else: hitbox.collision_mask = 0b100 # scan for enemies

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_Hitbox_applied_damage(damage) -> void:
	queue_free()

func _on_Hurtbox_body_entered(body: Node) -> void:
	queue_free()

func _on_LifetimeTimer_timeout() -> void:
	queue_free()
