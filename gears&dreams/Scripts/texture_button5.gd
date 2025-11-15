extends TextureButton

@onready var target_sprite: Sprite2D = $"/root/game4/Sprite2D8"

func _ready():
	connect("pressed", _on_pressed)

func _on_pressed():
	if target_sprite:  # safety check
		target_sprite.visible = not target_sprite.visible
