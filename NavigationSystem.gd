extends Node2D

var characterNav

func _ready():
	characterNav = get_node("CharacterNav")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func get_path(obj1, obj2):
	return characterNav.get_simple_path(obj1,obj2)

#func add_collision_box(obj):
#	var shape = obj.get_collision_box()
#	characterNav.get_child(0).navpoly.add_outline_at_index(PoolVector2Array([Vector2(obj.global_position.x + shape.position.x - shape.shape.extents[0], obj.global_position.y + shape.position.y - shape.shape.extents[1]), 
#		Vector2(obj.global_position.x + shape.position.x + shape.shape.extents[0], obj.global_position.y + shape.position.y - shape.shape.extents[1]), 
#		Vector2(obj.global_position.x + shape.position.x + shape.shape.extents[0], obj.global_position.y + shape.position.y + shape.shape.extents[1]), 
#		Vector2(obj.global_position.x + shape.position.x - shape.shape.extents[0], obj.global_position.y + shape.position.y + shape.shape.extents[1])]), -1)
#	characterNav.get_child(0).navpoly.make_polygons_from_outlines()