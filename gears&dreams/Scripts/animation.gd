extends Node2D


func _on_animated_sprite_2d_animation_finished():
	ScreenLoader.load_scene("res://Scenes/game_3.tscn")
