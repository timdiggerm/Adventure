extends AdvThing

class_name Player


func _ready():
	stationary = false
	id = -1
	thing_name = "Player"
	set_init_hh()

func _on_ClickBox_clicked() -> void:
	match global.cursor_state:
		global.CURSOR_STATES.HAND:
			emit_signal("message", "How do you feel?")
		global.CURSOR_STATES.LOOK:
			emit_signal("message", "Hard to do without a mirror")
		_:
			._on_ClickBox_clicked()
