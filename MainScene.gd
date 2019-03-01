extends Node

var player
var nav_system
var action_bar
var dialog_box

func _ready():
	player = get_node("Player")
	nav_system = get_node("NavigationSystem")
	dialog_box = get_node("Dialog")
	
	for o in get_tree().get_nodes_in_group("Entities"):
		#connect all entities' signals to appropriate callbacks
		o.connect("message", self, "_handle_message")
		#then add them to the nav system if it's a stationary object
		if(o.stationary):
			nav_system.add_collision_box(o)
	
	nav_system.reload_nav()

#input handling, if no gui elements have handled the event
func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		if global.cursor_state == global.WALK:
			player.new_path(nav_system.get_path(player.global_position,event.position))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_ActionBar_hand():
	global.cursor_state = global.TOUCH

func _on_ActionBar_look():
	global.cursor_state = global.LOOK

func _on_ActionBar_walk():
	global.cursor_state = global.WALK
	
func _handle_message(msg):
	dialog_box.displayMessage(msg)
	#print(msg)