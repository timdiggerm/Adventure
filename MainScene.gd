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
	action_bar = get_node("ActionBar")
	global.main_scene = self
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
	#dialog_box.displayMessage(msg)
	action_bar.update_text(msg)
	
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

func _handle_item_use(obj) -> void:
	#obj is the object that got clicked
	#global.current_item is the item the user is using
	
	#Check if the obj and the item can have a meaningful
	#interaction. If they can't, display a message
	
	if not global.current_item.can_interact(obj):
	#	send a message to the message box
		action_bar.update_text("That doesn't do anything")
		return
	
	#Everything after this only happens if the items _can_ interact
	var v = player.get_global_position() - obj.get_global_position()
	var goal = obj.get_global_position() + v / v.length() * (obj.rough_radius + player.rough_radius)
	player.queue.clear()
	player.current = {}
	
	#Check if the obj and the item require proximity. If so, 
	#add movement to the player's queue (see _handle_grab).
	if global.current_item.requires_proximity(obj):
		player.queue.push_back({
			"type":"move",
			"in_progress": false,
			"path": nav_system.get_nav_path(player.get_global_position(), goal),
		})
	
	#Add the item use to the player queue
	player.queue.push_back({
		"type":"item_use",
		"obj":obj,
		"item":global.current_item,
	})

func _on_ActionBar_viewInventory():
	inventory_box.populate_inventory()
	inventory_box.popup()

func instantiate_player(player_name := "Player", x := 300, y := 300):
	if not global.scenes.has(player_name):
		global.scenes[player_name] = load("res://entities/" + player_name + ".tscn")
	player = global.scenes[player_name].instance() as Node
	player.set_global_position(Vector2(x, y))
	
	player.connect("changescene", self, "change_scene")
	
func load_locale(name : String) -> void:
	var future_children = []
	var future_entities = []
	var future_portals = []
	
	#Load the locale
	var content = []
	#Check if we've visited this locale yet
	if name in global.locales:
		#If we have, just grab it from the cache
		content = global.locales[name]
	else:
		#If we haven't load it from the file
		var file = File.new()
		file.open("locales/" + name + ".lcl", File.READ)
		content = file.get_as_text().split("\n")
		file.close()
		#And stick it in the cache
		global.locales[name] = content
	for line in content:
		var tokens = line.split(" ")
		match tokens[0]: #tokens[0] contains the type of thing we're loading
			"player":
				instantiate_player(tokens[1], 200, 400)
				future_children.push_back(player)
				future_entities.push_back(player)
			"background":
				var img = Image.new()
				img.load("images/" + tokens[1])
				background.texture = ImageTexture.new()
				background.texture.create_from_image(img, 0)
				
			"obj": #objects have a scene name and x y coords
				#If it's not a scene we've loaded before, load it into the cache
				if not global.scenes.has(tokens[1]):
					global.scenes[tokens[1]] = load("res://entities/" + tokens[1] + ".tscn")
				var obj = global.scenes[tokens[1]].instance() as Node
					
				future_children.push_back(obj)
				future_entities.push_back(obj)
				obj.set_global_position(Vector2(tokens[2], tokens[3]))
			"portal":
				var destination = tokens[1]
				#This is just how you make an Area. I don't know why. It works.
				var obj = Area2D.new()
				var coll_shape = CollisionShape2D.new()
				var rect = RectangleShape2D.new()
				rect.set_extents(Vector2(10, 10))
				coll_shape.set_shape(rect)
				obj.add_child(coll_shape)
				
				#add_child(obj)
				future_children.push_back(obj)
				future_portals.push_back(obj)
				obj.set_global_position(Vector2(tokens[2], tokens[3]))
				obj.set_name(destination)
				obj.add_to_group("Portals")
	
	#Process all entities for various actions
	for o in future_entities:
		# connect all entities' signals to appropriate callbacks
		o.connect("message", self, "_handle_message")
		o.connect("item_use", self, "_handle_item_use", [o])
		if(o.grabbable):
			o.connect("desired_grab", self, "_handle_grab")
			#This next line _should_ work and even _does_ work, but then
			#when the signal is emitted by the AdvThing, nothing happens
			#so instead there's a kludgey but acceptable fix in AdvThing
			#o.connect("update_inventory", action_bar, "populate_inventory")

	#Connect all portals to the player
	for o in future_portals:
		o.connect("body_entered", player, "use_portal", [o.get_name()])
	
	#Put them all in the scene tree
	for child in future_children:
		call_deferred("add_child",child)
	
	for o in get_tree().get_nodes_in_group("Entities"):
		#Add stationary items to the nav system
		if(o.stationary):
			nav_system.add_collision_box(o)
	nav_system.call_deferred("reload_nav")
	
	#We're done loading!
	future_children.clear()
	future_entities.clear()
	future_portals.clear()

func change_scene(destination):
	var delete_list = []
	for o in get_tree().get_nodes_in_group("Entities"):
		self.call_deferred("remove_child", o)
		delete_list.push_back(o)
	for o in get_tree().get_nodes_in_group("Portals"):
		self.call_deferred("remove_child", o)
		delete_list.push_back(o)
	load_locale(destination)
	for o in delete_list:
		o.queue_free()
