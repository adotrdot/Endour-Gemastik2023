extends CanvasLayer

@onready var btn_place_road = $"btn-place-road"
@onready var btn_place_road_anim = $"btn-place-road/AnimationPlayer"
var btn_place_road_pressed = false
var btn_place_road_hovered = false
@onready var btn_remove_road = $"btn-remove-road"
@onready var btn_remove_road_anim = $"btn-remove-road/AnimationPlayer"
var btn_remove_road_pressed = false
var btn_remove_road_hovered = false

@onready var score = $"score-label"

signal place_road
signal remove_road

# Called when the node enters the scene tree for the first time.
func _ready():
	score.text = "0"
	btn_place_road_anim.play("idle")
	btn_remove_road_anim.play("idle")


func is_any_button_hovered():
	return (btn_remove_road_hovered or btn_place_road_hovered)


func _on_btnplaceroad_mouse_entered():
	btn_place_road_hovered = true
	if btn_place_road.button_pressed:
		return
	btn_place_road_anim.play("hover")


func _on_btnplaceroad_mouse_exited():
	btn_place_road_hovered = false
	if btn_place_road.button_pressed:
		return
	btn_place_road_anim.play("unhover")


func _on_btnplaceroad_toggled(button_pressed):
	if button_pressed:
		if btn_place_road_pressed:
			return
		btn_place_road_anim.play("selected")
		place_road.emit()
		btn_place_road_pressed = true
	else:
		btn_place_road_anim.play("unselect")
		btn_place_road_pressed = false


func _on_btnremoveroad_mouse_entered():
	btn_remove_road_hovered = true
	if btn_remove_road.button_pressed:
		return
	btn_remove_road_anim.play("hover")


func _on_btnremoveroad_mouse_exited():
	btn_remove_road_hovered = false
	if btn_remove_road.button_pressed:
		return
	btn_remove_road_anim.play("unhover")


func _on_btnremoveroad_toggled(button_pressed):
	if button_pressed:
		if btn_remove_road_pressed:
			return
		btn_remove_road_anim.play("selected")
		remove_road.emit()
		btn_remove_road_pressed = true
	else:
		btn_remove_road_anim.play("unselect")
		btn_remove_road_pressed = false


func set_score(n):
	score.text = str(n)
