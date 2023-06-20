extends Marker2D


enum State { IDLE, TRAVEL }

const MASS = 10.0
const ARRIVAL_DISTANCE = 10.0

var speed = 150.0
var state = State.TRAVEL
var velocity = Vector2()

@onready var tilemap = get_node("../TileMap")

var path = PackedVector2Array()
var next_point = Vector2()

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state  == State.IDLE:
		return
	var arrived_to_next_point = move_to(next_point)
	if arrived_to_next_point:
		path.remove_at(0)
		if path.is_empty():
			state = State.IDLE
			return
		next_point = path[0]
	

func move_to(local_position):
	var desired_velocity = (local_position - position).normalized() * speed
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()
	rotation = velocity.angle()
	return position.distance_to(local_position) < ARRIVAL_DISTANCE


func set_path(start_point, end_point):
	path = tilemap.find_path(start_point, end_point)
	next_point = path[1]
	state = State.TRAVEL
