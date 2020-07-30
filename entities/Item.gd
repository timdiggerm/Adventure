extends AdvThing

class_name Item

signal desired_grab(obj)

func _init():
	grabbable = true
	thing_name = "item"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_ClickBox_clicked() -> void:
	#print("HELLO")
	match global.cursor_state:
		global.CURSOR_STATES.HAND:
			emit_signal("desired_grab", self)
		_: #for everything else, defer to parent function
			._on_ClickBox_clicked()
			
func get_item_texture() -> Texture:
	return get_child(2).frames.get_frame("default", 0)

#func set_item_texture(texture) -> void:
	#get_child(2).texture = texture

func can_interact(target) -> bool:
	#Child classes should override this
	#to check if the target object and the
	#item can have a meaningful interaction
	return true

func requires_proximity(target) -> bool:
	#Child classes should override this
	#to check if the target object and the
	#item interacting requires proximity
	return true
