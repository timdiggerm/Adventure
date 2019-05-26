extends AdvThing

class_name Player

export (int) var speed = 50

var path : Array = []
var goal : Vector2 = Vector2(0,0)
var velocity : Vector2 = Vector2()

func _ready():
	goal = self.global_position
	stationary = false
	id = -1
	set_init_hh()

func _process(delta):
	if abs(goal.distance_to(self.global_position)) < 1:
		if path.size() > 0:
			goal = path.pop_front()
		else:
			velocity = Vector2(0,0)
	else:
		velocity = (goal - self.global_position).normalized() * speed
		move_and_slide(velocity)
	._process(delta)

func new_path(new_path) -> void:
	goal = self.global_position
	path.clear()
	path.push_back(self.global_position)
	for p in new_path:
		path.push_back(p)
		
func _on_ClickBox_clicked() -> void:
	match global.cursor_state:
		global.CURSOR_STATES.WALK:
			pass
		global.CURSOR_STATES.HAND:
			emit_signal("message", "How do you feel?")
		global.CURSOR_STATES.LOOK:
			emit_signal("message", "Hard to do without a mirror")
		global.CURSOR_STATES.SMELL:
			pass
		global.CURSOR_STATES.TASTE:
			pass
		global.CURSOR_STATES.LISTEN:
			pass