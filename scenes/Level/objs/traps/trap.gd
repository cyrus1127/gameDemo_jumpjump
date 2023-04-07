class_name TrapObj
extends Area2D

signal player_collap

enum ActionType {T1,T2,T3,T4,T5}

export var min_speed = 20
export var max_speed = 200
export (ActionType) var curActType
export (bool) var auto_move = false

var speedFraction = 10
export var speed = 400

var doPause = false

var animationSequance = []
var animationSeqIdx = 0
var isPlayerInside = false


# Called when the node enters the scene tree for the first time.
func _ready():
	setType(curActType)
	
	# set auto_move 
	if auto_move : 
		# do set the force
		pass
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
#	if !doPause :
#		$AnimatedSprite.play()
	pass

func getMoveSpeed(level):
	var spDiff = max_speed - min_speed
	var stepLength = spDiff / speedFraction
	return min_speed + stepLength * (level -1)

func setFlip(needFlip):
	$AnimatedSprite.flip_h = needFlip

func _on_VisibilityNotifier2D_screen_exited():
#	killed()
	pass # Replace with function body.

func killed():
	queue_free()

func getShape():
	return $CollisionShape2D.shape
	
func getShapeTranf():
	return $CollisionShape2D.transform

func setType(nType) -> void:
	if  curActType != nType:
		curActType = nType
	var mob_types = $AnimatedSprite.frames.get_animation_names() # get full list of animation
	if curActType == ActionType.T1 || curActType == ActionType.T2 : 
		$AnimatedSprite._set_playing(false)
		$AnimatedSprite.set_frame(0)
	else : 
		$AnimatedSprite._set_playing(true)
	$AnimatedSprite.animation = mob_types[curActType]   # do random animation 	

func updateAnimation():
	
	pass


func _on_AnimatedSprite_animation_finished():
	if curActType == ActionType.T1 || curActType == ActionType.T2 :
		if isPlayerInside :
			emit_signal("player_collap")
			killed()
			
	pass # Replace with function body.


func _on_TriggerArea_body_entered(body):
	var player := body as KinematicBody2D
	if player :
		isPlayerInside = true
		if curActType == ActionType.T1 || curActType == ActionType.T2 :
			$AnimatedSprite.play()
		else:
			emit_signal("player_collap")
	pass # Replace with function body.


func _on_TriggerArea_body_exited(body):
	var player := body as KinematicBody2D
	if player :
		isPlayerInside = false
	pass # Replace with function body.

