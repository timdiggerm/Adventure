extends Node

var player : KinematicBody2D
var nav_system : NavigationSystem
var action_bar : HBoxContainer
var dialog_box : PopupDialog

func _ready():
	player = get_node("Player") as KinematicBody2D
	nav_system = get_node("NavigationSystem") as NavigationSystem
	dialog_box = get_node("Dialog") as PopupDialog
	
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
		#print("MainScene Handler")
		if global.cursor_state == global.CURSOR_STATES.WALK:
			player.new_path(nav_system.get_nav_path(player.global_position,event.position))

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

func _on_ActionBar_viewInventory():
	#show inventory screen
	pass # Replace with function body.
