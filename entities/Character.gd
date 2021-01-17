extends AdvThing

class_name Character

func _ready():
	stationary = false
	grabbable = false
	thing_name = "Character"
	
func _process(delta):
	if queue.size() == 0:
		move(get_global_position() + Vector2(float(randi() % 100 - 50), float(randi() % 100 - 50)))
	._process(delta)

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
