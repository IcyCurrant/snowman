extends CharacterBody2D

var velocity_vec :Vector2
var player_pos := PlayerData.pos

func _ready() -> void:
	velocity_vec = (player_pos - global_position) * 4

func _physics_process(delta):
	# Apply Gravity
	velocity_vec.y += get_gravity().y * delta
	# Move and check collisions
	velocity = velocity_vec
	
	move_and_slide()
	
	if global_position.y > 100:
		queue_free()
