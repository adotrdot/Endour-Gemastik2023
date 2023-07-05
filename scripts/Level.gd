extends Node2D

var poin = 0
var can_place = false
var can_remove = false
var mousepos = Vector2i()
@onready var tilemap = $TileMap
@onready var controls = get_node("../GameplayControl")


# preload scenes
var siswa_res = preload("res://scenes/siswa.tscn")
var asrama_res = preload("res://scenes/asrama.tscn")
var kampus_res = preload("res://scenes/kampus.tscn")
var jalan_res = preload("res://scenes/jalan.tscn")


# variasi warna asrama dan kampus
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
var min_rect = Vector2(240,240)
var max_rect = Vector2(1000,1000)

var rng = RandomNumberGenerator.new()

signal camera_shake

func _ready():
	rng.randomize()
	
	# prepare lists
	Lists.siswa.clear()
	Lists.asrama_blue.clear()
	Lists.asrama_green.clear()
	Lists.asrama_red.clear()
	Lists.kampus_blue.clear()
	Lists.kampus_green.clear()
	Lists.kampus_red.clear()
	
	# create first asrama & kampus
	tilemap.is_asrama_buildable(Vector2(500,500))
	var new_asrama = asrama_res.instantiate()
	add_child(new_asrama)
	new_asrama.init(tilemap.place_asrama(new_asrama, rng.randi_range(0, 3)))
	new_asrama.set_blue()
	var new_jalan = jalan_res.instantiate()
	add_child(new_jalan)
	new_jalan.deleteable = false
	tilemap.road_coord = new_asrama.posisi_gerbang
	tilemap.place_road(new_jalan)
	Lists.asrama_blue.append(new_asrama)
	
	tilemap.is_kampus_buildable(Vector2(700,300))
	var new_kampus = kampus_res.instantiate()
	add_child(new_kampus)
	new_kampus.init(tilemap.place_kampus(new_kampus), Lists.asrama_blue.duplicate())
	new_kampus.set_blue()
	new_jalan = jalan_res.instantiate()
	add_child(new_jalan)
	new_jalan.deleteable = false
	tilemap.road_coord = new_kampus.posisi_gerbang
	tilemap.place_road(new_jalan)
	new_kampus.send_request_siswa.connect(_on_request_siswa)
	new_kampus.gameover.connect(_on_gameover)
	Lists.kampus_blue.append(new_kampus)
	
	pass


