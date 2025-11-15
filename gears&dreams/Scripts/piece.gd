extends TextureRect

var dragging := false
var offset := Vector2.ZERO
var correct_pos := Vector2.ZERO
var puzzle_solved := false  # flag to tell if puzzle is complete

func set_region(atlas: Texture2D, rect: Rect2):
	texture = AtlasTexture.new()
	texture.atlas = atlas
	texture.region = rect

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			dragging = true
			offset = event.position
		else:
			dragging = false
			snap_to_grid()
	elif event is InputEventMouseMotion and dragging:
		# move inside PuzzleBoard
		var new_pos = position + event.relative
		var parent_size = (get_parent() as Control).size

		# clamp inside PuzzleBoard
		new_pos.x = clamp(new_pos.x, 0, parent_size.x - size.x)
		new_pos.y = clamp(new_pos.y, 0, parent_size.y - size.y)

		position = new_pos

func _process(_delta):
	if puzzle_solved and Input.is_action_just_pressed("ui_accept"):
		ScreenLoader.load_scene("res://Scenes/story_3.tscn")

func snap_to_grid():
	var tile_size = 250 / 3
	position = position.snapped(Vector2(tile_size, tile_size))

	if position == correct_pos:
		modulate = Color(0.8, 1.0, 0.8)
	else:
		modulate = Color(1, 1, 1)

	# Check if puzzle is solved
	if get_parent().check_solved():
		puzzle_solved = true  # only set flag, wait for player input
