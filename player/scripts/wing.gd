extends Sprite

export (NodePath) var player_path 
onready var player = get_node(player_path)

func _ready():
	set_process(true)

func _process(delta):
	rotate_wing()

# Handles the wing rotation (pointing)
func rotate_wing():
	# Get mouse position
	var global_mouse_pos = get_global_mouse_pos()
	
	# Global player position
	var player_pos = player.get_global_pos()
	# <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	# TODO: FIX THE SCALE AND ROTATION THING
	# ## ><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	var angle = null
	# Calculate angle to the mouse position
	if(player.get_scale().x == -1):
		player_pos = Vector2(player_pos.x, player_pos.y)
		global_mouse_pos = Vector2(global_mouse_pos.x, global_mouse_pos.y)
		angle = player_pos.angle_to_point(global_mouse_pos) + -player.get_rot()
		angle = -angle
		# print("Angle: " + str(rad2deg(angle)))
		
	else:
		angle = player_pos.angle_to_point(global_mouse_pos) # Global Angle (does not change with ANY rotation)

	# If we don't use Global Rotation, we need to subtract the rotation done on the parent (Player RigidBody2D),
	# in order to get the correct rotation from the mouse and player global position
	# # set_rot(angle - player.get_rot())
	
	# Set global rotation (relative to own current rotation, 
	# no need to take in account of parent rotation, as this is global)
	if(player.get_scale().x == -1):
		set_global_rot(angle + player.get_rot())
	else:
		set_global_rot(angle)

	# Update pistol with the angle
	if(player.get_scale().x == -1):
		get_node("weapon/pistol").update_pistol(angle)
	else:
		get_node("weapon/pistol").update_pistol(angle - player.get_rot())
