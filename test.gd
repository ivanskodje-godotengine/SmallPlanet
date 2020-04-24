extends StaticBody2D

var gravity_vector = null

func _ready():
	var grav_vector = Vector2(0.0, 1.0)
	gravity_vector = grav_vector.rotated(get_rot())
	print(gravity_vector)
	get_node("Area2D").set_gravity_vector(gravity_vector)
	

func _on_Area2D_body_enter( body ):
	if(body.get_groups().has("player")):
		body.set_gravity_point(get_node("Area2D").get_gravity(), gravity_vector, false)