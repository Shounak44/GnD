extends Node2D

@onready var spin1 = $SpinBox
@onready var spin2 = $SpinBox2
@onready var spin3 = $SpinBox3
@onready var button = $Button

var correct_code = [5, 8, 1]

func _ready():
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	var entered_code = [int(spin1.value), int(spin2.value), int(spin3.value)]
	print("Entered:", entered_code)  # debug
	if entered_code == correct_code:
		print("✅ Correct code! Unlocking...")
		get_tree().change_scene_to_file("res://Scenes/game_4.tscn")
	else:
		print("❌ Wrong code! Try again.")
