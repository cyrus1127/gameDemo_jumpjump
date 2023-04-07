class_name EnemyObj
extends RigidBody2D

signal player_collap

enum ActionType {Idle , Move , RangeAttack , CloseAttack}

export var min_speed = 20
export var max_speed = 200
export (ActionType) var curActType = ActionType.Idle
export (bool) var auto_move = false

var speedFraction = 10
export var speed = 400
var velocity = Vector2()

var gravity = 1200
var doPause = false

var animationSequance = []
var animationSeqIdx = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite.frames.get_animation_names() # get full list of animation
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]   # do random animation 
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
		
	if curActType == ActionType.Idle || curActType == ActionType.Move :
		animationSequance = ["idle"]
		$AnimatedSprite.animation = "idle"
	if  curActType == ActionType.CloseAttack:
		animationSequance = ["idle" , "attack_1"]
		
	if  curActType == ActionType.RangeAttack:
		animationSequance = ["idle" , "attack_2"]

func updateAnimation():
	
	pass


func _on_AnimatedSprite_animation_finished():
	
	if animationSequance.size() > 0 : 
#		if animationSeqIdx == 0 :
#			yield(get_tree().create_timer(5),"timeout")
#			animationSeqIdx += 1
#		else :
			#check current animation frame is done
#			var fcont = $AnimatedSprite.frame.get_frame_count(animationSequance[animationSeqIdx])
#			if $AnimatedSprite.frame.frame == fcont -1:

		animationSeqIdx += 1	
		if animationSeqIdx >= animationSequance.size():
			animationSeqIdx = 0		
		#set next aniamtion
		$AnimatedSprite.animation == animationSequance[animationSeqIdx]
	
	pass # Replace with function body.
