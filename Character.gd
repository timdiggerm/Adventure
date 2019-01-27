extends KinematicBody2D

export (int) var speed = 50

var path = []
var goal = Vector2(0,0)
var velocity = Vector2()

func _ready():
	goal = self.global_position
	pass

func _process(delta):
	if abs(goal.distance_to(self.global_position)) < 1:
		if path.size() > 0:
			goal = path.pop_front()
		else:
			velocity = 0
	else:
		velocity = (goal - self.global_position).normalized() * speed
		move_and_slide(velocity)
	pass

func new_path(new_path):
	goal = self.global_position
	path.clear()
	path.push_back(self.global_position)
	for p in new_path:
		path.push_back(p)