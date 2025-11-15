extends Node2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var anim_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

# Initial fade animation that plays on load
@export var fade_anim_name: String = "fade4"

# Dialogue sequence — panel names must match the Panel nodes under CanvasLayer
var dialogue_sequence := [
	{"speaker":"MinaPanel", "text":"Hi Nani, how are you?"},
	{"speaker":"NaniPanel", "text":"I'm very good! You've gotten so big, aww."},
	{"speaker":"MaaPanel",  "text":"Yes, time flies so quickly..."},
	{"speaker":"PaaPanel",  "text":"It's been so long since we all came to India"},
	{"speaker":"NaniPanel", "text":"Less talk now, first take some rest and eat some Mawa Kachori, that I'd made"}
]

var current_index: int = 0
var typing_speed := 0.05
var typing_timer: Timer
var dialogue_text: RichTextLabel = null
var is_typing := false
var dialogues_active := false  # becomes true after initial fade finishes

func _ready() -> void:
	_hide_all_panels()

	# Timer for typewriter effect
	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	typing_timer.one_shot = false
	add_child(typing_timer)
	typing_timer.timeout.connect(_on_typing_tick)

	# Listen for fade end
	anim_player.animation_finished.connect(_on_animation_finished)

	# Safety: start immediately if fade is not set or not playing
	if fade_anim_name == "" or not anim_player.is_playing():
		_start_dialogues()

	# Apply default font size override for all DialogueText labels
	var panels = ["MinaPanel","NaniPanel","MaaPanel","PaaPanel"]
	for p in panels:
		if canvas_layer.has_node(p):
			var lbl = canvas_layer.get_node(p).get_node("MarginContainer/DialogueText") as RichTextLabel
			if lbl:
				lbl.add_theme_font_size_override("normal_font_size", 13) # adjust size here

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == fade_anim_name:
		_start_dialogues()

func _start_dialogues() -> void:
	dialogues_active = true
	current_index = 0
	_play_current_dialogue()

func _input(event: InputEvent) -> void:
	if not dialogues_active:
		return

	if event.is_action_pressed("ui_accept"):
		if is_typing:
			# finish current line immediately
			if dialogue_text:
				dialogue_text.visible_characters = dialogue_text.text.length()
			is_typing = false
			typing_timer.stop()
		else:
			# next dialogue
			current_index += 1
			if current_index < dialogue_sequence.size():
				_play_current_dialogue()
			else:
				# sequence finished — go to next scene
				get_tree().change_scene_to_file("res://Scenes/story_6.tscn")

func _play_current_dialogue() -> void:
	_hide_all_panels()
	var entry = dialogue_sequence[current_index]
	var panel_name: String = entry["speaker"]

	if not canvas_layer.has_node(panel_name):
		push_error("Panel not found: " + panel_name)
		return

	var panel: Panel = canvas_layer.get_node(panel_name) as Panel
	panel.visible = true

	dialogue_text = panel.get_node("MarginContainer/DialogueText") as RichTextLabel
	if not dialogue_text:
		push_error("DialogueText not found under " + panel_name)
		return

	# prepare typewriter
	dialogue_text.text = entry["text"]
	dialogue_text.visible_characters = 0
	is_typing = true
	typing_timer.start()

func _on_typing_tick() -> void:
	if dialogue_text and dialogue_text.visible_characters < dialogue_text.text.length():
		dialogue_text.visible_characters += 1
	else:
		is_typing = false
		typing_timer.stop()

func _hide_all_panels() -> void:
	for n in ["MinaPanel","NaniPanel","MaaPanel","PaaPanel"]:
		if canvas_layer.has_node(n):
			canvas_layer.get_node(n).visible = false
