extends PanelContainer

@onready var dialogue_text: RichTextLabel = $DialogueText

var dialogues := [
	"Mina, a 14 year old girl, came to India for a trip...",
	"She was so excited to see the land of stories her mother told her about.",
	"The clouds outside the plane looked like cotton candy, dancing in the sky."
]

var current_index := 0
var typing_speed := 0.05  # seconds per character
var is_typing := false
var typing_timer: Timer
var dialogues_finished := false  # track when dialogue ends

func _ready() -> void:
	# Fill the panel and center the text
	dialogue_text.set_anchors_preset(Control.PRESET_FULL_RECT)
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	typing_timer.one_shot = false
	add_child(typing_timer)
	typing_timer.timeout.connect(_on_typing_tick)

	_show_line(dialogues[current_index])

func _show_line(text: String) -> void:
	dialogue_text.text = text
	dialogue_text.visible_characters = 0
	is_typing = true
	typing_timer.start()

func _on_typing_tick() -> void:
	if dialogue_text.visible_characters < dialogue_text.text.length():
		dialogue_text.visible_characters += 1
	else:
		is_typing = false
		typing_timer.stop()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # Enter key
		if dialogues_finished:
			# Switch to next scene
			get_tree().change_scene_to_file("res://Scenes/story_2.tscn")
		elif is_typing:
			# Finish current line instantly
			dialogue_text.visible_characters = dialogue_text.text.length()
			is_typing = false
			typing_timer.stop()
		else:
			# Advance to next line or finish
			current_index += 1
			if current_index < dialogues.size():
				_show_line(dialogues[current_index])
			else:
				dialogues_finished = true
				dialogue_text.text = "[center]Press Enter to continue...[/center]"
