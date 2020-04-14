extends Node

var player : KinematicBody2D
var nav_system : NavigationSystem
var action_bar : HBoxContainer
var dialog_box : PopupDialog
var inventory_box : WindowDialog
var background : Sprite

func _ready():
	#player = get_node("Player") as KinematicBody2D
	nav_system = get_node("NavigationSystem") as NavigationSystem
	dialog_box = get_node("Dialog") as PopupDialog
	inventory_box = get_node("InventoryBox") as WindowDialog
	background = get_node("Background") as Sprite
	
	load_locale("default")
	



#input handling, if no gui elements have handled the event
func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		#print("MainScene Handler")
		if global.cursor_state == global.CURSOR_STATES.WALK:
			player.queue.clear()
			player.current = {}
			player.queue.push_back({
				"type":"move",
				"in_progress": false,
				"path": nav_system.get_nav_path(player.get_global_position(), event.position),
			})

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_ActionBar_hand() -> void:
	global.cursor_state = global.CURSOR_STATES.TOUCH

func _on_ActionBar_look() -> void:
	global.cursor_state = global.CURSOR_STATES.LOOK

func _on_ActionBar_walk() -> void:
	global.cursor_state = global.CURSOR_STATES.WALK
	
func _handle_message(msg) -> void:
	dialog_box.displayMessage(msg)
	
func _handle_grab(obj) -> void:
	var v = player.get_global_position() - obj.get_global_position()
	var goal = obj.get_global_position() + v / v.length() * (obj.rough_radius + player.rough_radius)
	player.queue.clear()
	player.current = {}
	player.queue.push_back({
		"type":"move",
		"in_progress": false,
		"path": nav_system.get_nav_path(player.get_global_position(), goal),
	})
	player.queue.push_back({
		"type":"grab",
		"target":obj,
		
	})

func _on_ActionBar_viewInventory():
	inventory_box.populate_inventory()
	inventory_box.popup()

func load_locale(name : String) -> void:
	print("loading")
	
	#Create the player
	#player = Player.new()
	player = load("res://Player.tscn").instance() as Player
	player.set_global_position(Vector2(200, 400))
	add_child(player)
	player.connect("changescene", self, "change_scene")
	
	#Load the locale
	var file = File.new()
	file.open("res://locales/" + name + ".lcl", File.READ)
	var content = file.get_as_text().split("\n")
	file.close()
	for line in content:
		var tokens = line.split(" ")
		match tokens[0]: #tokens[0] contains the type of thing we're loading
			"background":
				var img = Image.new()
				img.load("res://images/" + tokens[1])
				background.texture = ImageTexture.new()
				background.texture.create_from_image(img, 0)
				
			"obj": #objects have a scene name and x y coords
				var obj = load("res://" + tokens[1] + ".tscn").instance() as Node
				#this should later be changed to preload, and a dictionary of existing loaded scenes
				# to prevent unnecessary reloads for many instances of same scene
				add_child(obj)
				obj.set_global_position(Vector2(tokens[2], tokens[3]))
			"portal":
				var destination = tokens[1]
				var obj = Area2D.new()
				var coll_shape = CollisionShape2D.new()
				var rect = RectangleShape2D.new()
				rect.set_extents(Vector2(10, 10))
				coll_shape.set_shape(rect)
				obj.add_child(coll_shape)
				add_child(obj)
				obj.set_global_position(Vector2(tokens[2], tokens[3]))
				obj.set_name(destination)
				obj.add_to_group("Portals")
				
	#Process all entities for various actions
	for o in get_tree().get_nodes_in_group("Entities"):
		# connect all entities' signals to appropriate callbacks
		o.connect("message", self, "_handle_message")
		# then add them to the nav system if it's a stationary object
		if(o.stationary):
			nav_system.add_collision_box(o)
		if(o.grabbable):
			o.connect("desired_grab", self, "_handle_grab")

	#Connect all portals to the player
	for o in get_tree().get_nodes_in_group("Portals"):
		o.connect("body_entered", player, "use_portal", [o.get_name()])
	
	nav_system.reload_nav()

func change_scene(destination):
	for o in get_tree().get_nodes_in_group("Entities"):
		o.queue_free()
	for o in get_tree().get_nodes_in_group("Portals"):
		o.queue_free()
	load_locale(destination)
