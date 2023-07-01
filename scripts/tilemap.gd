extends TileMap

const TILE_SIZE = Vector2i(80,80)
var astar = AStarGrid2D.new()

var asrama_coords = Array()
var asrama_atlas_coords = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
var kampus_coords = Array()
var kampus_atlas_coords = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1), Vector2i(2,0), Vector2i(2,1)]
var road_coord = Vector2i()

enum FACING { UP, LEFT, RIGHT, DOWN }


func is_road_buildable(local_mousepos):
	road_coord = local_to_map(local_mousepos)
	if road_coord.x < 0 or road_coord.x > 50 or road_coord.y < 0 or road_coord.y > 28 or get_cell_source_id(0,road_coord) == 0 or get_cell_source_id(1,road_coord) in [1,2]:
		return false
	return true

func place_road(new_road):
	set_cells_terrain_connect(0, [road_coord], 0, 0)
	new_road.position = map_to_local(road_coord)
	new_road.posisi_tile = road_coord

func remove_road(local_mousepos):
	var tilepos = local_to_map(local_mousepos)
	if get_cell_source_id(1,tilepos) in [1,2]:
		return
	erase_cell(0, tilepos)
	for tile in get_surrounding_cells(tilepos):
		if get_cell_source_id(0, tile) == 0:
			erase_cell(0, tile)
			set_cells_terrain_connect(0, [tile], 0, 0)


# method untuk menempatkan asrama pada map
func place_asrama(asrama, facing):
	for i in range(asrama_coords.size()):
		set_cell(1,asrama_coords[i],1,asrama_atlas_coords[i])
	asrama.position = map_to_local(asrama_coords[0])
	var gerbangpos = asrama_coords[facing]
	match facing:
		FACING.LEFT:
			asrama.sprite.flip_h = true
		FACING.UP:
			asrama.sprite.flip_h = true
			asrama.sprite.flip_v = true
		FACING.RIGHT:
			asrama.sprite.flip_v = true
	set_cells_terrain_connect(0, [gerbangpos], 0, 0)
	asrama_coords.erase(gerbangpos)
	return [gerbangpos, map_to_local(gerbangpos)] + asrama_coords # return koordinat gerbang, koordinat global + semua koordinat tile asrama


# method untuk memeriksa apakah ada jalan/bangunan yang akan
# menghalangi penempatan asrama
func is_asrama_buildable(pos):
	asrama_coords.clear()
	var start_tilepos = local_to_map(pos)
	for i in range(2):
		for j in range(2):
			var tilepos = start_tilepos + Vector2i(i,j)
			
			# cek apakah sudah ada tile jalan/bangunan di posisi
			if get_cell_source_id(0,tilepos) == 0 or get_cell_source_id(1,tilepos) in [1,2]:
				return false
			
			# cek apakah ada tile bangunan yang tepat bersebelahan
			for neighbor in get_surrounding_cells(tilepos):
				if get_cell_source_id(1,neighbor) in [1,2]:
					return false
			
			asrama_coords.append(tilepos)
	return true


# method untuk menempatkan kampus pada map
func place_kampus(new_kampus):
	for i in range(kampus_coords.size()):
		set_cell(1,kampus_coords[i],2,kampus_atlas_coords[i])
	new_kampus.global_position = map_to_local(kampus_coords[0])
	set_cells_terrain_connect(0, [kampus_coords[3]], 0, 0)
	return kampus_coords[3] # return koordinat gerbang


# method untuk memeriksa apakah ada jalan yang akan
# menghalangi penempatan kampus
func is_kampus_buildable(pos):
	kampus_coords.clear()
	var start_tilepos = local_to_map(pos)
	for i in range(3):
		for j in range(2):
			var tilepos = start_tilepos + Vector2i(i,j)
			
			# cek apakah sudah ada tile jalan/bangunan di posisi
			if get_cell_source_id(0,tilepos) == 0 or get_cell_source_id(1,tilepos) in [1,2]:
				return false
			
			# cek apakah ada tile bangunan yang tepat bersebelahan
			for neighbor in get_surrounding_cells(tilepos):
				if get_cell_source_id(1,neighbor) in [1,2]:
					return false
			
			kampus_coords.append(tilepos)
	return true


func find_path(start_point, end_point):
	var map_size = get_used_rect().end

	astar.size = map_size
	astar.cell_size = TILE_SIZE
	astar.offset = TILE_SIZE * 0.5
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in map_size.x:
		for j in map_size.y:
			var pos = Vector2i(i,j)
			if get_cell_source_id(0, pos) == -1:
				astar.set_point_solid(pos)
				
	return astar.get_point_path(start_point, end_point).duplicate()
