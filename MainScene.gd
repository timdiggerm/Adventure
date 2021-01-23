extends Node

var player : KinematicBody2D
var nav_system : NavigationSystem
var action_bar : HBoxContainer
var background : Sprite
var current_locale : String
var current_landings : Dictionary

func _ready():
	#player = get_node("Player") as KinematicBody2D
	nav_system = get_node("NavigationSystem") as NavigationSystem
	background = get_node("Background") as Sprite
	action_bar = get_node("ActionBar")
	global.main_scene = self
	load_locale("default")

func _on_ActionBar_hand() -> void:
	global.cursor_state = global.CURSOR_STATES.TOUCH

func _on_ActionBar_look() -> void:
	global.cursor_state = global.CURSOR_STATES.LOOK

func _on_ActionBar_walk() -> void:
	global.cursor_state = global.CURSOR_STATES.WALK

func _handle_message(msg) -> void:
	#dialog_box.displayMessage(msg)
	action_bar.update_text(msg)

#input handling, if no gui elements have handled the event
func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		if global.cursor_state == global.CURSOR_STATES.WALK:
			player.move_now(event.position)

# Handling grabbing an object
func _handle_grab(obj) -> void:
	player.grab(obj)

func _handle_conversation(obj) -> void:
	print("Let's talk to ", obj)
	get_child(3).visible = true

func _handle_item_use(obj) -> void:
	#obj is the object that got clicked
	#global.current_item is the item the user is using
	
	#Check if the obj and the item can have a meaningful interaction
	if global.current_item.can_interact(obj):
		#Use the item
		player.use_item(obj)
	else:
		#send a message to the message box
		action_bar.update_text("That doesn't do anything")

func instantiate_player(player_name := "Player", x := 300, y := 300):
	if not global.scenes.has(player_name):
		global.scenes[player_name] = load("res://entities/" + player_name + ".tscn")
	player = global.scenes[player_name].instance() as Node
	player.set_global_position(Vector2(x, y))
	
	player.connect("changescene", self, "change_scene")
	
func load_locale(name : String, landing = "default", saved_entities = []) -> void:
	var future_children = []
	var future_entities = []
	var future_portals = []
	current_locale = name
	
	#Load the locale
	var content = []
	#Check if we've visited this locale yet
	if name in global.live_locales:
		##THIS METHOD SHOULD RELOAD THE STUFF IN THE LIVE_LOCALE AS IF WE NEVER LEFT
		var locale = global.live_locales[name]
		background.texture = locale['background']
		current_landings = locale['landings']
		for obj in locale['nodes']:
			##if obj is Player:
			##	obj.queue = []
			##	obj.set_global_position(Vector2(200,400))
				#future_entities.push_back(obj)
			if obj is AdvThing:
				obj.add_to_group("Entities")
				future_entities.push_back(obj)
			elif obj is Area2D:
				obj.add_to_group("Portals")
				future_portals.push_back(obj)
			future_children.push_back(obj)
		player.stop()
	else:
		#If we've visited it before but for some it's no longer live...
		if name in global.locale_listings:
			#If we have, just grab it from the cache
			content = global.locale_listings[name]
		
		#If we've never been to this locale before
		else:
			#If we haven't load it from the file
			var file = File.new()
			file.open("locales/" + name + ".lcl", File.READ)
			content = file.get_as_text().split("\n")
			file.close()
			#And stick it in the cache
			global.locale_listings[name] = content
		for line in content:
			var tokens = line.split(" ")
			match tokens[0]: #tokens[0] contains the type of thing we're loading
				"player":
					if player is Player:
						player.set_global_position(Vector2(200, 400))
						player.stop()
					else: #This only gets called if there is not already a Player in the game
						instantiate_player(tokens[1], 200, 400)
						future_children.push_back(player)
						future_entities.push_back(player)
				"background":
					var img = Image.new()
					img.load("images/" + tokens[1])
					background.texture = ImageTexture.new()
					background.texture.create_from_image(img, 0)
					
				"obj": #objects have a scene name and x y coords
					if saved_entities.empty():
						#If it's not a scene we've loaded before, load it into the cache
						if not global.scenes.has(tokens[1]):
							global.scenes[tokens[1]] = load("res://entities/" + tokens[1] + ".tscn")
						var obj = global.scenes[tokens[1]].instance() as AdvThing

						future_children.push_back(obj)
						future_entities.push_back(obj)
						obj.set_global_position(Vector2(tokens[2], tokens[3]))
				"portal":
					var destination = tokens[3]
					var portal_landing = "default"
					if tokens.size() > 4:
						portal_landing = tokens[4]
					#This is just how you make an Area. I don't know why. It works.
					var obj = Area2D.new()
					var coll_shape = CollisionShape2D.new()
					var rect = RectangleShape2D.new()
					rect.set_extents(Vector2(10, 10))
					coll_shape.set_shape(rect)
					obj.add_child(coll_shape)
					obj.set_meta('landing', portal_landing)
					
					#add_child(obj)
					future_children.push_back(obj)
					future_portals.push_back(obj)
					obj.set_global_position(Vector2(tokens[1], tokens[2]))
					obj.set_name(destination)
					obj.add_to_group("Portals")
				"landing":
					current_landings[tokens[1]] = Vector2(tokens[2], tokens[3])
		if not saved_entities.empty():
			future_entities = saved_entities
			future_children = saved_entities.duplicate(true)
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
			if(o.conversable):
				o.connect("desired_conversation", self, "_handle_conversation")

		#Connect all portals to the portal_director
		for o in future_portals:
			o.connect("body_entered", self, "portal_director", [o.get_name(), o.get_meta("landing")])
	
	if landing != "default" and current_landings.has(landing):
		player.set_global_position(current_landings[landing])
		player.stop()
	
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

