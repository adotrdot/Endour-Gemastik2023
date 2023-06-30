extends Bangunan


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
	for pin in pins:
		pin.visible = false

func _process(delta):
	pass


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
	pins[list_requests.size()-1].visible = true
	

func _on_request_timeout():
	gameover.emit()


func pop_request():
	siswa_count -= 1
	pins[list_requests.size()-1].visible = false
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
