class_name DeathMenu
extends SubMenu

var score := 0 setget set_score

## Sets the score variable and updates the score label to show the change
func set_score(new_score):
	score = new_score
	$score.text = str(self.score)

func _ready():
	$Coin.position = Vector2(435, 272)

## Restarts the currently active scene
func restart():
	var err = get_tree().reload_current_scene()
	assert(err == OK)


## Sets the paused state of the scene treee
func set_paused(value : bool):
	get_tree().paused = value

## Switches the current scene to the one located at path. The current scene is destroyed
func change_scene(path : String):
	var err = get_tree().change_scene(path)
	if err != OK: push_error(str("custom_error: issue in changing to scene \"", path, "\""))

