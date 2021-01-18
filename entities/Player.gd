extends AdvThing

class_name Player

signal changescene(destination, landing)

func _init():
	stationary = false
	id = -1
	thing_name = "Player"
	speed = 100
	#set_init_hh()

func _on_ClickBox_clicked() -> void:
	match global.cursor_state:
		global.CURSOR_STATES.HAND:
			emit_signal("message", "How do you feel?")
		global.CURSOR_STATES.LOOK:
			emit_signal("message", "Hard to do without a mirror")
		_:
			._on_ClickBox_clicked()

func use_portal(destination, landing="default"):
	emit_signal("changescene", destination, landing)

func get_height():
	return 50

func movement_animation_control() -> void:
	var normalized = velocity.normalized()
	if normalized.x == 0 and normalized.y == 0:
		sprite.stop()
		sprite.set_frame(0)
	else:
		if normalized.x > -sqrt(2)/2 and normalized.x < sqrt(2)/2:
			if normalized.y > 0:
				sprite.set_animation("walkForward")
			else:
				sprite.set_animation("walkBackward")
		else: 
			if normalized.x < 0:
				sprite.set_animation("walkLeft")
			else:
				sprite.set_animation("walkRight")
		sprite.play()

func grab(target):
	var p = get_global_position()
	var o = target.get_global_position()
	var v = p - o
	var goal = o + v / v.length() * (target.rough_radius + rough_radius)*2/3
	move_now(goal)
	queue.push_back({
		"type":"grab",
		"target":target,
	})

func use_item(obj):
	#Everything after this only happens if the items _can_ interact
	var v = get_global_position() - obj.get_global_position()
	var goal = obj.get_global_position() + v / v.length() * (obj.rough_radius + rough_radius)
	queue.clear()
	current = {}
	
	#Check if the obj and the item require proximity. If so, 
	#add movement to the player's queue (see _handle_grab).
	if global.current_item.requires_proximity(obj):
		move(goal)
		
	queue.push_back({
		"type":"item_use",
		"obj":obj,
		"item":global.current_item,
	})
