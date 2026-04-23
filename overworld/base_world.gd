extends TileMapLayer

func _ready() -> void:
	var filled_cells = get_used_cells()
	for filled_tile: Vector2 in filled_cells:
		
		var neighbouring_cells = get_surrounding_cells(filled_tile)
		#get_used_cells_by_id(1,Vector2i(0,2))
		for neighbour: Vector2 in neighbouring_cells:
			if get_cell_source_id(neighbour) == -1:
				set_cell(neighbour, 1, Vector2i.ZERO)
