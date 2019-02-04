extends KinematicBody2D

signal message(msg)

var hh

func _ready():
	add_to_group("Entities")
	hh = get_child(1).texture.get_height()/2
	pass

func _process(delta):
	z_index = -(global.height - self.global_position.y - hh)

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
