extends Node2D

var can_place = true
var mousepos = Vector2i()
@onready var tilemap = $TileMap

var _test_asrama = true
var _test_asrama_coord = Vector2(0,0)
var _test_kampus = true
var _test_kampus_coord = Vector2(800,800)
var _test_student = true
var _test_student_queue = Array()
var _test_start_point = PackedVector2Array()
var _test_end_point = PackedVector2Array()
var _test_student_res = preload("res://scenes/siswa.tscn")

func _ready():
	pass


func _process(delta):
	if _test_asrama:
		if Input.is_action_just_pressed("test_place_asrama"):
			# letakkan tile asrama dan dapatkan posisi gerbang
			_test_start_point.append(tilemap.place_asrama(Vector2(0,0)))
			_test_asrama = false
	if _test_kampus:
		if Input.is_action_just_pressed("test_place_kampus"):
			# letakkan tile kampus dan dapatkan posisi gerbang
			_test_end_point.append(tilemap.place_kampus(Vector2(800,800)))
			_test_kampus = false
	if _test_student:
		if Input.is_action_just_pressed("test_summon_student"):
			_test_student_queue.append(_test_student_res.instantiate())
			_test_student_queue.back().index = _test_student_queue.size()-1
			_test_student_queue.back().position = tilemap.map_to_local(_test_start_point[0])
			add_child(_test_student_queue.back())
			_test_student_queue.back().berangkat(_test_start_point[0], _test_end_point[0])
	
	mousepos = get_local_mouse_position()
	if can_place:
		if Input.is_action_pressed("mb_left"):
			tilemap.place_road(mousepos)
		elif Input.is_action_pressed("mb_right"):
			tilemap.remove_road(mousepos)
