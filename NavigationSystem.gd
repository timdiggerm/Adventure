extends Node2D

class_name NavigationSystem

var characterNav : Navigation2D
var navPolys : Array

func _ready():
	characterNav = get_node("CharacterNav") as Navigation2D
	navPolys = []

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func get_nav_path(obj1 : Vector2, obj2 : Vector2) -> PoolVector2Array:
	return characterNav.get_simple_path(obj1,obj2)

func add_collision_box(obj : AdvThing) -> void:
	var points = []
	var box = obj.get_collision_box()
	var shape = obj.get_collision_shape()
	if shape is RectangleShape2D:
		points.append(box.global_position + Vector2(shape.extents.x, shape.extents.y) * box.scale * 1.5)
		points.append(box.global_position + Vector2(-shape.extents.x, shape.extents.y) * box.scale * 1.5)
		points.append(box.global_position + Vector2(-shape.extents.x, -shape.extents.y) * box.scale * 1.5)
		points.append(box.global_position + Vector2(shape.extents.x, -shape.extents.y) * box.scale * 1.5)
	
	(characterNav.get_child(0) as NavigationPolygonInstance).navpoly.add_outline(points)
	(characterNav.get_child(0) as NavigationPolygonInstance).navpoly.make_polygons_from_outlines()

func reload_nav() -> void:
	(characterNav.get_child(0) as NavigationPolygonInstance).enabled = false
	(characterNav.get_child(0) as NavigationPolygonInstance).enabled = true

#func add_nav_map(map):
#	var t = Transform2D(Vector2(0,0), Vector2(0,0), Vector2(0,0))
#	print(map)
#	#var id = characterNav.navpoly_add(map, t)
#	var id = 0
#	navPolys.append(id)
#	return id

#func add_collision_box(obj):
#	var shape = obj.get_collision_box()
#	characterNav.get_child(0).navpoly.add_outline_at_index(PoolVector2Array([Vector2(obj.global_position.x + shape.position.x - shape.shape.extents[0], obj.global_position.y + shape.position.y - shape.shape.extents[1]), 
#		Vector2(obj.global_position.x + shape.position.x + shape.shape.extents[0], obj.global_position.y + shape.position.y - shape.shape.extents[1]), 
#		Vector2(obj.global_position.x + shape.position.x + shape.shape.extents[0], obj.global_position.y + shape.position.y + shape.shape.extents[1]), 
#		Vector2(obj.global_position.x + shape.position.x - shape.shape.extents[0], obj.global_position.y + shape.position.y + shape.shape.extents[1])]), -1)
#	characterNav.get_child(0).navpoly.make_polygons_from_outlines()