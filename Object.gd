extends KinematicBody2D

signal message(msg)

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

#func _input_event(event):
#	print ("entered")
#	if event is InputEventMouseButton and not event.pressed and global.cursor_state == global.TOUCH:
#		print("object")

func get_collision_box():
	return get_node("CollisionShape2D")

func _on_ClickBox_clicked():
	match global.cursor_state:
		global.WALK:
			pass
		global.HAND:
			pass
		global.LOOK:
			emit_signal("message", "You see the object")
		global.SMELL:
			pass
		global.TASTE:
			pass
		global.LISTEN:
			pass