func _process(delta):
	mousepos = get_local_mouse_position()
	if can_place and controls.is_any_button_hovered() == false and Input.is_action_pressed("mb_left") and tilemap.is_road_buildable(mousepos):
		var new_jalan = jalan_res.instantiate()
		add_child(new_jalan)
		tilemap.place_road(new_jalan)
	elif can_remove and controls.is_any_button_hovered() == false and Input.is_action_pressed("mb_left"):
		tilemap.remove_road(mousepos)


	# penempatan random asrama & kampus
	if asrama_to_be_placed > 0:
		# tentukan warna asrama
		var color = BLUE
		if Lists.asrama_blue.size() >= 2:
			var colors = [BLUE, GREEN, RED]
			colors.shuffle()
			color = colors.front()
		
		# tentukan posisi asrama secara acak
		var pos = Vector2(rng.randi_range(min_rect.x,max_rect.x), rng.randi_range(min_rect.y,max_rect.y))
		
		# letakkan tile asrama dan dapatkan posisi gerbang
		if tilemap.is_asrama_buildable(pos):
			var new_asrama = asrama_res.instantiate()
			add_child(new_asrama)
			new_asrama.init(tilemap.place_asrama(new_asrama, rng.randi_range(0, 3)))
			match color:
				BLUE:
					new_asrama.set_blue()
					Lists.asrama_blue.append(new_asrama)
					if not Lists.kampus_blue.is_empty():
						for kampus in Lists.kampus_blue:
							kampus.add_asrama(new_asrama)
				GREEN:
					new_asrama.set_green()
					Lists.asrama_green.append(new_asrama)
					if not Lists.kampus_green.is_empty():
						for kampus in Lists.kampus_green:
							kampus.add_asrama(new_asrama)
				RED:
					new_asrama.set_red()
					Lists.asrama_red.append(new_asrama)
					if not Lists.kampus_red.is_empty():
						for kampus in Lists.kampus_red:
							kampus.add_asrama(new_asrama)
			var new_jalan = jalan_res.instantiate()
			add_child(new_jalan)
			new_jalan.deleteable = false
			tilemap.road_coord = new_asrama.posisi_gerbang
			tilemap.place_road(new_jalan)
			asrama_to_be_placed -= 1
			
					
	if kampus_to_be_placed > 0:
		# tentukan warna kampus
		var color = BLUE
		if Lists.asrama_blue.size() >= 2:
			var colors = [BLUE, GREEN, RED]
			if Lists.asrama_blue.is_empty() or Lists.asrama_blue.size() < Lists.kampus_blue.size() * 2:
				colors.erase(BLUE)
			if Lists.asrama_green.is_empty() or Lists.asrama_green.size() < Lists.kampus_green.size() * 2:
				colors.erase(GREEN)
			if Lists.asrama_red.is_empty() or Lists.asrama_red.size() < Lists.kampus_red.size() * 2:
				colors.erase(RED)
			if colors.is_empty():
				color = -1
			else:
				colors.shuffle()
				color = colors.front()
		# tentukan posisi kampus secara acak
		var pos = Vector2(rng.randi_range(min_rect.x,max_rect.x), rng.randi_range(min_rect.y,max_rect.y))
		
		# letakkan tile kampus dan dapatkan posisi gerbang
		if tilemap.is_kampus_buildable(pos) and color != -1:
			var new_kampus = kampus_res.instantiate()
			add_child(new_kampus)
			match color:
				BLUE:
					new_kampus.init(tilemap.place_kampus(new_kampus), Lists.asrama_blue.duplicate())
					new_kampus.set_blue()
					Lists.kampus_blue.append(new_kampus)
				GREEN:
					new_kampus.init(tilemap.place_kampus(new_kampus), Lists.asrama_green.duplicate())
					new_kampus.set_green()
					Lists.kampus_green.append(new_kampus)
				RED:
					new_kampus.init(tilemap.place_kampus(new_kampus), Lists.asrama_red.duplicate())
					new_kampus.set_red()
					Lists.kampus_red.append(new_kampus)
			var new_jalan = jalan_res.instantiate()
			add_child(new_jalan)
			new_jalan.deleteable = false
			tilemap.road_coord = new_kampus.posisi_gerbang
			tilemap.place_road(new_jalan)
			new_kampus.send_request_siswa.connect(_on_request_siswa)
			new_kampus.gameover.connect(_on_gameover)
			kampus_to_be_placed -= 1


# Kirim siswa
func _on_request_siswa(asrama_asal, kampus_tujuan, warna, path):
	var new_siswa = siswa_res.instantiate()
	Lists.siswa.append(new_siswa)
	new_siswa.position = tilemap.map_to_local(asrama_asal.spawn_point[asrama_asal.siswa_count])
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
	
	
# Game over
func _on_gameover():
	get_tree().quit()


# Sistem poin
func add_poin():
	poin += 1
	max_rect.x = max_rect.x + 20 if max_rect.x < 3950 else max_rect.x
	max_rect.y = max_rect.y + 20 if max_rect.y < 2135 else max_rect.y
	if poin < 20:
		if poin % 3 == 0:
			asrama_to_be_placed += 1
		if poin % 5 == 0:
			kampus_to_be_placed += 1
	elif poin < 100:
		if poin % 7 == 0:
			asrama_to_be_placed += 1
		if poin % 15 == 0:
			kampus_to_be_placed += 1


# UI
func _on_gameplay_control_place_road():
	can_place = true
	can_remove = false
	print("tes")

func _on_gameplay_control_remove_road():
	can_place = false
	can_remove = true
	print("tes2")
