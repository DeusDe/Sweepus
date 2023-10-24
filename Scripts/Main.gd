extends Node2D

@onready var cell_scene = preload("res://Scenes/cells.tscn")
@onready var camera : Camera2D = get_node("Camera2D")
@onready var sprite_soue = 16
var zoom_speed = 0.1
func _ready():
	camera.zoom = Vector2(2,2)
	var current_board = Board.board.new(100,Vector2(30,30))
	var cell_offset = -(8*current_board.game_size.y) + 8
	var row_offset = -(8*current_board.game_size.x) + 8
	for row in range(int(current_board.game_size.x)):
		for cell in range(int(current_board.game_size.y)):
			var cur_cell = cell_scene.instantiate()
			cur_cell.position = Vector2(16*row + row_offset ,16*cell + cell_offset)
			add_child(cur_cell)
			cur_cell.set_cell(current_board.get_cell(row,cell))
			cur_cell.update_neighbours()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 4 or event.button_index == 5:
			var zoom_out = false
			if event.button_index == 5:
				zoom_out = true
			var zoom = (-1 if zoom_out else 1) * zoom_speed
			camera.zoom = clamp(camera.zoom-Vector2(zoom,zoom),Vector2(0.5,0.5),Vector2(5,5))
