extends AdvThing

class_name Player

signal changescene(destination, landing)

func _ready():
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

func use_portal(obj, destination, landing="default"):
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


