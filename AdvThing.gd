extends KinematicBody2D

class_name AdvThing

signal message(msg)

var hh : float
var stationary : bool
var id : int
var grabbable : bool
var thing_name : String = "thing"
var rough_radius : float = 0
var queue : Array = []
var current : Dictionary = {}

var path : Array = []
var goal : Vector2 = Vector2(0,0)
var velocity : Vector2 = Vector2()
export (int) var speed : float = 50

func _ready():
	stationary = true
	grabbable = false
	add_to_group("Entities")
	set_init_hh()
	id = global.nextId()
	for p in get_collision_shape():
		rough_radius = max(rough_radius, p.length())
	goal = self.global_position

func _process(delta):
	if current.has("type"):
		match current.type:
			"move":
				if !current.in_progress:
					new_path(current.path)
					current.in_progress = true
				else:
					if abs(goal.distance_to(self.global_position)) < 1:
						if path.size() > 0:
							goal = path.pop_front()
						else:
							velocity = Vector2(0,0)
							current = {}
					else:
						velocity = (goal - self.global_position).normalized() * speed
						move_and_slide(velocity)
			"grab":
				print("Grab " + current.target.thing_name + " !")
				#I don't like doing it this way, but I don't know how
				#else to do it, really
				if thing_name == "Player":
					global.inventory.append(current.target.duplicate())
					current.target.queue_free()
					pass
				current = {}
	elif queue.size() > 0:
		current = queue.pop_front()
		
	update_z()

func new_path(new_path) -> void:
	goal = self.global_position
	path.clear()
	path.push_back(self.global_position)
	for p in new_path:
		path.push_back(p)

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
			emit_signal("message", "You see the " + thing_name)
		global.CURSOR_STATES.SMELL:
			pass
		global.CURSOR_STATES.TASTE:
			pass
		global.CURSOR_STATES.LISTEN:
			pass

func update_z() -> void:
	z_index = -(global.height - self.global_position.y - hh)
	
func set_init_hh() -> void:
	hh = (get_child(2) as Sprite).get_texture().get_height()/2.0
	
func getId() -> int:
	return id
