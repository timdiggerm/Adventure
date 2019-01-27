extends Navigation2D
#var path = []
#var font = null
#var drawTouch = false
#var touchPos = Vector2(0,0)
#var closestPos = Vector2(0,0)
#
#func _ready():
#	font = load("res://arial.fnt")
#	set_process_input(true)
#
#func _draw():
#	if(path.size()):
#		for i in range(path.size()):
#			draw_string(font,Vector2(path[i].x,path[i].y - 20),str(i+1))
#			draw_circle(path[i],10,Color(1,1,1))
#
#		if(drawTouch):
#			draw_circle(touchPos,10,Color(0,1,0))
#			draw_circle(closestPos,10,Color(0,1,0))
#
#
