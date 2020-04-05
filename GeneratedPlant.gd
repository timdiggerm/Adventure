extends Node2D

var rules = []
var start_string = ""
var angle = 20.0
var branches = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var lsystem = generateTree('basic', 300, 300, 6) as String
	#print(ltree)
	var tree = parseLSystemToTree(lsystem) as Dictionary
	#print(tree)
	parseTreeToBranches(tree, Vector2(200, 200), 180)
	

func _draw():
	for b in branches:
		draw_line(b['start'], b['end'], Color(0,0,0), 1)
	#draw_line(Vector2(0,0), Vector2(100, 10), Color(.25, .5, .75), 5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func parseTreeToBranches(stem : Dictionary, start_coord : Vector2, angle : float):
	var new_angle = angle+stem['angle']
	var end_coord = Vector2(0, 1).rotated(deg2rad(new_angle)) * stem['length'] + start_coord
	var branch = {'start': start_coord, 'end': end_coord}
	branches.push_back(branch)
	for s in stem['children']:
		parseTreeToBranches(s, end_coord, new_angle)

func parseLSystemToTree(lsystem : String):
	var branch_stack = []
	var curr_branch = {'children':[], 'parent':null, 'length':0, 'angle':0.0}
	var root = curr_branch
	for c in lsystem:
		match c:
			'F':
				curr_branch['length'] += 1
			'+':
				curr_branch['angle'] += angle
			'-':
				curr_branch['angle'] -= angle
			'[':
				var new_branch = {'children':[], 'parent':curr_branch, 'length':0, 'angle':0.0}
				curr_branch['children'].push_back(new_branch)
				branch_stack.push_back(curr_branch)
				curr_branch = new_branch
			']':
				var old_branch = branch_stack.pop_back()
				curr_branch = {'children':[], 'parent':old_branch, 'length':0, 'angle':0.0}
				old_branch['children'].push_back(curr_branch)
	return root


#L-System code below
func generateTree(name, x, y, age):
	loadRules(name)
	var lsystem = createLSystem(age, start_string) as String
	return lsystem

func loadRules(filename):
	var file = File.new()
	file.open("res://plants/" + filename + ".pln", File.READ)
	var content = Array(file.get_as_text().split("\n"))
	file.close()
	start_string = content.pop_front()
	angle = float(content.pop_front())
	for line in content:
		rules.append(line.split('>'))

func applyRules(lhch):
	var rhstr = lhch
	for rule in rules:
		if lhch == rule[0]:
			rhstr = rule[1]
	return rhstr

func processString(oldStr):
	var newstr = ""
	for ch in oldStr:
		newstr = newstr + applyRules(ch)
	return newstr

func createLSystem(numIters,axiom):
	var startString = axiom
	var endString = ""
	for i in range(numIters):
		endString = processString(startString)
		startString = endString
	return endString


