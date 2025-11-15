extends Control

func _ready():
	await get_tree().create_timer(2).timeout  
	var target_scene = ScreenLoader.target_scene_path
	if target_scene != "":
		get_tree().change_scene_to_file(target_scene)
	else:
		push_error("ScreenLoader.target_scene_path is empty!")
