extends Node2D
class_name Bullet
# Bullet represents a projectile shot by EnemyRanged that damages the Player.


export(bool) var enemy_bullet = true
var velocity := Vector2.ZERO

onready var hitbox = $Hitbox
onready var lifetime_timer = $LifetimeTimer
onready var blood = $Particles2D


# Initialise the Bullet with various properties.
func init(initial_position: Vector2, initial_velocity: Vector2 = Vector2.ZERO, from_enemy: bool = true) -> void:
	initial_position.y += 40
	global_position = initial_position
	velocity = initial_velocity
	enemy_bullet = from_enemy


func _ready() -> void:
	if enemy_bullet: hitbox.collision_mask = 0b1000 # scan for player
	else: hitbox.collision_mask = 0b10000 # scan for enemies

func _physics_process(delta: float) -> void:
	position += velocity * delta # move the Bullet

# Destroy the Bullet if it applies damage to something.
func _on_Hitbox_applied_damage(damage) -> void:
	queue_free()

# Destroy the Bullet if it collides with something.
func _on_Hurtbox_body_entered(body: Node) -> void:
	queue_free()

# Destroy the Bullet if its lifetime has expired.
func _on_LifetimeTimer_timeout() -> void:
	queue_free()
