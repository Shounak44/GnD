extends Node2D


func _on_animation_player_animation_finished(anim_name: StringName):
	ScreenLoader.load_scene("res://Scenes/story_7.tscn")
