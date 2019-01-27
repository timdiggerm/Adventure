extends Node

var cursor_state
var character
var nav_system
var action_bar

func _ready():
	cursor_state = global.WALK
	character = get_node("Character")
	nav_system = get_node("NavigationSystem")
	#nav_system.add_collision_box(get_node("Object"))
	pass

#input handling, if no gui elements have handled the event
func _unhandled_input(event):
	if event is InputEventMouseButton and not event.pressed:
		if cursor_state == global.WALK:
			character.new_path(nav_system.get_path(character.global_position,event.position))

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_ActionBar_hand():
	cursor_state = global.TOUCH

func _on_ActionBar_look():
	cursor_state = global.LOOK

func _on_ActionBar_walk():
	cursor_state = global.WALK

func get_cursor_state():
	return cursor_state