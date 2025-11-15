extends Node

var target_scene_path: String = ""

func load_scene(path: String) -> void:
	target_scene_path = path
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")
