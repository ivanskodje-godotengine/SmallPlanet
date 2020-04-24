extends Node2D

# Bullet Scene
export (PackedScene) var bullet

# Barrel Smoke Particle
export (PackedScene) var barrel_smoke_particle

# Barrel Exit
onready var barrel_exit = get_node("barrel_exit")

# Main node - Used to add bullets to the scene
onready var main = get_node("/root/main")

# Original Scale (used in case we want the gun bigger or smaller)
var scale = Vector2(1, 1)

# Used to notify this gun when we have changed rotation
var rot = 0

# Shot delay
export (float) var bullet_speed = 25
export (float) var bullet_delay = 0.3 # seconds
var delay = 0 # Current delay

# Start
func _ready():
	# Get scale
	scale = get_scale()
	set_process(true)

# Shoot
func shoot():
	if(delay <= 0):
		# Instance a bullet
		var instance = bullet.instance()
		
		# Set bullet spawn pos
		instance.set_global_pos(barrel_exit.get_global_pos())
		
		# Set bullet rotation
		instance.set_global_rot(get_global_rot())
		
		# Set bullet velocity
		var bullet_vel = Vector2(0, -1) * bullet_speed
		
		# Shoot the bullet in the direction you are facing (with global rotation)
		instance.shoot(bullet_vel.rotated(get_global_rot()))
		
		# Push it out of the barrel by adding it to the scene
		main.add_child(instance)
		
		# Put delay to shot delay,. so that we cant shoot super fast
		delay = bullet_delay
		
		# Particle effect
		var particle = barrel_smoke_particle.instance()
		get_parent().add_child(particle)
		particle.set_global_pos(barrel_exit.get_global_pos())
	
	# Play sound effect
	# ...
	
	# Create explosion
	# ...


# Update values and angles
func update_pistol(angle):
	# Reduce angle so that it is always between 0 and 360
	var temp = int(rad2deg(angle)) % 360
	temp = (temp + 360) % 360
	
	# Get angle value between -180 and 180, with 0 as the center
	if(temp > 180):
		temp -= 360
	
	# Set rotation as rad
	rot = deg2rad(temp)


# Flip the gun?
func _process(delta):
	# If you have shot, reduce the time until it is 0
	if(delay >= 0):
		delay -= delta
	
	# Flip the weapon when pointing behind, and vica verca
	if(rot >= 0 && rot < deg2rad(180) && get_scale().x != -1):
		set_scale(Vector2(-1 * scale.x, scale.y))
	elif(rot < 0 && rot > deg2rad(-180) && get_scale().x != 1):
		set_scale(Vector2(1 * scale.x, scale.y))