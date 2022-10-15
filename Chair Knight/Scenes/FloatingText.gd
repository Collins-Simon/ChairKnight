extends Node2D
class_name FloatingText


var text: String
var color: Color

onready var label = $Label
onready var float_tween = $FloatTween


func init(text: String, color: Color) -> void:
	self.text = text
	self.color = color


func _ready() -> void:
	label.text = text
	label.add_color_override("font_color", color)
	var duration = 0.75
	float_tween.interpolate_property(self, "position", position, position - Vector2(0, 20), duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	float_tween.interpolate_property(self, "modulate:a", 1.0, 0.0, duration, Tween.TRANS_CUBIC, Tween.EASE_IN)
	float_tween.start()


func _on_FloatTween_tween_all_completed() -> void:
	queue_free()
