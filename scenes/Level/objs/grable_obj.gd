class_name Grable_obj

extends RigidBody2D

signal is_connected(body)
signal is_disconnected(body)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var base_weight = 50
var on_grabbing = false
var org_pos = Vector2.ZERO
var isLastOfChain = false

# Called when the node enters the scene tree for the first time.
func _ready():
	resetWeight()
	org_pos = position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _integrate_forces(state):
#	state.add_central_force(Vector2)
	if on_grabbing :
		var moveX = abs(linear_velocity.x)
	else :
		if abs(linear_velocity.x) > 0.5 && get_applied_force().y < 15000:
			state.add_central_force(Vector2(0, weight * 0.25))
		elif get_applied_force().y >= 15000 :
			set_applied_force(Vector2.ZERO)
		
	pass
	
func isChainEnd():
	return isLastOfChain

func isPlayer(body):
	var player := body as KinematicBody2D
	if player && player.name.match(GLOBAL.playerObjName): 
		return true
	
	return false
	
func pauseCollision():
#	$Area2D.set_deferred("monitoring",false)
#	set_deferred("mode",RigidBody2D.MODE_STATIC)
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
#	gravity_scale = 1
	pass

func resumeCollision():
#	$Area2D.set_deferred("monitoring",true)
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
#	set_deferred("mode",RigidBody2D.MODE_RIGID)
#	gravity_scale = 1
	pass
	
func setShareWeight(n_weight):
	weight = n_weight

func resetWeight():
	weight = base_weight

func doDisconnect():
	gravity_scale = 1
	emit_signal("is_disconnected",self)
	weight = base_weight
	resumeCollision()
	pass

func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if isPlayer(body):
		if (body as PlayerBody).grabAndHold(self):
			weight = (body as PlayerBody).gravity
			emit_signal("is_connected", self)
			on_grabbing = true
#			pauseCollision()		
	pass # Replace with function body.



func _on_Area2D_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if isPlayer(body):
#		doDisconnect()
		resetWeight()
		on_grabbing = false
	pass # Replace with function body.
