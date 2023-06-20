extends TileMap

var asrama_coords = PackedVector2Array()
var asrama_atlas_coords = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
var kampus_coords = PackedVector2Array()
var kampus_atlas_coords = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1), Vector2i(2,0), Vector2i(2,1)]


func place_road(local_mousepos):
	var tilepos = local_to_map(local_mousepos)
	if get_cell_source_id(1,tilepos) in [1,2]:
		return
	set_cells_terrain_connect(0, [tilepos], 0, 0)


func remove_road(local_mousepos):
	var tilepos = local_to_map(local_mousepos)
	if get_cell_source_id(1,tilepos) in [1,2]:
		return
	erase_cell(0, tilepos)
	for tile in get_surrounding_cells(tilepos):
		if get_cell_source_id(0, tile) == 0:
			erase_cell(0, tile)
			set_cells_terrain_connect(0, [tile], 0, 0)


func place_asrama(pos):
	asrama_coords.clear()
	var tilepos = local_to_map(pos)
	for i in range(2):
		for j in range(2):
			asrama_coords.append(tilepos + Vector2i(i,j))
	for i in range(asrama_coords.size()):
		set_cell(1,asrama_coords[i],1,asrama_atlas_coords[i])
	set_cells_terrain_connect(0, [asrama_coords[-1]], 0, 0)


func place_kampus(pos):
	kampus_coords.clear()
	var tilepos = local_to_map(pos)
	for i in range(3):
		for j in range(2):
			kampus_coords.append(tilepos + Vector2i(i,j))
	for i in range(kampus_coords.size()):
		set_cell(1,kampus_coords[i],2,kampus_atlas_coords[i])
	set_cells_terrain_connect(0, [kampus_coords[3]], 0, 0)
