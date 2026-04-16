extends CharacterBody2D

var dir
var speed := 3000

func _ready() -> void:
	add_to_group("player_rpg")

func _process(delta: float) -> void:
	dir = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity = dir * speed * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("player_rpg"):
			get_tree().call_deferred("change_scene_to_file","res://main_/main_game.tscn")
