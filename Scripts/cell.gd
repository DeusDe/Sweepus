extends Node

const neighbour_offset_max = 1
const neighbour_offset_min = -1

class cell:
	var has_bomb : bool = false #if the cell has a bomb
	var neighbour_count : int = 0
	#All neighbouring Cells around this cell.
	#	NW	N	NE
	#	W		E
	#	SW	S	SE	
	var neighbours = {}

	func calculate_neighbours():
		neighbour_count = 0
		for neighbour in neighbours:
			var cur_neighbour = neighbours[neighbour]
			if(cur_neighbour != null ) and (cur_neighbour.has_bomb):
				neighbour_count += 1

	func get_bomb():
		return has_bomb
	
	func set_bomb(bomb:bool):
		has_bomb = bomb

func generate_dict_name(row,cell):
	return "x(" + str(row) + ")_y(" + str(cell) + ")"
