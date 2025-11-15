extends Control

func _ready():
	hide()

func _unhandled_input(event):
	if event.is_action_pressed("player_pause"):
		if visible:
			_on_reume_button_pressed()
		else:
			open()

func open():
	show()
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS



func _on_main_menu_button_pressed():
	get_tree().paused = false
	ScreenLoader.load_scene("res://Scenes/main_menu.tscn")


func _on_reume_button_pressed():
	get_tree().paused = false
	hide()


func _on_exit_pressed():
	get_tree().quit()
