class_name EnemyObj
extends KinematicBody2D

enum ActionType {Idle , Move , RangeAttack , CloseAttack, TakeHit, Death}
enum Kind {minion, boss}

export var baseLevel = 1
export var baseExp = 10
export var min_speed = 20
export var max_speed = 200
var hp = 10
var atk = 1
var myName = ""
var base_ItemDrop = 1
var base_ItemDrop_rand = 4

export (ActionType) var curActType = ActionType.Idle
export (PackedScene) var expGenAnim
export (PackedScene) var dropItem
export (Array) var dropItems

var curKind = Kind.minion
var auto_move = true
var auto_move_await_time = 3;
var mvAwait_cntDown = -1;
var idle_mvAwait_cntDown = -1;

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
#	var mob_types = $AnimatedSprite.frames.get_animation_names() # get full list of animation
#	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]   # do random animation 
	setAnimType(curActType)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#check killed animation status
	if isKilled && $AnimatedSprite.get_frame() == ($AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) -1):
		killed()
	
	pass

func _physics_process(delta):
	
	if auto_move :
		if !is_on_floor():
			velocity.y += gravity * delta
			velocity = move_and_slide(velocity,Vector2(0, -1))
		else:
			if mvAwait_cntDown < 0:
				var nx = -min_speed
				if !$AnimatedSprite.is_flipped_h() :
					nx = min_speed 
				velocity.x = nx	
			else :
				mvAwait_cntDown -= delta
				velocity.x = 0
				if mvAwait_cntDown <= 0 && curActType == ActionType.Idle:
					if randi() % 10 >= 8 :
						_doChangeDirection()
		
#		velocity = move_and_slide(velocity,Vector2(0, -1))
			var kineCollis =  move_and_collide(Vector2(velocity.x , 4),false,false)
			if kineCollis && !kineCollis.collider.get_class().match("TileMap") :
				if isPlayer(kineCollis.collider):
					print("hit player  ")	
	pass

func getKind():
	return curKind

func setStageLevel(nStageLv):
	nStageLv
	pass
	
func setFlip(needFlip):
	$AnimatedSprite.flip_h = needFlip
func isFliped():
	return $AnimatedSprite.is_flipped_h()

func setAnimType(nType) -> void:
	if  curActType != nType:
		curActType = nType
		
	if curActType == ActionType.Idle || curActType == ActionType.Move :
		animationSequance = ["idle"]
		$AnimatedSprite.animation = "idle"
		
	if  curActType == ActionType.CloseAttack:
		animationSequance = ["attack_1"]
		$AnimatedSprite.animation = "attack_1"
		mvAwait_cntDown = auto_move_await_time
		
	if  curActType == ActionType.RangeAttack:
		animationSequance = ["attack_2"]
		$AnimatedSprite.animation = "attack_2"
		mvAwait_cntDown = auto_move_await_time
		
	if curActType == ActionType.TakeHit:
		animationSequance = ["take_hit"]
		$AnimatedSprite.animation = "take_hit"
		$AnimatedSprite.set_frame(0)
		mvAwait_cntDown = auto_move_await_time
		
	if curActType == ActionType.Death:
		animationSequance = ["death" ]
		$AnimatedSprite.animation = "death"
		$AnimatedSprite.set_frame(0)

func getMoveSpeed(level):
	var spDiff = max_speed - min_speed
	var stepLength = spDiff / speedFraction
	return min_speed + stepLength * (level -1)

func getShape():
	return $CollisionShape2D.shape
	
func getShapeTranf():
	return $CollisionShape2D.transform

func _getExp(playerLv):
	if playerLv <= baseLevel :
		var nExp = baseExp
		for diff in range(0, (baseLevel - playerLv)):
			nExp += ((diff+1) - log(diff+1)) * baseExp
		return nExp
	
	return 0

func killed():
	queue_free()

func takeHit(playerLv ,playATK):
	if hp > 0 && (curActType != ActionType.TakeHit && curActType != ActionType.CloseAttack): 
		if hp - playATK <= 0:
			return _processKillDropItems(playerLv) 
		else :
			hp -= playATK
			setAnimType(ActionType.TakeHit)
			
			var curParent = get_parent()
			if curParent :
				var nAnimLabel = expGenAnim.instance() as ExpGetAnim
				nAnimLabel.position = position + Vector2(0, -50)
				curParent.add_child(nAnimLabel)
				nAnimLabel.startAsHPDeduct(-playATK)
	
	return -1

func _processKillDropItems(playerLv):
	
	if !isKilled:
		isKilled = true
		auto_move = false # if it was true before
		setAnimType(ActionType.Death)
		
		var dropCount = base_ItemDrop + randi() % base_ItemDrop_rand
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
				nItem.position = position + Vector2(randi()%50, -50 - randi()%50 )
				(nItem as ItemObj).setOneTimeEmit()
				dropCount -= 1
				
		return expPass ## end of the function , pass the find exp to level logic
	return 0

func isPlayer(body):
	var player := body as KinematicBody2D
	if player && player.name.match(GLOBAL.playerObjName): 
		return true
	
	return false

#==-=-=-=-=-=-=- delegate 

func _on_AnimatedSprite_animation_finished():
	
	if curActType != ActionType.Idle : 
		setAnimType(ActionType.Idle)
		mvAwait_cntDown = 0
	else :
		if randi() % 10 >= 8 && mvAwait_cntDown <= 0:
			mvAwait_cntDown = randi() % auto_move_await_time
			_doChangeDirection()	
			
			
#		if animationSequance.size() > 0 : 
#		#		if animationSeqIdx == 0 :
#		#			yield(get_tree().create_timer(5),"timeout")
#		#			animationSeqIdx += 1
#		#		else :
#				#check current animation frame is done
#		#			var fcont = $AnimatedSprite.frame.get_frame_count(animationSequance[animationSeqIdx])
#		#			if $AnimatedSprite.frame.frame == fcont -1:
#
#			animationSeqIdx += 1	
#			if animationSeqIdx >= animationSequance.size():
#				animationSeqIdx = 0		
#			#set next aniamtion
#			$AnimatedSprite.animation == animationSequance[animationSeqIdx]
	
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if auto_move : 
		var tileType := body as TileMap
		var enmeyType := body as EnemyObj
		var playerType = isPlayer(body)
		if tileType || (enmeyType && body != self) :
			_doChangeDirection()
#		elif playerType:
#			mvAwait_cntDown = auto_move_await_time
	pass # Replace with function body.

func _doChangeDirection():
	setFlip(!$AnimatedSprite.is_flipped_h())
	if $AnimatedSprite.is_flipped_h():
		$Area_Direction.rotation_degrees = 180
	else :
		$Area_Direction.rotation_degrees = 0
