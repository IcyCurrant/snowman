extends CharacterBody2D

#loading custom resource
@export var enemyType : EnemyTypes

# general variables
var speed : float
var enemy_hp : float
var dir := randi_range(-1,1)
var num : int

var time := 0.0
var amplitude :float  # how high/low it goes
var frequency : float   # how fast
var start_y : float

#node references
@onready var left := $left_raycast
@onready var right := $right_raycast
@onready var firerate_timer := $firerate_timer
@onready var player_detection := $player_detection
@onready var sprite := $AnimatedSprite2D

#bullet scene_reference
@onready var enemy_projectile_scene = preload("res://main_/enemy_projectile.tscn")
var enemy_projectile

func _preload_enemy_types(type: int):
	match num:
		0:
			enemyType = preload("res://enemies/types/elf_land_.tres")
		1:
			enemyType = preload("res://enemies/types/elf_copter.tres")

func _ready() -> void:
	amplitude = randf_range(20.0, 30.0)
	frequency = randf_range(2.0,4.0)
	start_y = position.y
	if dir == 0:
		dir = 1
	
	_preload_enemy_types(0)
	enemyType = enemyType.duplicate(true)
	speed = enemyType.speed
	enemy_hp = enemyType.enemy_hp
	firerate_timer.wait_time = enemyType.firerate
	sprite.sprite_frames = enemyType.sprite_frames
	
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
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
		sprite.offset.x = 8
		
		if dir == -1:
			rotation_degrees = -12.5
		else:
			rotation_degrees = 12.5
			
		#oscillating
		time += delta * frequency
		position.y = start_y + sin(time) * amplitude

		if player_detection.is_colliding():
			var collider = player_detection.get_collider()
			if collider.is_in_group("player") and firerate_timer.is_stopped():
				throw_snowball()
		
		position.x += dir * speed * delta
	move_and_slide()


func throw_snowball():
	enemy_projectile = enemy_projectile_scene.instantiate()
	enemy_projectile.global_position = self.global_position
	get_tree().root.add_child(enemy_projectile)
	firerate_timer.start()
