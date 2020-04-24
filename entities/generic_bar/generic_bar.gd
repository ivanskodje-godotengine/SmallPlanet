tool
extends Node2D

# TODO: Replace these
export (PackedScene) var bar_01
export (PackedScene) var bar_02

# Bar Configurations
export (String, "bar_01", "bar_02") var current_bar = "bar_01" setget set_current_bar
export (int) var max_value = 100 setget set_max_value
export (int) var current_value = 100 setget set_current_value
export (bool) var show_text = true setget set_show_text
export (bool) var show_percentage = true setget set_show_percentage
export(Color, RGB) var bar_color = Color(1, 0, 0) setget set_bar_color
export(Color, RGB) var bar_background_color = Color(0.27, 0.26, 0.32) setget set_bar_background_color
export(Color, RGB) var text_color = Color(1, 1, 1) setget set_text_color


# Instance of the bar
var instance = null

func _ready():
	set_current_bar(current_bar)

# Initiate the bar
func init(max_value, current_value):
	set_max_value(max_value) 
	set_current_value(current_value)


# Updates the bar 
func update_bar():
	# Get percentage
	var percentage = current_value / (max_value * 1.0) # 0-1
	instance.get_node("value").set_scale(Vector2(percentage, 1))
	
	# Set health text
	if(show_percentage):
		var percentage_text = str(int(percentage * 100)) + "%"
		instance.get_node("label").set_text(percentage_text)
	else:
		instance.get_node("label").set_text(str(current_value) + " / " + str(max_value))


# Set current bar
func set_current_bar(value):
	# Remove existing children
	if(get_child_count() > 0):
		for child in get_children():
			child.queue_free()
	
	# Instance the bar we have selected
	if(value == "bar_01"):
		instance = bar_01.instance()
		add_child(instance)
	elif(value == "bar_02"):
		instance = bar_02.instance()
		add_child(instance)
	
	# Update value
	current_bar = value
	
	# Update bar
	update_bar()
	
	# Update bar colors
	set_bar_color(bar_color)
	set_bar_background_color(bar_background_color)
	
	# Set text color
	set_text_color(text_color)
	
	# Update label visibility
	set_show_text(show_text)


# Set Current Value
func set_current_value(value):
	if(value > max_value):
		max_value = value
	current_value = clamp(value, 0, max_value)
	update_bar()


# Set Max Value
func set_max_value(value):
	if(value <= 0):
		print("ERROR: generic_bar.gd -> set_max_value() cannot be less than 1")
		return
	elif(value < current_value):
		current_value = value
	
	max_value = value
	update_bar()

# Set bar color
func set_bar_color(value):
	instance.get_node("value").set_frame_color(value)
	bar_color = value

# Set bar background color
func set_bar_background_color(value):
	instance.get_node("background").set_frame_color(value)
	bar_background_color = value

# Set text color
func set_text_color(value):
	instance.get_node("label").add_color_override("font_color", value)
	text_color = value

# Returns current value
func get_current_value():
	return current_value


# Returns max value
func get_max_value():
	return max_value


# Set label value visibility
func set_show_text(value):
	if(value):
		instance.get_node("label").show()
	else:
		instance.get_node("label").hide()
	
	show_text = value

func set_show_percentage(value):
	show_percentage = value
	update_bar()