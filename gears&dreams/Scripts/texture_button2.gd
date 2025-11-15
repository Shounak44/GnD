extends TextureButton

@onready var target_sprite: Sprite2D = $"/root/story5/CanvasLayer3/Sprite2D"

func _on_pressed():
	if target_sprite:  # safety check
		target_sprite.visible = not target_sprite.visible
