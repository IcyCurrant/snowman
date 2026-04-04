extends CharacterBody2D

var velocity_vec :Vector2

func _ready() -> void:
	add_to_group("player_projectile")
	velocity_vec = (get_global_mouse_position() - global_position) * 4

func _physics_process(delta):
	# Apply Gravity
	velocity_vec.y += get_gravity().y * delta
	# Move and check collisions
	velocity = velocity_vec
	
	move_and_slide()
	
	if global_position.y > 100:
		queue_free()
