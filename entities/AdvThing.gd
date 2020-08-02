extends KinematicBody2D

class_name AdvThing

signal message(msg)
signal item_use

var stationary : bool
var id : int
var grabbable : bool
var thing_name : String = "thing"
var rough_radius : float = 0
var queue : Array = []
var current : Dictionary = {}
var sprite : AnimatedSprite
var footprint_offset : Vector2

var path : Array = []
var goal : Vector2 = Vector2(0,0)
var velocity : Vector2 = Vector2()
export (int) var speed : float = 50

func _init():
	stationary = true
	grabbable = false
	add_to_group("Entities")

func _ready():
	id = global.nextId()
	
	#calculate the local centroid of the collision polygon
	var centroid = Vector2(0,0)
	var n = len(get_child(0).polygon)
	for c in get_child(0).polygon:
		centroid.x = c.x + centroid.x
		centroid.y = c.y + centroid.y
	centroid.x = centroid.x / n
	centroid.y = centroid.y / n
	footprint_offset = centroid
	
	for p in get_collision_shape():
		rough_radius = max(rough_radius, (p-centroid).length())
	goal = self.get_global_position()
	sprite = get_child(2)

func _process(delta):
	#Proccessing the current action in the action queue
	if current.has("type"):
		match current.type:
			"move":
				if !current.in_progress: #If the thing isn't current moving, but it's supposed to
					new_path(current.path) #then start moving!
					current.in_progress = true
				else: #but if it is already in motion
					#If it's near its next waypoint
					if abs(goal.distance_to(self.get_global_position())) < 1:
						#and it still has waypoints to go
						if path.size() > 0:
							#then head for tne next waypoint
							goal = path.pop_front()
						#otherwise, it's reached its goal. Stop!
						else:
							velocity = Vector2(0,0)
							current = {}
					#But if it's in motion, but not near its goal, then move toward the next waypoint
					else:
						velocity = (goal - self.get_global_position()).normalized() * speed
						move_and_slide(velocity)
				movement_animation_control()
			"grab":
				#I don't like doing it this way, but I don't know how
				#else to do it, really
				if thing_name == "Player":
					global.inventory.append(current.target.duplicate())
					current.target.queue_free()
					#This is the code I want to use...
					#print("Grab " + current.target.thing_name + " !")
					#emit_signal("update_inventory")
					
					#this is the code that actually works
					#global.main_scene.action_bar.populate_inventory()
					
					#just kidding this is better
					global.main_scene.action_bar.add_inventory(global.inventory[global.inventory.size() - 1])
				current = {}
				
			"item_use":
				current.obj.handle_item(current.item)
				current = {}
	elif queue.size() > 0:
		current = queue.pop_front()
		
	update_z()

#Any object that animates while moving should override this method
func movement_animation_control() -> void:
	pass

func new_path(new_path) -> void:
	goal = self.get_global_position()
	path.clear()
	path.push_back(self.get_global_position())
	for p in new_path:
		path.push_back(p)

func get_collision_shape() -> PoolVector2Array:
	return (get_node("CollisionPoly") as CollisionPolygon2D).get_polygon()

func get_collision_box() -> CollisionPolygon2D:
	return get_node("CollisionPoly") as CollisionPolygon2D

func _on_ClickBox_clicked() -> void:
	match global.cursor_state:
		global.CURSOR_STATES.WALK:
			pass
		global.CURSOR_STATES.HAND:
			pass
		global.CURSOR_STATES.LOOK:
			emit_signal("message", "You see the " + thing_name)
		global.CURSOR_STATES.ITEM:
			emit_signal("item_use")
			#handle_item(global.current_item)
		global.CURSOR_STATES.SMELL:
			pass
		global.CURSOR_STATES.TASTE:
			pass
		global.CURSOR_STATES.LISTEN:
			pass

func update_z() -> void:
	z_index = -(global.height - self.get_global_position().y)
	
func getId() -> int:
	return id

func use_portal(obj, destination):
	print(obj, " requesting transport to ", destination)

func handle_item(item : AdvThing):
	print("Using", item.thing_name)

func get_height():
	return get_child(2).frames.get_frame("default", 0).get_height()

func get_global_position():
	return .get_global_position() + footprint_offset
	
func stop():
	queue = []
	velocity = Vector2(0,0)
	current = {}
	movement_animation_control()
