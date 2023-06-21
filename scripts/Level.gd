extends Node2D

var can_place = true
var mousepos = Vector2i()
@onready var tilemap = $TileMap
@onready var timer_asrama = $TimerAsrama
@onready var timer_kampus = $TimerKampus

var _test_asrama = true
var _test_asrama_coord = Vector2(0,0)
var _test_kampus = true
var _test_kampus_coord = Vector2(800,800)
var _test_student = true
var _test_student_queue = Array()
var _test_start_point = PackedVector2Array()
var _test_end_point = PackedVector2Array()
var _test_student_res = preload("res://scenes/siswa.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	timer_asrama.start()
	timer_kampus.start()
	pass


func _process(delta):
	if _test_student:
		if Input.is_action_just_pressed("test_summon_student"):
			var _student = _test_student_res.instantiate()
			_test_student_queue.append(_student)
			var start_point = _test_start_point[rng.randi_range(0, _test_start_point.size()-1)]
			var end_point = _test_end_point[rng.randi_range(0, _test_end_point.size()-1)]
			_student.position = tilemap.map_to_local(start_point)
			add_child(_student)
			_test_student_queue.back().berangkat(start_point, end_point)
	
	mousepos = get_local_mouse_position()
	if can_place:
		if Input.is_action_pressed("mb_left"):
			tilemap.place_road(mousepos)
		elif Input.is_action_pressed("mb_right"):
			tilemap.remove_road(mousepos)


# Menempatkan asrama baru setiap durasi waktu tertentu
func _on_timer_asrama_timeout():
	# tentukan posisi asrama secara acak
	var pos = Vector2(rng.randi_range(0,800), rng.randi_range(0,800))
	
	# letakkan tile asrama dan dapatkan posisi gerbang
	if tilemap.is_asrama_buildable(pos):
		_test_start_point.append(tilemap.place_asrama())
	
	# batasi asrama sejumlah 4
	if _test_start_point.size() == 4:
		timer_asrama.stop()


# Menempatkan kampus baru setiap durasi waktu tertentu
func _on_timer_kampus_timeout():
	# tentukan posisi kampus secara acak
	var pos = Vector2(rng.randi_range(0,800), rng.randi_range(0,800))
	
	# letakkan tile kampus dan dapatkan posisi gerbang
	if tilemap.is_kampus_buildable(pos):
		_test_end_point.append(tilemap.place_kampus())
	
	# batasi kampus sejumlah 2
	if _test_end_point.size() == 2:
		timer_kampus.stop()
