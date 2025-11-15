extends Control

@export var puzzle_texture: Texture2D   # assign your 250x250 image
const GRID_SIZE := 3
const TILE_SIZE := 250 / GRID_SIZE  # ~83 px each

var pieces: Array = []

func _ready():
	make_pieces()
	shuffle_pieces()


func make_pieces():
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			var piece = preload("res://Scenes/piece_2.tscn").instantiate()
			add_child(piece)  # child of PuzzleBoard

			# Slice part of the big texture
			piece.set_region(
				puzzle_texture,
				Rect2(col * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE)
			)
			piece.size = Vector2(TILE_SIZE, TILE_SIZE)

			# Store correct local position
			var correct_pos = Vector2(col * TILE_SIZE, row * TILE_SIZE)
			piece.correct_pos = correct_pos
			piece.position = correct_pos  # start solved, then shuffle

			pieces.append(piece)


func shuffle_pieces():
	randomize()
	for p in pieces:
		var max_pos = size - Vector2(TILE_SIZE, TILE_SIZE)
		var rand_pos = Vector2(
			randi_range(0, int(max_pos.x)),
			randi_range(0, int(max_pos.y))
		)
		p.position = rand_pos


# Called by pieces to check if puzzle is fully solved
func check_solved():
	for p in pieces:
		if p.position != p.correct_pos:
			return false
	return true
