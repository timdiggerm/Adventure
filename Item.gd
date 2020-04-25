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
