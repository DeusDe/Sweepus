extends Node

class board:
	var cells : Array = []
	var game_size : Vector2 = Vector2(0,0)
	var bomb_count : int = 0

	func _init(bomb_count,game_size):
		if ((game_size.x) <= 0 ) or ((game_size.y) <= 0):
			printerr("BOARD SIZE CANT BE NEGATIVE OR ZERO")
		var max_cells = game_size.x * game_size.y
		if(bomb_count > max_cells):
			printerr("BOMB COUNT EXCEEDS GAME SIZE")
		
		self.game_size = game_size
		self.bomb_count = bomb_count

		create_game_board()
		link_each_cells()

	func add_bombs_to_board():
		var added_bombs = 0
		while added_bombs < bomb_count:
			for row in range(game_size.x):
				for cell in range(game_size.y):
					var cur_cell = cells[row][cell]
					added_bombs+= 1 if add_rand_bomb(cur_cell) else 0
					if(added_bombs >=bomb_count):
						return

	func add_rand_bomb(cell):
		var rand_number = (randi_range(0,(game_size.x*game_size.y)))
		if (rand_number <= bomb_count and cell.get_bomb):
			cell.set_bomb(true)
			return true
		return false

	func generate_all_cells():
		cells = []
		for row in range(game_size.x):
			var row_arr : Array = []
			for cell in  range(game_size.y):
				row_arr.append(Cell.cell.new())
			cells.append(row_arr )

	func create_game_board():
		generate_all_cells()
		add_bombs_to_board()

	func print_terminal_board():
		for i in cells:
			var current_row = ""
			var current_neighbour_count = "\t"
			for y in i:
				var has_bomb = y.has_bomb
				var neighbours = y.neighbour_count
				current_row += "◻ " if has_bomb else "◼ "
				current_neighbour_count += str(neighbours) + " "
			print(current_row + current_neighbour_count)

	func link_single_cell(row,cell):
		for x_offset in range(Cell.neighbour_offset_min, Cell.neighbour_offset_max+1):
			for y_offset in range(Cell.neighbour_offset_min, Cell.neighbour_offset_max+1):
				var neighbor_cords = Vector2(row + x_offset,cell + y_offset)
				if neighbor_cords.x >= 0 and neighbor_cords.x < game_size.x and neighbor_cords.y >= 0 and neighbor_cords.y < game_size.y:
					if x_offset != 0 or y_offset != 0:
						cells[row][cell].neighbours[Cell.generate_dict_name(x_offset,y_offset)] = cells[neighbor_cords.x][neighbor_cords.y]
			
				cells[row][cell].calculate_neighbours()

	func link_each_cells():
		for row in range(game_size.x):
			for cell in range(game_size.y):
				link_single_cell(row,cell)

	func get_cell(row,cell):
		return cells[row][cell]
