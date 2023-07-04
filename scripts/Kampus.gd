extends Bangunan


@onready var visibility_notifier = $VisibleOnScreenNotifier2D
@onready var cam = get_node("../../cam_container/Camera2D")
@onready var tilemap = get_node("../TileMap")
var path = PackedVector2Array()

var blue_variant = preload("res://assets/kampus/kampus-blue.png")
var green_variant = preload("res://assets/kampus/kampus-green.png")
var red_variant = preload("res://assets/kampus/kampus-red.png")
@onready var sprite = $Sprite2D

var pin_blue = preload("res://assets/pin/pin-blue.png")
var pin_green = preload("res://assets/pin/pin-green.png")
var pin_red = preload("res://assets/pin/pin-red.png")
@onready var pin1 = $pin1
@onready var pin2 = $pin2
@onready var pin3 = $pin3
@onready var pin4 = $pin4
@onready var pin5 = $pin5
@onready var pins = [pin1,pin2,pin3,pin4,pin5]
var out_pin_pos = Vector2()
var out_pin_res = preload("res://scenes/kampus_out_pin.tscn")
var out_pin = null

var asrama_terkait = Array()
var list_requests = Array()
@onready var req_res = preload("res://scenes/student_request.tscn")
@onready var req_limit_res = preload("res://scenes/student_request_limit.tscn")
var req_limit = 5
var req_timer = Timer.new()
var siswa_timer = Timer.new()
signal gameover
signal send_request_siswa(asrama_asal, kampus_tujuan, warna, path)

enum { BLUE, GREEN, RED }
var color = BLUE

func _ready():
	pass

func _process(delta):
	if not visibility_notifier.is_on_screen():
		if out_pin == null:
			out_pin = out_pin_res.instantiate()
			add_child(out_pin)
			match color:
				BLUE:
					out_pin.sprite.set_texture(pin_blue)
				GREEN:
					out_pin.sprite.set_texture(pin_green)
				RED:
					out_pin.sprite.set_texture(pin_red)
		var cam_center = cam.get_screen_center_position()
		cam_center.y *= -1
		var screen_size = cam.get_viewport_rect().size / cam.get_canvas_transform().get_scale()
		var left_edge = screen_size.x / 2 * -1
		var right_edge = screen_size.x / 2
		var top_edge = screen_size.y / 2
		var bottom_edge = screen_size.y / 2 * -1
		var pos = Vector2(global_position.x - cam_center.x, global_position.y * -1 - cam_center.y)
		if pos.x == 0 or pos.y == 0:
			return
		var m = pos.y / pos.x
		out_pin.sprite.rotation_degrees = 0
		if pos.y > 0: # berada di atas layar
			out_pin_pos.y = top_edge
			out_pin_pos.x = out_pin_pos.y / m
			out_pin.sprite.offset = Vector2(0,25)
			out_pin.sprite.flip_h = false
			out_pin.sprite.flip_v = true
			if m > 0 and out_pin_pos.x > right_edge:
				out_pin.sprite.rotation_degrees = -90
				out_pin.sprite.offset = Vector2(0,25)
				out_pin.sprite.flip_v = false
				out_pin_pos.x = right_edge
				out_pin_pos.y = m * out_pin_pos.x
			elif m < 0 and out_pin_pos.x < left_edge:
				out_pin.sprite.rotation_degrees = 90
				out_pin.sprite.offset = Vector2(0,-25)
				out_pin.sprite.flip_v = false
				out_pin_pos.x = left_edge
				out_pin_pos.y = m * out_pin_pos.x
		else: # berada di bawah layar
			out_pin_pos.y = bottom_edge
			out_pin_pos.x = out_pin_pos.y / m
			out_pin.sprite.offset = Vector2(0,-25)
			out_pin.sprite.flip_h = false
			out_pin.sprite.flip_v = false
			if m > 0 and out_pin_pos.x < left_edge:
				out_pin.sprite.rotation_degrees = 90
				out_pin.sprite.offset = Vector2(0,-25)
				out_pin.sprite.flip_v = false
				out_pin_pos.x = left_edge
				out_pin_pos.y = m * out_pin_pos.x
			elif m < 0 and out_pin_pos.x > right_edge:
				out_pin.sprite.rotation_degrees = -90
				out_pin.sprite.offset = Vector2(0,25)
				out_pin.sprite.flip_v = false
				out_pin_pos.x = right_edge
				out_pin_pos.y = m * out_pin_pos.x
		out_pin_pos += cam_center
		out_pin_pos.y *= -1
		out_pin.global_position = out_pin_pos
	else:
		if out_pin != null:
			out_pin.queue_free()


func init(pos : Vector2, list_asrama : Array):
	siswa_count = 0
	posisi_gerbang = pos
	if not list_asrama.is_empty():
		asrama_terkait = list_asrama
		asrama_terkait.sort_custom(sort_asrama_terdekat)
	add_child(req_timer)
	req_timer.timeout.connect(add_request)
	req_timer.start(10)
	add_child(siswa_timer)
	siswa_timer.timeout.connect(request_siswa)
	siswa_timer.start(1.5)
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_BOUNCE)
	

func set_blue():
	sprite.set_texture(blue_variant)
	for pin in pins:
		pin.set_texture(pin_blue)
	color = BLUE
	
func set_green():
	sprite.set_texture(green_variant)
	for pin in pins:
		pin.set_texture(pin_green)
	color = GREEN
	
func set_red():
	sprite.set_texture(red_variant)
	for pin in pins:
		pin.set_texture(pin_red)
	color = RED
	
	
func sort_asrama_terdekat(a, b):
	if posisi_gerbang.distance_squared_to(a.posisi_gerbang) < posisi_gerbang.distance_squared_to(b.posisi_gerbang):
		return true
	return false

func add_asrama(new_asrama):
	var asrama_count = asrama_terkait.size()
	if asrama_count == 0:
		asrama_terkait.append(new_asrama)
		return
	if posisi_gerbang.distance_squared_to(new_asrama.posisi_gerbang) > posisi_gerbang.distance_squared_to(asrama_terkait.back().posisi_gerbang):
		asrama_terkait.append(new_asrama)
		return
	for i in range(asrama_count):
		if posisi_gerbang.distance_squared_to(new_asrama.posisi_gerbang) < posisi_gerbang.distance_squared_to(asrama_terkait[i].posisi_gerbang):
			asrama_terkait.insert(i, new_asrama)
		
func add_request():
	if list_requests.size() == req_limit:
		return
	var new_request = req_res.instantiate()
	add_child(new_request)
	list_requests.append(new_request)
	var tween = get_tree().create_tween()
	tween.tween_property(pins[list_requests.size()-1], "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_BOUNCE)
	

func _on_request_timeout():
	gameover.emit()


func pop_request():
	siswa_count -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(pins[list_requests.size()-1], "scale", Vector2(1,0), 0.5).set_trans(Tween.TRANS_BOUNCE)
	var request = list_requests.pop_front()
	if request != null:
		request.queue_free()


func request_siswa():
	if siswa_count >= list_requests.size():
		return
	path.clear()
	var asrama_terdekat = null
	for asrama in asrama_terkait:
		if asrama.siswa_count > 0:
			path = tilemap.find_path(asrama.posisi_gerbang, posisi_gerbang)
			if not path.is_empty():
				asrama_terdekat = asrama
				break
	if asrama_terdekat != null:
		asrama_terdekat.siswa_count -= 1
		siswa_count += 1
		send_request_siswa.emit(asrama_terdekat, self, color, path)
