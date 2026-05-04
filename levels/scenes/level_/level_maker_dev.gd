extends Node2D

@onready var base_level := $"base level"
@onready var foreground := $foreground

func _ready() -> void:
	print(base_level.get_used_cells())

func _process(delta: float) -> void:
	pass
