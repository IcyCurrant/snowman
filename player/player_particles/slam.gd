extends Sprite2D

@onready var fade_timer = $fade

func _ready() -> void:
	fade_timer.start()

func _on_fade_timeout() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("enemy"):
				body.damage()
