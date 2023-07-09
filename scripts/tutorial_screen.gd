extends Control


@onready var dialogbox = $"dialog-box"
@onready var dialogtext = $"dialog-text"
@onready var dialognextbtn = $"dialog-nextbtn/btn-text"
@onready var dialognextbtn_anim = $"dialog-nextbtn/btn-anim"
@onready var dialogtimer = $"dialog-timer"
@onready var anim = $AnimationPlayer


var texts = [
	"Hai, selamat datang di [color=green]Cloudia![/color]",
	"Sebelum mulai, akan aku ceritakan sedikit mengenai kota ini, ya.",
	"Kota [color=green]Cloudia[/color] ini adalah sebuah kota pendidikan baru dan masih bersifat eksperimental yang berlokasi di atas awan.",
	"Kota ini kami bangun di atas awan karena pada akhir-akhir ini, negara kami mulai kehabisan lahan untuk melakukan pembangunan di bumi.",
	"Nantinya, kota ini akan kami isi dengan berbagai macam kampus. Kami juga akan adakan asrama sebagai tempat tinggal para siswa.",
	"Nah, kami mengundangmu ke sini sebagai arsitektur jalan kota.",
	"Tugasmu adalah membangun jalan untuk menghubungkan asrama siswa dan kampus mereka dengan jalur yang efisien.",
	"Sewaktu-waktu, kami akan mengirim asrama dan kampus baru dari bumi ke atas sini.",
	"Untuk melakukan konstruksi jalan, akan ada dua tombol aksi di bagian bawah layar.",
	"[color=green]Tombol sebelah kiri[/color] berfungsi untuk masuk ke mode penempatan jalan. Setelah menekan tombol itu, kamu dapat [color=green]klik kiri[/color] di area kosong untuk menempatkan sebuah jalan.",
	"[color=green]Tombol sebelah kanan[/color] berfungsi untuk masuk ke mode menghapus jalan. Klik tombol ini, kemudian [color=green]klik kiri[/color] pada jalan yang sudah kamu tempatkan untuk menghapusnya.",
	"Gunakan [color=green]klik kanan[/color] dan [color=green]mouse wheel[/color] untuk mengatur kamera.",
	"Yang terakhir, apabila ada siswa yang kecelakaan, ia akan memerlukan waktu 5 detik sebelum dapat kembali ke asrama.",
	"Eksperimen ini akan berakhir apabila kamu gagal memenuhi permintaan kehadiran siswa suatu kampus dalam batasan waktu tertentu.",
	"Baiklah. Semoga beruntung, ya!"
]

var tutorial_pic1 = preload("res://assets/ui/tutorial-pic1.png")
var tutorial_pic2 = preload("res://assets/ui/tutorial-pic2.png")
@onready var tutorial_pic = $"tutorial-pic"

var dialog_index = 0
var dialog_done = false

signal tutorial_done


# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("fadein")
	dialognextbtn_anim.play("idle")
	
	
func clear():
	dialog_done = false
	tutorial_pic.visible = false
	dialogtext.text = ""
	dialogtext.visible_characters = 0
	dialognextbtn.visible = false
	

func display():
	clear()
	if dialog_index == 9:
		tutorial_pic.set_texture(tutorial_pic1)
		tutorial_pic.visible = true
	elif dialog_index == 10:
		tutorial_pic.set_texture(tutorial_pic2)
		tutorial_pic.visible = true
	dialogtext.text = texts[dialog_index]
	dialogtimer.start()
	dialog_index += 1


func _on_dialogtimer_timeout():
	dialogtext.visible_characters += 1
	if dialogtext.visible_ratio == 1: #dialog done
		dialogtimer.stop()
		dialognextbtn_anim.play("idle")
		dialognextbtn.visible = true
		dialog_done = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dialog_done and Input.is_action_just_pressed("mb_left"):
		if dialog_index == texts.size():
			clear()
			dialogbox.visible = false
			await get_tree().create_timer(1.0).timeout
			tutorial_done.emit()
			return
		display()


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fadein":
			display()
