extends Node2D

@onready var sprite : Sprite2D = get_node("Sprite")
const button_sprite : int = 0
const empty_sprite : int = 1
const flag_sprite : int = 2
const ghost_flag_sprite : int = 3
const first_number_sprite : int = 5
const bomb_sprite : int = 4
var selected_sprite : int = empty_sprite
var cell : Cell.cell = null

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.frame = button_sprite
	

func set_cell(cell : Cell.cell):
	self.cell = cell
	cell.unveil_empty.connect(_unveil)

func _unveil():
	if(cell.is_flagged()):
		return
	sprite.frame = selected_sprite

func _on_area_mouse_entered():
	sprite.modulate = Color(0.5,0.5,0.5)


func _on_area_mouse_exited():
	sprite.modulate = Color(1,1,1)

func _on_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if(cell.is_unveiled()):
				cell.check_all_neighbours()
			else:
				is_clicked()
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			set_flagged()

func set_flagged():
	if(cell.is_unveiled()):
		return
	if(cell.is_flagged()):
		cell.set_flagged(false)
		sprite.frame = button_sprite
	else:
		cell.set_flagged(true)
		sprite.frame = flag_sprite

func is_clicked():
	if(cell.is_flagged()):
		return
	sprite.frame = selected_sprite
	if(cell.has_bomb):
		
		cell.set_unveiled()
	if(cell.get_neighbour_count() == 0):
		cell.unveil_empty_cells(true)

func update_neighbours():
	var neighbours = cell.get_neighbour_count()
	if(cell.has_bomb):
		selected_sprite = bomb_sprite;
	elif(neighbours == 0):
		selected_sprite = empty_sprite;
	else:
		selected_sprite = first_number_sprite + neighbours - 1
	