# Currently just a very simple signal handler
func portal_director(obj : AdvThing, destination : String, landing="default"):
	obj.use_portal(destination, landing)

#Mostly deals with saving the current locale
func change_scene(destination, landing="default", saved_entities = []):
	var delete_list = []
	#delete_list.push_back(background.texture)
	for o in get_tree().get_nodes_in_group("Entities"):
		if not (o is Player):
			self.call_deferred("remove_child", o)
			delete_list.push_back(o)
			o.remove_from_group("Entities")
	for o in get_tree().get_nodes_in_group("Portals"):
		self.call_deferred("remove_child", o)
		delete_list.push_back(o)
		o.remove_from_group("Portals")
	global.live_locales[current_locale] = {'nodes': delete_list, 'landings': current_landings, 'background': background.texture}

	#for o in delete_list:
		#o.queue_free()
	delete_list = []

	self.call_deferred("load_locale", destination, landing, saved_entities)#load_locale(destination)

func save_game(gamename="savegame"):
	var save_game = File.new()
	save_game.open("res://saves/savegame.save", File.WRITE)
	var scene_data = {
		'locale': current_locale
	}
	save_game.store_line(to_json(scene_data))
	var save_nodes = get_tree().get_nodes_in_group("Entities")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("serialize"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("serialize")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://saves/savegame.save"):
		return # Error! We don't have a save to load.
	var saved_entities = []

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("res://saves/savegame.save", File.READ)
	
	var locale = parse_json(save_game.get_line())['locale']
	#print(locale)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		if not global.scenes.has(node_data["thing_name"]):
			global.scenes[node_data["thing_name"]] = load("res://entities/" + node_data["thing_name"] + ".tscn")
		var obj = global.scenes[node_data["thing_name"]].instance() as AdvThing
		#get_node(node_data["parent"]).add_child(new_object)
		obj.deserialize(node_data)
		#new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
		
		if node_data["thing_name"] == "Player":
			for prop in ['global_transform', 'visible', 'light_mask', 'z_index', 'collision_layer', 'collision_mask', 'stationary', 'id', 'grabbable', 'queue', 'current', 'path', 'goal', 'velocity']:
				player[prop] = obj[prop]
		else:
			saved_entities.append(obj)
		# Now we set the remaining variables.
		#for i in node_data.keys():
		#	if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
		#		continue
		#	new_object.set(i, node_data[i])

	save_game.close()
	change_scene(locale, "default", saved_entities)
