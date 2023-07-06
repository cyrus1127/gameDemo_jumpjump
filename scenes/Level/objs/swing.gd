extends Node2D


var childs = []

func _ready():
	
	# find and record the grable object 
	for index in get_child_count():
		var child := get_child(index) as Grable_obj
		if child :
			childs.push_back(child)
	
	if childs.size() > 0:
		(childs[childs.size() -1] as Grable_obj).isLastOfChain = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TraggableObj_is_connected(body):
	var weight = (body as RigidBody2D).weight
	for child in childs:
#		if child != body :
		(child as Grable_obj).pauseCollision()
		(child as RigidBody2D).weight = weight / (childs.size()-1)
	pass # Replace with function body.

func _on_TraggableObj_is_disconnected(chainChild):
	var curIdx = childs.find(chainChild)
			
	yield(get_tree().create_timer(3),"timeout")
	for child in childs:
#		if child != chainChild :
		(child as Grable_obj).resumeCollision()
		(child as Grable_obj).resetWeight()
		
	pass # Replace with function body.

