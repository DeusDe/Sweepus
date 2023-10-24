extends Node

const neighbour_offset_max = 1
const neighbour_offset_min = -1



class cell:
	var has_bomb : bool = false #if the cell has a bomb
	var neighbour_count : int = 0
	var unveiled : bool = false
	var flagged : bool = false
	signal unveil_empty
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
	
	func get_neighbour_count():
		return neighbour_count
	
	func unveil_empty_cells(first : bool):
		if !unveiled and !has_bomb and !flagged and ((neighbour_count == 0) or (first)):
			unveil_empty.emit()
			set_unveiled()
			var cells = [Cell.generate_dict_name(1,0),Cell.generate_dict_name(-1,0),Cell.generate_dict_name(0,1),Cell.generate_dict_name(0,-1)]
			for cell in cells:
				if cell in neighbours:
					neighbours[cell].unveil_empty_cells(true if (neighbour_count == 0) else false)
	
	func set_unveiled():
		self.unveiled = true
	
	func is_unveiled():
		return unveiled
	
	func check_all_neighbours():
		var flagged_neighbours = 0
		for neighbour in neighbours:
			if neighbours[neighbour].is_flagged():
				flagged_neighbours+=1

		if(flagged_neighbours == neighbour_count):
			for neighbour in neighbours:
				neighbours[neighbour].unveil_empty_cells(true)
	
	func is_flagged():
		return flagged
	
	func set_flagged(flagged : int):
		self.flagged = flagged

func generate_dict_name(row,cell):
	return "x(" + str(row) + ")_y(" + str(cell) + ")"
