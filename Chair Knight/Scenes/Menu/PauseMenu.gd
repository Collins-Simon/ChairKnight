class_name PauseMenu
extends SubMenu

func _unhandled_input(event):
	if event is InputEventKey and event.scancode == KEY_ESCAPE and event.is_pressed():
			queue_free()
			get_tree().set_input_as_handled()
			

func set_paused(value : bool):
	get_tree().paused = value

func change_scene(path : String):
	var err = get_tree().change_scene(path)
	if err != OK: push_error(str("custom_error: issue in changing to scene \"", path, "\""))

func quit():
	get_tree().quit()
