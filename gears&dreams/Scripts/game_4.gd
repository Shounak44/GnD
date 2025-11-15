extends Node2D

@onready var anim1 = $Anim1
@onready var anim2 = $Anim2
@onready var button1 = $Button1
@onready var button2 = $Button2

var anim1_on = false
var anim2_on = false

func _ready():
	button1.pressed.connect(_on_button1_pressed)
	button2.pressed.connect(_on_button2_pressed)

func _on_button1_pressed():
	anim1.play("default")   # apna animation naam daal
	anim1_on = true
	_check_done()

func _on_button2_pressed():
	anim2.play("default")   # apna animation naam daal
	anim2_on = true
	_check_done()

func _check_done():
	if anim1_on and anim2_on:
		await get_tree().create_timer(3.0).timeout  # 5 sec wait
		get_tree().change_scene_to_file("res://Scenes/game_5.tscn")
