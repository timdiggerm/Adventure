extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input_event(event):
	print ("entered")
	if event is InputEventMouseButton and not event.pressed and get_parent().cursor_state == global.TOUCH:
		print("object")

func get_collision_box():
	return get_node("CollisionShape2D")