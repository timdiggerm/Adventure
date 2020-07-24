extends AdvThing

class_name Player

signal changescene(destination)

func _ready():
	stationary = false
	id = -1
	thing_name = "Player"
	speed = 100
	set_init_hh()

func _on_ClickBox_clicked() -> void:
	match global.cursor_state:
		global.CURSOR_STATES.HAND:
			emit_signal("message", "How do you feel?")
		global.CURSOR_STATES.LOOK:
			emit_signal("message", "Hard to do without a mirror")
		_:
			._on_ClickBox_clicked()

func use_portal(obj, destination):
	print("Prepare to travel to ", destination)
	emit_signal("changescene", destination)
