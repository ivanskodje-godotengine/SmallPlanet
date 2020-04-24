extends Node2D

# Is this the start planet?
export (bool) var is_start_planet = false

onready var sphere_1 = get_node("sphere_1")
export (float) var sphere_1_rotation_deg = 1

onready var sphere_2 = get_node("sphere_2")
export (float) var sphere_2_rotation_deg = 0.3

# Make sure the player is set to be on this planet when we begin
func _ready():
	if(is_start_planet):
		get_parent().get_node("player").set_gravity_point(get_node("gravity_area").get_gravity(), get_global_pos(), true)
	set_process(true)


func _process(delta):
	sphere_1.set_rot(deg2rad(sphere_1_rotation_deg) * delta + sphere_1.get_rot())
	sphere_2.set_rot(deg2rad(-sphere_2_rotation_deg) * delta + sphere_2.get_rot())

func _on_gravity_area_body_enter( body ):
	if(body.get_groups().has("player") || body.get_groups().has("enemy")):
		print(body.get_name())
		body.set_gravity_point(get_node("gravity_area").get_gravity(), get_global_pos(), true)

func _on_gravity_area_body_exit( body ):
	if(body.get_groups().has("player") || body.get_groups().has("enemy")):
		body.disable_gravity_point()
	pass # replace with function body
