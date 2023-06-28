extends Node2D

var poin = 0
var can_place = false
var mousepos = Vector2i()
@onready var tilemap = $TileMap


# preload scenes
var siswa_res = preload("res://scenes/siswa.tscn")
var asrama_res = preload("res://scenes/asrama.tscn")
var kampus_res = preload("res://scenes/kampus.tscn")

# variasi warna asrama dan kampus
var list_asrama = Array()
var list_asrama_blue = Array()
var list_asrama_green = Array()
var list_asrama_red = Array()
var list_kampus = Array()
var list_kampus_blue = Array()
var list_kampus_green = Array()
var list_kampus_red = Array()
enum { BLUE, GREEN, RED }

# penempatan acak asrama & kampus
var cur_color_asrama = BLUE
var cur_color_kampus = BLUE
var random_color_asrama = false
var random_color_kampus = false
var random_place_asrama = false
var random_place_kampus = false
var asrama_to_be_placed = 0
var kampus_to_be_placed = 0
var min_rect = Vector2(0,0)
var max_rect = Vector2(1000,1000)

var rng = RandomNumberGenerator.new()

signal camera_shake

func _ready():
	rng.randomize()
	
	# create first asrama & kampus
	tilemap.is_asrama_buildable(Vector2(0,0))
	var new_asrama = asrama_res.instantiate()
	add_child(new_asrama)
	new_asrama.global_position = tilemap.map_to_local(tilemap.local_to_map(Vector2(0,0)))
	new_asrama.init(tilemap.place_asrama())
	new_asrama.set_blue()
	list_asrama_blue.append(new_asrama)
	
	tilemap.is_kampus_buildable(Vector2(400,200))
	var new_kampus = kampus_res.instantiate()
	add_child(new_kampus)
	new_kampus.global_position = tilemap.map_to_local(tilemap.local_to_map(Vector2(400,200)))
	new_kampus.init(tilemap.place_kampus(), list_asrama_blue.duplicate())
	new_kampus.set_blue()
	new_kampus.send_request_siswa.connect(_on_request_siswa)
	new_kampus.gameover.connect(shake)
	list_kampus_blue.append(new_kampus)
	
	can_place = true
	pass


func _process(delta):
	mousepos = get_local_mouse_position()
	if can_place:
		if Input.is_action_pressed("mb_left"):
			tilemap.place_road(mousepos)
		elif Input.is_action_pressed("mb_right"):
			tilemap.remove_road(mousepos)


	# penempatan random asrama & kampus
	if asrama_to_be_placed > 0:
		# tentukan warna asrama
		var color = BLUE
		if list_asrama_blue.size() >= 4:
			var colors = [BLUE, GREEN, RED]
			colors.shuffle()
			color = colors.front()
		
		# tentukan posisi asrama secara acak
		var pos = Vector2(rng.randi_range(min_rect.x,max_rect.x), rng.randi_range(min_rect.y,max_rect.y))
		
		# letakkan tile asrama dan dapatkan posisi gerbang
		if tilemap.is_asrama_buildable(pos):
			var new_asrama = asrama_res.instantiate()
			add_child(new_asrama)
			new_asrama.global_position = tilemap.map_to_local(tilemap.local_to_map(pos))
			new_asrama.init(tilemap.place_asrama())
			match color:
				BLUE:
					new_asrama.set_blue()
					list_asrama_blue.append(new_asrama)
					if not list_kampus_blue.is_empty():
						for kampus in list_kampus_blue:
							kampus.add_asrama(new_asrama)
				GREEN:
					new_asrama.set_green()
					list_asrama_green.append(new_asrama)
					if not list_kampus_green.is_empty():
						for kampus in list_kampus_green:
							kampus.add_asrama(new_asrama)
				RED:
					new_asrama.set_red()
					list_asrama_red.append(new_asrama)
					if not list_kampus_red.is_empty():
						for kampus in list_kampus_red:
							kampus.add_asrama(new_asrama)
			asrama_to_be_placed -= 1
			
					
	if kampus_to_be_placed > 0:
		# tentukan warna kampus
		var color = BLUE
		if list_asrama_blue.size() >= 4:
			var colors = [BLUE, GREEN, RED]
			if list_asrama_blue.is_empty() or list_asrama_blue.size() < list_kampus_blue.size() * 2:
				colors.erase(BLUE)
			if list_asrama_green.is_empty() or list_asrama_green.size() < list_kampus_green.size() * 2:
				colors.erase(GREEN)
			if list_asrama_red.is_empty() or list_asrama_red.size() < list_kampus_red.size() * 2:
				colors.erase(RED)
			if colors.is_empty():
				color = -1
			else:
				colors.shuffle()
				color = colors.front()
		print(color)
		# tentukan posisi kampus secara acak
		var pos = Vector2(rng.randi_range(min_rect.x,max_rect.x), rng.randi_range(min_rect.y,max_rect.y))
		
		# letakkan tile kampus dan dapatkan posisi gerbang
		if tilemap.is_kampus_buildable(pos) and color != -1:
			var new_kampus = kampus_res.instantiate()
			add_child(new_kampus)
			new_kampus.global_position = tilemap.map_to_local(tilemap.local_to_map(pos))
			match color:
				BLUE:
					new_kampus.init(tilemap.place_kampus(), list_asrama_blue.duplicate())
					new_kampus.set_blue()
					list_kampus_blue.append(new_kampus)
				GREEN:
					new_kampus.init(tilemap.place_kampus(), list_asrama_green.duplicate())
					new_kampus.set_green()
					list_kampus_green.append(new_kampus)
				RED:
					new_kampus.init(tilemap.place_kampus(), list_asrama_red.duplicate())
					new_kampus.set_red()
					list_kampus_red.append(new_kampus)
			new_kampus.send_request_siswa.connect(_on_request_siswa)
			new_kampus.gameover.connect(shake)
			kampus_to_be_placed -= 1


# Kirim siswa
func _on_request_siswa(asrama_asal, kampus_tujuan, warna, path):
	var new_siswa = siswa_res.instantiate()
	new_siswa.position = tilemap.map_to_local(asrama_asal.posisi_gerbang)
	add_child(new_siswa)
	match warna:
		BLUE:
			new_siswa.set_blue()
		GREEN:
			new_siswa.set_green()
		RED:
			new_siswa.set_red()
	new_siswa.sampai_asrama.connect(add_poin)
	new_siswa.kecelakaan.connect(shake)
	new_siswa.set_path(asrama_asal, kampus_tujuan, path)
	new_siswa.berangkat()


# Kirim sinyal camera_shake apabila terjadi tubrukan siswa
func shake():
	camera_shake.emit()
	

func add_poin():
	poin += 1
	min_rect += Vector2(5,5)
	max_rect += Vector2(20,20)
	if poin < 20:
		if poin % 3 == 0:
			asrama_to_be_placed += 1
		if poin % 5 == 0:
			kampus_to_be_placed += 1
	elif poin < 100:
		if poin % 5 == 0:
			asrama_to_be_placed += 1
		if poin % 10 == 0:
			kampus_to_be_placed += 1
