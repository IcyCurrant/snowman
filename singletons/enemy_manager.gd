extends Node2D

#node reference
@onready var freq := $frequency #spawn frequesncy timer

#instance to enemy_scene
@onready var enemy_scene := preload("res://enemies/enemy.tscn")
@onready var enemy

#general variables
var enemy_type_ : int = 0


func _ready() -> void:
	freq.wait_time = 1.2

func _on_frequency_timeout() -> void:
	enemy_type_ = randi_range(0,1)
	enemy = enemy_scene.instantiate()
	enemy.num = enemy_type_
	enemy.global_position = global_position
	get_tree().root.add_child(enemy)
