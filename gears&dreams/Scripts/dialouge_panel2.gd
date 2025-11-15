extends Panel

@onready var dialogue_text: RichTextLabel = $MarginContainer/DialogueText
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"  # go up to CanvasLayer, then into AnimationPlayer

var dialogues := [
	"Built in 1724, Jantar Mantar is like a giant stone clock and telescope.
Its walls and sundials were so precise, they could tell the exact time, track the sun’s path, and even spot stars and planets  all without machines! Its not just an architecture but a humongous stone computer!"
]

var current_index := 0
var typing_speed := 0.05  # seconds per character
var is_typing := false
var typing_timer: Timer

func _ready() -> void:
	visible = false  # keep hidden until fade ends

	# Setup dialogue text
	dialogue_text.set_anchors_preset(Control.PRESET_FULL_RECT)
	dialogue_text.autowrap_mode = TextServer.AUTOWRAP_WORD
	dialogue_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# Timer for typewriter effect
	typing_timer = Timer.new()
	typing_timer.wait_time = typing_speed
	typing_timer.one_shot = false
	add_child(typing_timer)
	typing_timer.timeout.connect(_on_typing_tick)

	# Connect animation finish
	if anim_player:
		anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
	# No need to check the name unless you have multiple animations
	visible = true
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
	if event.is_action_pressed("ui_accept"):
		if is_typing:
			dialogue_text.visible_characters = dialogue_text.text.length()
			is_typing = false
			typing_timer.stop()
		else:
			if current_index < dialogues.size() - 1:
				current_index += 1
				_show_line(dialogues[current_index])
			else:
				ScreenLoader.load_scene("res://Scenes/story_3.tscn")
