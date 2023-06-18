extends Node2D

var can_place = true
@onready var tilemap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	pass
	
func remove_tile():
	var mousepos : Vector2i = get_local_mouse_position()
	var tilepos = tilemap.local_to_map(mousepos)
	tilemap.erase_cell(0, tilepos)
	for tile in tilemap.get_surrounding_cells(tilepos):
		if tilemap.get_cell_source_id(0, tile) != -1:
			tilemap.erase_cell(0, tile)
			tilemap.set_cells_terrain_connect(0, [tile], 0, 0)
	pass
