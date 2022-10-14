class_name PauseMenu
extends SubMenu

## Handles input events
func _unhandled_input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.is_pressed():
			queue_free()
			get_tree().set_input_as_handled()
			
## Sets the paused state of the scene treee
func set_paused(value : bool):
	get_tree().paused = value

## Switches the current scene to the one located at path. The current scene is destroyed
func change_scene(path : String):
	var err = get_tree().change_scene(path)
	if err != OK: push_error(str("custom_error: issue in changing to scene \"", path, "\""))

## Quits the scene tree
func quit():
	get_tree().quit()
