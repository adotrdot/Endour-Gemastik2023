extends Control


@onready var anim = $AnimationPlayer
@onready var siswa1_sprite = $"siswa1/siswa-sprite"
@onready var siswa1_anim = $"siswa1/siswa-anim"
@onready var siswa2_sprite = $"siswa2/siswa2-sprite"
@onready var siswa2_anim = $"siswa2/siswa2-anim"
@onready var judul_text = $"judul/judul-text"
@onready var judul_anim = $"judul/judul-anim"
@onready var btn_text = $"btn/btn-text"
@onready var btn_anim = $"btn/btn-anim"

var clickable = false

signal start


# Called when the node enters the scene tree for the first time.
func _ready():
	siswa1_sprite.modulate = Color(255,255,255,0)
	siswa2_sprite.modulate = Color(255,255,255,0)
	judul_text.modulate = Color(255,255,255,0)
	btn_text.modulate = Color(255,255,255,0)
	anim.play("fadein")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clickable and Input.is_action_just_pressed("mb_left"):
		anim.play("fadeout")
		clickable = false


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"fadein":
			siswa1_anim.play("fadein")
			siswa2_anim.play("fadein")
			judul_anim.play("fadein")
		"fadeout":
			start.emit()


func _on_siswaanim_animation_finished(anim_name):
	siswa1_anim.play("idle")


func _on_siswa_2_anim_animation_finished(anim_name):
	siswa2_anim.play("idle")


func _on_judulanim_animation_finished(anim_name):
	btn_anim.play("idle")
	clickable = true
