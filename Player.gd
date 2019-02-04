extends "res://Object.gd"

export (int) var speed = 50

var path = []
var goal = Vector2(0,0)
var velocity = Vector2()

func _ready():
	goal = self.global_position
	hh = get_child(1).texture.get_height()/2

func _process(delta):
	if abs(goal.distance_to(self.global_position)) < 1:
		if path.size() > 0:
			goal = path.pop_front()
		else:
			velocity = 0
	else:
		velocity = (goal - self.global_position).normalized() * speed
		move_and_slide(velocity)
	._process(delta)

func new_path(new_path):
	goal = self.global_position
	path.clear()
	path.push_back(self.global_position)
	for p in new_path:
		path.push_back(p)
		
func _on_ClickBox_clicked():
	match global.cursor_state:
		global.WALK:
			pass
		global.HAND:
			emit_signal("message", "How do you feel?")
		global.LOOK:
			emit_signal("message", "Hard to do without a mirror")
		global.SMELL:
			pass
		global.TASTE:
			pass
		global.LISTEN:
			pass
