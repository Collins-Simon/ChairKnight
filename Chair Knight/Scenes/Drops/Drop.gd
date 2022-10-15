extends Area2D
class_name Drop
# Drop represents a generic Enemy drop that can be picked up by the Player.


export(int) var value := 0
var target = null

const MAX_SPEED = 2000.0
const ACCELERATION = 7500.0
var velocity := Vector2.ZERO

onready var timer = $UndetectableTimer


# Initialise the Drop with a position and velocity.
func init(pos: Vector2, velocity: Vector2 = Vector2.INF) -> void:
	global_position = pos
	if velocity == Vector2.INF:
		velocity = Vector2.ONE.rotated(randf() * TAU) * rand_range(100, 250)
	self.velocity = velocity

func _ready() -> void:
	# Play bobbing up and down animation:
	$BobbingAnimationPlayer.play("Bobbing")

func _physics_process(delta: float) -> void:
	# Move towards target:
	if target != null:
		var disp = target.global_position - global_position
		var desired_velocity = (disp * 10.0).clamped(MAX_SPEED)
		velocity = velocity.move_toward(desired_velocity, ACCELERATION * delta)
	global_position += velocity * delta
	velocity *= 0.95

# Sets the entity that this Drop should fly towards (usually the Player).
func set_target(target) -> void:
	self.target = target

# Makes the Drop detectable after a brief grace period.
func _on_UndetectableTimer_timeout() -> void:
	monitorable = true
