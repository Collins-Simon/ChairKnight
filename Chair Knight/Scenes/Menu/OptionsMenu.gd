class_name OptionsMenu
extends SubMenu

func _ready():
	$"Difficulty multiplier/HSlider".value = Settings.difficulty_multiplier

## Sets the Settings singleton's difficulty_multiplier
func set_difficulty(difficulty : float):
	Settings.difficulty_multiplier = difficulty
