extends Sprite2D

@onready var fade_timer = $fade

func _ready() -> void:
	fade_timer.start()

func _on_fade_timeout() -> void:
	queue_free()
