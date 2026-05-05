extends Sprite2D

@onready var fade_timer = $fade
@onready var anim = $AnimationPlayer

var pos : float = 0
var n : float = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if n <= 4:
		position.y -= 1.5
		n += 0.25
	if n > 4:
		anim.play("fade_away")
		position.y += 1
		fade_timer.start()

func _on_fade_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("enemy"):
				body.damage()
