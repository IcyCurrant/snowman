extends CharacterBody2D

var velocity_vec :Vector2

signal damage_enemy

func _ready() -> void:
	#print(self.get_path())
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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body:
		#print(body.name)
		
			#print("YES I AM!")
		if not body.is_in_group("player"):
			#if body.is_in_group("enemy"):
				#print(body.get_parent()) #.damage()
			#await get_tree().create_timer(0.02,true).timeout
			#damage_enemy.emit()
			
			if body.is_in_group("enemy"):
				body.damage()
				
			queue_free()
