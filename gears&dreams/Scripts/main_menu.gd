extends Control

func _on_play_pressed():
	ScreenLoader.load_scene("res://Scenes/story_1.tscn")

func _on_quit_pressed():
	get_tree().quit()
