extends Marker2D


enum State { IDLE, BERANGKAT, PULANG }

const MASS = 10.0
const ARRIVAL_DISTANCE = 20.0

var speed = 100.0
var state = State.IDLE
var velocity = Vector2()

@onready var tilemap = get_node("../TileMap")

var path = PackedVector2Array()
var path_berangkat = PackedVector2Array()
var path_pulang = PackedVector2Array()
var next_point = Vector2()
var asrama_asal = null
var kampus_tujuan = null

signal sampai_kampus
signal sampai_asrama
signal kecelakaan

@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var timer = $Timer
@onready var front_detector = $front_detector
@onready var collision = $collision_preventor

var blue_variant = preload("res://assets/siswa/siswa-blue.png")
var green_variant = preload("res://assets/siswa/siswa-green.png")
var red_variant = preload("res://assets/siswa/siswa-red.png")

var first_spawn = true
var first_point = false

# Called when the node enters the scene tree for the first time.
func _ready():
	state = State.IDLE
	sprite.set_modulate(Color(255,255,255,0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state  == State.IDLE:
		return
	if state == State.BERANGKAT and first_spawn:
		next_point = asrama_asal.posisi_gerbang_global
	var arrived_to_next_point = move_to(next_point)
	if arrived_to_next_point:
		if first_spawn:
			next_point = path[0]
			first_point = true
			first_spawn = false
		elif first_point:
			if path.size() == 1:
				if state == State.BERANGKAT:
					# berhasil berangkat sampai kampus
					anim.play("sampai_kampus")
				else:
					# berhasil pulang sampai asrama
					anim.play("sampai_asrama")
				state = State.IDLE
				return
			next_point = path[1]
			first_point = false
		else:
			path.remove_at(0)
			if path.size() == 1:
				if state == State.BERANGKAT:
					# berhasil berangkat sampai kampus
					anim.play("sampai_kampus")
				else:
					# berhasil pulang sampai asrama
					anim.play("sampai_asrama")
				state = State.IDLE
				return
			next_point = path[1]
	
	
func set_blue():
	sprite.set_texture(blue_variant)
	
func set_green():
	sprite.set_texture(green_variant)
	
func set_red():
	sprite.set_texture(red_variant)


func move_to(local_position):
	var desired_velocity = (local_position - position).normalized() * speed
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()
	rotation = velocity.angle()
	return position.distance_to(local_position) < ARRIVAL_DISTANCE


func set_path(asrama_asal, kampus_tujuan, path):
	self.asrama_asal = asrama_asal
	self.kampus_tujuan = kampus_tujuan
	path_berangkat = path.duplicate()
	path_pulang = path.duplicate()
	path_pulang.reverse()


func berangkat():
	path = path_berangkat
	state = State.BERANGKAT
	anim.play("berangkat")


func pulang():
	path = path_pulang
	first_point = true
	state = State.PULANG
	anim.play("pulang")
	

func send_signal_kampus():
	kampus_tujuan.pop_request()
	sampai_kampus.emit()
	timer.start()
	
	
func send_signal_asrama():
	asrama_asal.siswa_count += 1
	sampai_asrama.emit()
	destroy()
	

func destroy():
	Lists.siswa.erase(self)
	state = State.IDLE
	queue_free()


func _on_timer_timeout():
	pulang()


# melambat apabila mendeteksi siswa lain di depan
func _on_front_detector_area_entered(area):
	if area == collision:
		return
	speed = 5


# kembali ke kecepatan normal apabila tidak mendeteksi halangan di depan
func _on_front_detector_area_exited(area):
	if area == collision:
		return
	speed = 75


# destroy apabila bertubrukan
func _on_collision_detector_area_entered(area):
	anim.play("destroy")
	kecelakaan.emit()
	asrama_asal.respawn_siswa()
	kampus_tujuan.siswa_count -= 1
