extends KinematicBody2D

signal message(msg)

var hh
var stationary;

func _ready():
	stationary = true;
	add_to_group("Entities")
	set_init_hh()

func _process(delta):
	update_z()

func get_collision_shape():
	return get_node("CollisionShape2D").get_shape()

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

func update_z():
	z_index = -(global.height - self.global_position.y - hh)
	
func set_init_hh():
	hh = get_child(1).texture.get_height()/2