extends Node2D

var can_place = true
@onready var tilemap = $TileMap


func _ready():
	tilemap.add_layer(1)
	var asrama_tilepos = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
	var asrama_atlas_coords = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1)]
	for i in range(4):
		tilemap.set_cell(1,asrama_tilepos[i],1,asrama_atlas_coords[i])
	tilemap.set_cells_terrain_connect(0, [asrama_tilepos[-1]], 0, 0)
	
	var kampus_tilepos = [Vector2i(10,10), Vector2i(10,11), Vector2i(11,10), Vector2i(11,11), Vector2i(12,10), Vector2i(12,1)]
	var kampus_atlas_coords = [Vector2i(0,0), Vector2i(0,1), Vector2i(1,0), Vector2i(1,1), Vector2i(2,0), Vector2i(2,1)]
	for i in range(6):
		tilemap.set_cell(1,kampus_tilepos[i],2,kampus_atlas_coords[i])
	tilemap.set_cells_terrain_connect(0, [kampus_tilepos[3]], 0, 0)


func _process(delta):
	if can_place:
		if Input.is_action_pressed("mb_left"):
			place_tile()
		elif Input.is_action_pressed("mb_right"):
			remove_tile()

func place_tile():
	var mousepos : Vector2i = get_local_mouse_position()
	var tilepos = tilemap.local_to_map(mousepos)
	tilemap.set_cells_terrain_connect(0, [tilepos], 0, 0)
	
	
func remove_tile():
	var mousepos : Vector2i = get_local_mouse_position()
	var tilepos = tilemap.local_to_map(mousepos)
	if tilemap.get_cell_source_id(1,tilepos) == 1:
		return
	tilemap.erase_cell(0, tilepos)
	for tile in tilemap.get_surrounding_cells(tilepos):
		if tilemap.get_cell_source_id(0, tile) == 0:
			tilemap.erase_cell(0, tile)
			tilemap.set_cells_terrain_connect(0, [tile], 0, 0)
