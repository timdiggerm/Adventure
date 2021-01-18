extends AdvThing

class_name Character

signal desired_conversation(character)

func _init():
	stationary = false
	grabbable = false
	conversable = true
	thing_name = "Character"
	
func _process(delta):
	if queue.size() == 0:
		move(get_global_position() + Vector2(float(randi() % 100 - 50), float(randi() % 100 - 50)))
	._process(delta)

func _on_ClickBox_clicked() -> void:
	#print("HELLO")
	match global.cursor_state:
		global.CURSOR_STATES.TALK:
			emit_signal("desired_conversation", self)
		_: #for everything else, defer to parent function
			._on_ClickBox_clicked()	

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
