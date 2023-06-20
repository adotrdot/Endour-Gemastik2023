extends TileMap


const TILE_SIZE = Vector2i(80,80)

var astar = AStarGrid2D.new()
var start_point = Vector2i(4,3)
var end_point = Vector2i(19,6)

@onready var siswa = get_node("../Siswa")

# Called when the node enters the scene tree for the first time.
func _ready():
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


func find_path(start_point, end_point):
	return astar.get_point_path(start_point, end_point).duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
