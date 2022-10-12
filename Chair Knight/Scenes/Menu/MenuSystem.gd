class_name MenuSystem
extends Control

## A class for keeping track of many SubMenu as its children.
##
## This class keeps track of the currently active (visible) SubMenu.

## Path to the scene to use in the interim of changing the current scene.
const LOADING_SCENE_PATH = "res://Scenes/Menu/LoadingScene.tscn"

const GAME_SCENE_PATH = "res://Scenes/Game.tscn"

## The currently visible SubMenu
onready var active_menu : SubMenu = $TitleMenu

## Close the currently running application. To be used by buttons.
func quit(): get_tree().quit()

## Switch between SubMenus
func transition_to_menu(path : String):
	var other = get_node(path)
	assert (other is SubMenu, str("custom error: transition_to_menu ", path, " was not a menu"))
	active_menu.visible = not active_menu.visible
	active_menu = other
	active_menu.visible = not active_menu.visible
	active_menu.local_focus.grab_focus()

func _ready():
	for child in get_children():
		if child is SubMenu:
			child.visible = child == active_menu
	active_menu.local_focus.grab_focus()

## Change to current scene to the one located at path.
## The scene located at LOADING_SCENE_PATH will be loaded in the interim
func custom_load_scene(path: String):

	# prepare loader
	var loader = ResourceLoader.load_interactive(path)
	if loader == null:
		print("custom error: ResourceLoader unable to load resource at: ", path)
		return

	var loading_scene = load(LOADING_SCENE_PATH).instance()
	var loading_bar : ProgressBar = loading_scene.get_node("bar")

	get_tree().get_root().add_child(loading_scene)

	# handle loading
	while true:
		var err = loader.poll()
		match err:
			OK:
				var progress = float(loader.get_stage()) / loader.get_stage_count()
				loading_bar.value = progress * 100
			ERR_FILE_EOF:
				var resource = loader.get_resource()
				err = get_tree().change_scene_to(resource)
				if err != OK:
					print("custom error: unhandled in changing scene: ", err)
					return
				loading_scene.queue_free()
				break
			_:
				print("custom error: unhandled in loading: ", err)
				return
		yield(get_tree(), "idle_frame") # wait a frame before continuing


func _on_buttonStart_pressed() -> void:
	custom_load_scene(GAME_SCENE_PATH)
