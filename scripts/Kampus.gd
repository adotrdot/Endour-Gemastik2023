extends Bangunan


@onready var tilemap = get_node("../TileMap")
var path = PackedVector2Array()

var asrama_terkait = Array()
var list_requests = Array()
@onready var req_res = preload("res://scenes/student_request.tscn")
var req_limit = 2
var req_timer = Timer.new()
var siswa_timer = Timer.new()
signal request_fail
signal send_request_siswa(asrama_asal, kampus_tujuan, path)


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
	req_timer.start(3)
	add_child(siswa_timer)
	siswa_timer.timeout.connect(request_siswa)
	siswa_timer.start(0.5)
	
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
	var new_request = req_res.instantiate()
	add_child(new_request)
	new_request.request_timeout.connect(_on_request_timeout)
	list_requests.append(new_request)
	if list_requests.size() == req_limit:
		req_timer.stop()
	

func _on_request_timeout():
	request_fail.emit()
	pop_request()


func pop_request():
	var request = list_requests.pop_front()
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
		print(asrama_terdekat)
		siswa_count += 1
		send_request_siswa.emit(asrama_terdekat, self, path)
