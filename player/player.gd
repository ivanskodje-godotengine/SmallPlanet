extends RigidBody2D
# BACKUP: https://pastebin.com/y55LLsec

# Health
export (int) var max_health = 100
export (int) var current_health = 100

# Weapon
onready var current_weapon = get_node("body_parts/upper_body/wing/weapon/pistol")

# Animation
onready var anim_player = get_node("anim_player")

# Health Bar
onready var health_bar = get_node("health_bar")

# Gravity 
var global_gravity_point = null

# Forces
var directional_force = Vector2(0, 0)
var gravity_magnitude = 0.0
const MOVEMENT_SPEED = 500.0 # Movement speed
const JUMP_SPEED = 1400 # The speed of the jump of the

# Variable Jump Height
var jump_time = 0
var MAX_JUMP_TIME = 0.3 # seconds

# Controllers
var move_left = false
var can_jump = false
var crouching = false
var grounded = false


# Start
func _ready():
	health_bar.init(max_health, current_health)
	set_fixed_process(true)
	set_process_input(true)

var health_bar_scale = Vector2(0.4, 0.4)

# HACK: Forcefully set scale to left, when moving left
func _integrate_forces(state):
	if(move_left):
		set_scale(Vector2(-1, 1))
		health_bar.set_scale(Vector2(-1, 1) * health_bar_scale)
	else:
		health_bar.set_scale(Vector2(1, 1) * health_bar_scale)

# Physics processing
func _fixed_process(delta):
	# Get updated rotation
	update_rotation()
	
	# Init velocity
	directional_force = Vector2(0, 0)
	var final_velocity = Vector2()
	
	# Get Gravity
	var gravity = Vector2(0, 1).rotated(angle) * gravity_magnitude

	# Move LEFT
	if(Input.is_action_pressed("move_left")):
		directional_force += Vector2(-1, 0).rotated(angle) * MOVEMENT_SPEED
		move_left = true
	
	# Move RIGHT
	if(Input.is_action_pressed("move_right")):
		directional_force += Vector2(1, 0).rotated(angle) * MOVEMENT_SPEED
		move_left = false
	
	# JUMP
	if(Input.is_action_pressed("jump") && jump_time < MAX_JUMP_TIME && can_jump):
		directional_force += Vector2(0, -1).rotated(angle) * JUMP_SPEED
		jump_time += delta
	
	# CROUCH
	if(Input.is_action_pressed("crouch") && grounded):
		print("CROUCH MNOE")
	
	# SPECIAL ??
	if(Input.is_action_pressed("crouch") && !grounded):
		print("Do something cool in the air")
	
	# FIRE1
	if(Input.is_action_pressed("fire1")):
		current_weapon.shoot()
	
	# If we are on the ground - enable jump and set jump time back to 0
	if(grounded):
		can_jump = true
		jump_time = 0
	
	# Apply gravity and an optional directional force
	final_velocity = directional_force + gravity
	
	# As long as we are not in space (no gravity magnitude), apply forces
	if(gravity_magnitude != 0):
		set_linear_velocity(final_velocity)

# Rotation
onready var angle = 0
func update_rotation():
	# Update rotation based on planet position (so that we are standing upright)
	if(global_gravity_point != null):
		angle = global_gravity_point.angle_to_point(get_global_pos())
		print()
		print("ANGLE: " + str(rad2deg(angle)))
		# Debug
		if(global.DEBUG):
			get_node("debug").set_text("Degree: " + str(rad2deg(angle)))
		
		# Set player rotation
		set_rot(angle)


# User Input
func _input(event):
	if(event.is_action_released("jump")):
		can_jump = false


# Set gravity Point
func set_gravity_point(gravity_magnitude, gravitational_vector, is_planet):
	self.gravity_magnitude = gravity_magnitude
	
	if(is_planet):
		global_gravity_point = gravitational_vector
	else:
		angle = gravitational_vector.angle()
		set_rot(angle)


# When you leave the gravity area, we turn off gravity
func disable_gravity_point():
	global_gravity_point = null
	gravity_magnitude = 0.0


func apply_damage(value):
	# Apply damage to our health
	current_health -= value
	
	# Inform health bar
	health_bar.set_current_value(current_health)
	
	# Check if we have died
	if(current_health <= 0):
		# Die here.
		print("You have died")
		pass


# Ground Checker: Enter
func _on_ground_checker_body_enter( body ):
	var groups = body.get_groups()
	if(groups.has("solid")):
		grounded = true


# Ground Checker: Exit
func _on_ground_checker_body_exit( body ):
	var groups = body.get_groups()
	if(groups.has("solid")):
		grounded = false