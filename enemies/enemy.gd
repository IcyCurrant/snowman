extends CharacterBody2D

#loading custom resource
@export var enemyType : EnemyTypes

# general variables
var speed : float # bruh...pretty self explanatory, I must suppose.
var enemy_hp : float # ... what do you even expect me to write about this?
var dir : float = randi_range(-1,1) # direction3
var num : int #enemy type number
var player_coll : bool = false

# oscillaton variables
var time : float = 0.0 # simple timer
var amplitude : float  # how high/low it goes
var frequency : float   # how fast
var start_y : float # og y position or in other words the base

#node references
@onready var left := $left_raycast # used to detect left wall collision
@onready var right := $right_raycast # used to detect right wall collision
@onready var firerate_timer := $firerate_timer # firerate...how fast the enemy fires projectiles 
@onready var player_detection := $player_detection # detect player
@onready var sprite := $AnimatedSprite2D # sprite

#bullet scene_reference
@onready var enemy_projectile_scene = preload("res://projectiles/enemy_projectile/enemy_projectile.tscn")
var enemy_projectile # instance of bullets

func _preload_enemy_types(type: int):
	match type: # initialise enemy types
		0: # land tank
			enemyType = preload("res://enemies/types/elf_land_.tres")
		1: # helicopter
			enemyType = preload("res://enemies/types/elf_copter.tres")

func _ready() -> void:
	#print(self.get_path())
	
	
	player_detection.rotation_degrees = 10.0 # set player detection raycat rotation to 10 degrees
	
	amplitude = randf_range(20.0, 30.0) # randomise amplitude
	frequency = randf_range(2.0,4.0) # randomise frequesncy of oscillation
	
	start_y = position.y # set base y postition to spawn position
	if dir == 0:
		dir = 1
	
	if dir == 1:
		player_detection.rotation_degrees = 10
	else:
		player_detection.rotation_degrees = 140
	_preload_enemy_types(num) # randomise enemy type based on its "id"
	
	enemyType = enemyType.duplicate(true) # set resource to unique (recursive)
	
	speed = enemyType.speed
	enemy_hp = enemyType.enemy_hp
	firerate_timer.wait_time = enemyType.firerate
	sprite.sprite_frames = enemyType.sprite_frames
	
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
	$Label.text = str(enemy_hp)
	time += delta * frequency
	
	sprite.play("default")
	
	if dir == -1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if left.is_colliding():
		dir = 1
	elif right.is_colliding():
		dir = -1
	
	if num == 0: #for land enemies
		
		if not is_on_floor(): #basic gravity
			velocity += get_gravity() * delta
			
		position.x += dir * speed * delta
		
	else: #for flying enemies
		#print($collArea.get_overlapping_bodies())
		 
		
			
		#sprite.offset.x = 8
		if dir == -1:
			if not player_coll:
				player_detection.rotation_degrees -= 1
				if (player_detection.rotation_degrees <= 110):
					player_detection.rotation_degrees = 140
					
			sprite.rotation_degrees = -12.5
		else:
			if not player_coll:
				player_detection.rotation_degrees += 1
				if (player_detection.rotation_degrees >= 30):
					player_detection.rotation_degrees = 10
				
			sprite.rotation_degrees = 12.5
			
		#oscillating
		
		position.y = start_y + sin(time) * amplitude

		if player_detection.is_colliding():
			var collider = player_detection.get_collider() # get the body the player detector raycast is colliding withh
			
			if collider and collider.is_in_group("player") and firerate_timer.is_stopped():
				if not collider:
					queue_free()
				player_coll = true
				throw_snowball()
			else:
				player_coll = false
		position.x += dir * speed * delta
	move_and_slide()


func throw_snowball():
	enemy_projectile = enemy_projectile_scene.instantiate()
	enemy_projectile.global_position = self.global_position
	get_tree().root.add_child(enemy_projectile)
	firerate_timer.start()

func damage():
	enemy_hp -= 10
	if enemy_hp <= 0:
		queue_free()
