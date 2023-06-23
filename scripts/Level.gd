extends Node2D

var can_place = true
var mousepos = Vector2i()
@onready var tilemap = $TileMap
@onready var timer_asrama = $TimerAsrama
@onready var timer_kampus = $TimerKampus



#var _test_student = true
var siswa_res = preload("res://scenes/siswa.tscn")
var asrama_res = preload("res://scenes/asrama.tscn")
var kampus_res = preload("res://scenes/kampus.tscn")
var list_asrama = Array()
var list_kampus = Array()

var rng = RandomNumberGenerator.new()

signal camera_shake

func _ready():
	rng.randomize()
	timer_asrama.start()
	timer_kampus.start()
	pass


func _process(delta):
#	if _test_student:
#		if Input.is_action_just_pressed("test_summon_student"):
#			var _student = _test_student_res.instantiate()
#			var start_point = list_asrama[rng.randi_range(0, list_asrama.size()-1)].get_posisi_gerbang()
#			var end_point = list_kampus[rng.randi_range(0, list_kampus.size()-1)].get_posisi_gerbang()
#			_student.position = tilemap.map_to_local(start_point)
#			add_child(_student)
#			_student.berangkat(start_point, end_point)
#			_student.kecelakaan.connect(shake)
	
	mousepos = get_local_mouse_position()
	if can_place:
		if Input.is_action_pressed("mb_left"):
			print(mousepos)
			tilemap.place_road(mousepos)
		elif Input.is_action_pressed("mb_right"):
			tilemap.remove_road(mousepos)


# Kirim sinyal camera_shake apabila terjadi tubrukan siswa
func shake():
	camera_shake.emit()


# Menempatkan asrama baru setiap durasi waktu tertentu
func _on_timer_asrama_timeout():
	# tentukan posisi asrama secara acak
	var pos = Vector2(rng.randi_range(0,1000), rng.randi_range(0,1000))
	
	# letakkan tile asrama dan dapatkan posisi gerbang
	if tilemap.is_asrama_buildable(pos):
		var new_asrama = asrama_res.instantiate()
		add_child(new_asrama)
		new_asrama.global_position = tilemap.map_to_local(tilemap.local_to_map(pos))
		new_asrama.init(tilemap.place_asrama())
		list_asrama.append(new_asrama)
		if not list_kampus.is_empty():
			for kampus in list_kampus:
				kampus.add_asrama(new_asrama)
	
	# batasi asrama sejumlah 4
	if list_asrama.size() == 4:
		timer_asrama.stop()


# Menempatkan kampus baru setiap durasi waktu tertentu
func _on_timer_kampus_timeout():
	# tentukan posisi kampus secara acak
	var pos = Vector2(rng.randi_range(0,1000), rng.randi_range(0,1000))
	
	# letakkan tile kampus dan dapatkan posisi gerbang
	if tilemap.is_kampus_buildable(pos):
		var new_kampus = kampus_res.instantiate()
		add_child(new_kampus)
		new_kampus.global_position = tilemap.map_to_local(tilemap.local_to_map(pos))
		new_kampus.init(tilemap.place_kampus(), list_asrama.duplicate())
		new_kampus.send_request_siswa.connect(_on_request_siswa)
		new_kampus.request_fail.connect(shake)
		list_kampus.append(new_kampus)
	
	# batasi kampus sejumlah 2
	if list_kampus.size() == 2:
		timer_kampus.stop()


# Kirim siswa
func _on_request_siswa(asrama_asal, kampus_tujuan, path):
	var new_siswa = siswa_res.instantiate()
	new_siswa.position = tilemap.map_to_local(asrama_asal.posisi_gerbang)
	add_child(new_siswa)
	new_siswa.kecelakaan.connect(shake)
	new_siswa.set_path(asrama_asal, kampus_tujuan, path)
	new_siswa.berangkat()
