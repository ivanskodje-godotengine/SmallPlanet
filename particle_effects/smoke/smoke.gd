extends Particles2D

var expiration_time = 1
var time = 0

# Start
func _ready():
	expiration_time = get_lifetime()
	set_emitting(true)
	set_process(true)

# Run timer, and remove self when expired
func _process(delta):
	time += delta
	if(time > expiration_time):
		queue_free()

