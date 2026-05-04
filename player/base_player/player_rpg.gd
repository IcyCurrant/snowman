extends CharacterBody2D

var dir
var speed := 3000
@onready var level_icons : Array[Sprite2D] = [
	$"../levels/level1_selection",
	$"../levels/level2_selection",
	$"../levels/level3_selection"
]

@onready var trail_scene := preload("res://player/player_particles/trail.tscn")
var trail
func _ready() -> void:
	global_position = PlayerData.rpg_pos
	print(self.get_path())
	#GameState.scene_change = false
	GameState.level = 0
	add_to_group("player_rpg")
	for completed_level in range(len(PlayerData.completed_levels)):
		if PlayerData.completed_levels[completed_level] == true:
			level_icons[completed_level].self_modulate =Color(0, 1, 1, 1)

func _process(delta: float) -> void:
	dir = Input.get_vector("left", "right", "up", "down").normalized()
	
	velocity = dir * speed * delta
	
	#_create_particles()
	
	move_and_slide()

func _on_l_2_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("player_rpg"):
			GameState.level = 2
			get_tree().call_deferred("change_scene_to_file","res://main_/main_game.tscn")


func _on_l_1_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("player_rpg"):
			GameState.level = 1
			get_tree().call_deferred("change_scene_to_file","res://main_/main_game.tscn")


func _on_l_3_body_entered(body: Node2D) -> void:
	if body:
		if body.is_in_group("player_rpg"):
			GameState.level = 3
			get_tree().call_deferred("change_scene_to_file","res://main_/main_game.tscn")

func _create_particles():
	trail = trail_scene.instantiate()
	trail.global_position = global_position 
	get_tree().root.add_child(trail)
