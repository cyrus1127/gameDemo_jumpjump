class_name EnemyObj
extends RigidBody2D

signal player_collap

enum ActionType {Idle , Move , RangeAttack , CloseAttack, Death}

export var baseLevel = 1
export var baseExp = 10
export var min_speed = 20
export var max_speed = 200
export (ActionType) var curActType = ActionType.Idle
export (bool) var auto_move = false
export (Array) var dropItems
export (PackedScene) var expGenAnim
export (PackedScene) var dropItem

var speedFraction = 10
export var speed = 400
var velocity = Vector2()

var gravity = 1200
var doPause = false

var animationSequance = []
var animationSeqIdx = 0

var isKilled = false


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

func setStageLevel(nStageLv):
	nStageLv
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#check killed animation status
	if isKilled && $AnimatedSprite.get_frame() == ($AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) -1):
		killed()
	
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
		
	if curActType == ActionType.Death:
		animationSequance = ["death" ]
		$AnimatedSprite.animation = "death"
		$AnimatedSprite.set_frame(0)

func updateAnimation():
	
	pass

func _getExp(playerLv):
	if playerLv <= baseLevel :
		var nExp = baseExp
		for diff in range(0, (baseLevel - playerLv)):
			nExp += ((diff+1) - log(diff+1)) * baseExp
		return nExp
	
	return 0

func processKillDropItems(playerLv):
	
	if !isKilled:
		isKilled = true
		setType(ActionType.Death)
		
		var dropCount = 1 + randi() % 4
		var curParent = get_parent()
		var expPass = _getExp(playerLv)
		
#		$AnimatedSprite.hide()
		$CollisionShape2D.queue_free()
		
		if curParent :
			if expGenAnim : 
				var nAnimLabel = expGenAnim.instance() as ExpGetAnim
				nAnimLabel.position = position # + Vector2(0, 50)
				curParent.add_child(nAnimLabel)
				nAnimLabel.startWithText(expPass)
			
			print('drop count :' + str(dropCount))
			while dropCount > 0 :
				var picktype = randi() % 3
				var nItem = dropItem.instance()
				match (picktype):
					0 : #coins
						(nItem as ItemObj).setItemDetail()
					1 :
						var items = GLOBAL.items_food_data_all["values"]
						(nItem as ItemObj).setItemDetail( items[randi() % items.size()])
					2 : 
						print('drop eq')
						var items = GLOBAL.items_equipment_data_all["values"]
						(nItem as ItemObj).setItemDetail( items[randi() % items.size()])

				curParent.add_child(nItem)
				nItem.position = position
				dropCount -= 1
				
		return expPass ## end of the function , pass the find exp to level logic
	return 0


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
