extends KinematicBody2D

class_name AdvThing

signal message(msg)

var hh : float
var stationary : bool;

func _ready():
	stationary = true;
	add_to_group("Entities")
	set_init_hh()

func _process(delta):
	update_z()

func get_collision_shape() -> PoolVector2Array:
	return (get_node("CollisionPoly") as CollisionPolygon2D).get_polygon()

func get_collision_box() -> CollisionPolygon2D:
	return get_node("CollisionPoly") as CollisionPolygon2D

func _on_ClickBox_clicked() -> void:
	#print("HELLO")
	match global.cursor_state:
		global.CURSOR_STATES.WALK:
			pass
		global.CURSOR_STATES.HAND:
			pass
		global.CURSOR_STATES.LOOK:
			emit_signal("message", "You see the object")
		global.CURSOR_STATES.SMELL:
			pass
		global.CURSOR_STATES.TASTE:
			pass
		global.CURSOR_STATES.LISTEN:
			pass

func update_z() -> void:
	z_index = -(global.height - self.global_position.y - hh)
	
func set_init_hh() -> void:
	hh = (get_child(2) as Sprite).get_texture().get_height()/2