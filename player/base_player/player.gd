extends CharacterBody2D

#movement variables
var speed := 150.0
var accn := 0.1
var deccn := 0.2

#jump variables
var jump_accn := 5.0
var jump_vel := -300.0
var slam := false 
var vel_y : float

#projectile vars
var projectile_scene := preload("res://projectiles/player_projectile/projectile.tscn") #getting the projectile scene
var projectile #instance of projectile
var firerate := 0.1 #firerate of snowball

#slam particles
var slam_scene := preload("res://player/player_particles/slam.tscn") #getting the slam particle scene
var slam_particle # instance of slam particle

#references to nodes
@onready var hat := $hat #player hat reference
@onready var player := $snowman # player sprite reference
@onready var cam := $Camera2D #used for camera shake
@onready var firerate_timer := $firerate #used to control firerate of snowballs
@onready var animation := $AnimationPlayer # animation player node used for stretch and squash
@onready var ray_right := $ray1 #right raycast
@onready var ray_left := $ray2 #left raycast
#TEMP#
@onready var particle_ded := $CPUParticles2D #death particles

func _ready() -> void: 
	#print(self.get_path()) #FOR DEBUGGING PURPOSES
	firerate_timer.wait_time = 0.1
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if PlayerData.PlayerHP <= 0:
		return
	$Label.text = str(PlayerData.PlayerHP)
	# Add the gravity.
	if not is_on_floor():
		vel_y = velocity.y
		#print(velocity.y)
		velocity += get_gravity() * delta

	# Handle jump
	if is_on_floor(): # and not is_jumping:
		if slam:
			hitstop(0.05,0.5)
			create_slam_particles(global_position)
			animation.play("squash")
			cam.shake(1.2)
			slam = false
		else:
			animation.play("jump_stretch")
			velocity.y = jump_vel
# IF...IF I PRESS THE BUTTON ASSIGNED TO "SLAM" AND...AND PLAYER IS IN AIR AND
# VELOCITY IS **NOT** NEGATIVE (is not jumping) THEN DO SLAM!!! 

	if Input.is_action_just_pressed("slam") and velocity.y > 0: #not is_on_floor()
		# -ve jump velocity means the player is jumping
		# ... vel.y > 0 check ensures that player is NOT jumping and is falling
		#squash
		#change velocity
		#is_jumping = false
		velocity.y *= jump_accn
		slam = true
		#print(velocity.y) # FOR DEBUGGING PURPOSES
	
	var direction := Input.get_axis("left", "right") #horizontal movement
	
	if direction == 1:
		player.flip_h = false
		hat.flip_h = false
	elif direction == -1:
		hat.flip_h = true
		player.flip_h = true
	if direction and not is_on_floor():
		#move from current velocity to intended speed by accn
		velocity.x = move_toward(velocity.x, direction * speed, speed * accn) #acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deccn) #deccelaration
	
	if Input.is_action_pressed("attack") and firerate_timer.is_stopped():
		fire_snowball()
	
	move_and_slide()

func fire_snowball():
	projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	
	#projectile.dir = (get_global_mouse_position() - projectile.global_position).normalized()
	
	get_tree().root.add_child(projectile)
	firerate_timer.start()

func hitstop(time_scale: float, duration: float):
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration * time_scale, true).timeout
	Engine.time_scale = 1.0
	
func create_slam_particles(pos: Vector2):
	var posX = pos.x
	var posY = pos.y
	var ray1 : bool = ray_right.is_colliding()
	var ray2 : bool = ray_left.is_colliding()
	
	posY = posY + 10
	
	for i in range(4):
		
		#right particles
		if ray1:
			slam_particle = slam_scene.instantiate()
			slam_particle.global_position.x = posX  + ((i + 1) * 14)
			slam_particle.global_position.y = posY
			get_tree().root.add_child(slam_particle)
		
		#left particles
		if ray2:
			slam_particle = slam_scene.instantiate()
			slam_particle.global_position.x = posX  - ((i + 1) * 14)
			slam_particle.global_position.y = posY
			slam_particle.flip_h = true
			get_tree().root.add_child(slam_particle)
		
		await get_tree().create_timer(0.1,true).timeout

func player_damage():
	PlayerData.PlayerHP -= 10
	if PlayerData.PlayerHP <= 0 and PlayerData.PlayerHP > -1000:
		player.hide()
		particle_ded.emitting = true
		animation.play("hat_fall")
		PlayerData.PlayerHP = -1000
		return
