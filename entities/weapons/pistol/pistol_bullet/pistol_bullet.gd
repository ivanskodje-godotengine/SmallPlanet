extends KinematicBody2D

# On Impact Particles
export (PackedScene) var on_impact_particle

# Bullet Damage
export (int) var DAMAGE = 25

# Start
func _ready():
	pass

# Shoot
var velocity = Vector2(0, 0)
func shoot(velocity):
	self.velocity = velocity
	set_fixed_process(true)
	get_node("smoke_trail").set_emitting(true)

# Bullet Movement
func _fixed_process(delta):
	move(velocity)

# On Bullet Collision
func _on_pistol_bullet_body_enter( body ):
	if(body.get_groups().has("enemy")):
		body.apply_damage(DAMAGE)
		destroy(body)
	elif(body.get_groups().has("solid")):
		destroy(body)
	

# Exit Screen
func _on_visibility_notifier_2d_exit_screen():
	queue_free()

func destroy(body):
	var smoke = on_impact_particle.instance()
	smoke.set_global_pos(get_global_pos())
	get_parent().add_child(smoke)
	queue_free()