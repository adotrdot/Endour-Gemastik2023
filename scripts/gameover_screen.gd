extends CanvasLayer

@onready var btn_anim = $"btn/btn-anim"
var clickable = false

signal retry

# Called when the node enters the scene tree for the first time.
func _ready():
	btn_anim.play("idle")
	await get_tree().create_timer(2.0).timeout
	clickable = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if clickable and Input.is_action_just_pressed("mb_left"):
		retry.emit()
