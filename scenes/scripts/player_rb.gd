class_name PlayerBody
extends KinematicBody2D

signal hit_monster
signal item_touch
signal monster_touch
signal hit_check_point
signal hit_info_board
signal out_bound

# Declare member variables here. Examples:
export var speed = 400
export (int) var jump_speed = -500
export (int) var gravity = 1200
export (bool) var dropEnable = false
export (bool) var isTouchScreenOn = false
export (PackedScene) var move_fx

#var move_direction:Vector2 = Vector2.RIGHT
var velocity = Vector2()
var jumping = false
var jumpVecCosumming = 0
var doPause = false
var onGrabBodyObj = null
var onGrabBodyOffset = Vector2.ZERO

var takingHit = false

var isOnAttackAction = false
var isAttackActiving = false
var isFaseToLeft = false
var enemybody_in = false
var inAtkZoneMob
var inAtkZoneMobs_L = []
var inAtkZoneMobs_R = []

var offset_counting = 0
var prev_pos = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func start(pos = null):
	if pos : 
		position = pos
		prev_pos = pos
	onGrabBodyObj = null
	resume()
	pass

func resume():
	doPause = false
	$CollisionShape2D.set_deferred("disabled", false)
	pass

func stop():
#	speed = 0
#	jump_speed = 0
#	gravity = 0
	doPause = true
	$CollisionShape2D.set_deferred("disabled", true)
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	
#	$Attack_Area2D/CollisionShape2D_L.set_visible(false)
#	$Attack_Area2D/CollisionShape2D_R .set_visible(false)
	pass # Replace with function body.

func get_mobile_input():
	var move_input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
#			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		0
	).clamped(1) #just in case someone uses buttons - Joystick already returns clamped value
	var down = Input.get_action_strength("ui_down")
	var jump = Input.is_action_pressed("ui_jump") 
	var jump_release = Input.is_action_just_released("ui_jump")
	var attack = Input.is_action_pressed("ui_attack")
	
	if jump and down and dropEnable:
			player_drop_from_curPlatefrom()
	elif jump and !jumping:
			if velocity.y >= 0 && velocity.y <= 10 && jumpVecCosumming == 0: # give some margin
					velocity.y = jump_speed
					jumpVecCosumming += jump_speed
					jumping = true
					GLOBAL.change_sfx("jump")
	#				print("Add jump" + str(velocity))
	#				if is_on_floor():
	#					print("hit the top ?? " + str(velocity))	
			else:
				print("jumping not finished" + str(velocity))
	elif jump_release:
		if jumpVecCosumming < 0:
			jumping = false
			jumpVecCosumming = 0 
	
	if attack || isOnAttackAction:
		doActionAttack()
	else : 
		if velocity.y <= -0.1 || velocity.y >= 0.1:
				cancelAttack()
				$AnimatedSprite.animation = "jump"	
		if move_input.x > 0.3 || move_input.x < -0.3:
			if move_input != Vector2.ZERO: 
				var n_veloc = move_input * speed
				velocity.x = n_veloc.x
		
			var right = move_input.x > 0
			var left = move_input.x < 0

			if velocity.x != 0:
				if  (right || left) :
					cancelAttack()
					$AnimatedSprite.flip_h = left
					isFaseToLeft = left
					if velocity.y == 0:
						$AnimatedSprite.animation = "run"
		
		else :
#			$AnimatedSprite.animation = "idle"
			velocity.x = 0
	
	pass

func get_controller_input():

	velocity.x = 0
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left") 
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_pressed("ui_jump") 
	var jump_release = Input.is_action_just_released("ui_jump")
	var attack = Input.is_action_pressed("ui_attack")
	
	if attack:
		doActionAttack()
#	elif takingHit :
#			$AnimatedSprite.animation = "take_hit"
	else :
		if right: 
			velocity.x += speed
		if left:
			velocity.x -= speed
		if jump and !jumping:
			if velocity.y >= 0 && velocity.y <= 10 && jumpVecCosumming == 0: # give some margin
				velocity.y = jump_speed
				jumpVecCosumming += jump_speed
				jumping = true
				GLOBAL.change_sfx("jump")
#				print("Add jump" + str(velocity))
#				if is_on_floor():
#					print("hit the top ?? " + str(velocity))	
			else:
				print("jumping not finished" + str(velocity))
		if jump_release:
			if jumpVecCosumming < 0:
				jumping = false
				jumpVecCosumming = 0 # reset as button released 
		if down and dropEnable:
			player_drop_from_curPlatefrom()
		
		
		if isOnAttackAction:
#			$AnimatedSprite.animation = "attack_wp1"
			print("")
		elif (Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left")  || (velocity.x > -1 && velocity.x < 1 && velocity.y >= 0)):
			setIdle()
		else:
			if velocity.y != 0:
				cancelAttack()
				$AnimatedSprite.animation = "jump"	
			if velocity.x != 0:
				if  (right || left) :
					cancelAttack()
					$AnimatedSprite.animation = "run"		
					$AnimatedSprite.flip_h = left
					isFaseToLeft = left
			
	pass

func get_onGrab_mobile_input():
	var move_input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
#			Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		0
	).clamped(1) #just in case someone uses buttons - Joystick already returns clamped value
	
	var right = Input.get_action_strength("ui_right")
	var left = Input.get_action_strength("ui_left")
	var up = Input.get_action_strength("ui_up")
	var down = Input.get_action_strength("ui_down")
	var jump = Input.is_action_pressed("ui_jump") 
	var jump_release = Input.is_action_just_released("ui_jump")
	
	if jump && !jumping && onGrabBodyObj :
		releaseGrabbing()
	elif jump_release:
		if jumpVecCosumming < 0:
			jumping = false
			jumpVecCosumming = 0 
	else :
		if up:
			onGrabBodyOffset += Vector2(0,-1)
		if down :
			onGrabBodyOffset += Vector2(0,1)
		if  (right || left) :
			$AnimatedSprite.flip_h = !left
			isFaseToLeft = !left
			if right :
				onGrabBodyOffset.x = 25
			if left :
				onGrabBodyOffset.x = -25
	
	pass
	
#=-=-=-=-=-=-=-=-= extra effect handling =-=-=-=-=-=-=-=-=-=-=-=-
func setIdle():
	$AnimatedSprite.animation = "idle"
	offset_counting = 0 # do reset the offset counting

func addMovingEffect() :
#	print("addMovingEffect : diff ?? " + str(offset_counting))
	
	if move_fx && abs(offset_counting) > 25:
		var nMoveFx = move_fx.instance() as MoveFX
		nMoveFx.position = position + Vector2(offset_counting,0)
		nMoveFx.startAnim()
		get_parent().add_child(nMoveFx)
		offset_counting = 0 # do reset
	pass

#=-=-=-=-=-=-=-=-= action detection handling =-=-=-=-=-=-=-=-=-=-=-=-

func player_drop_from_curPlatefrom():
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.35), "timeout")
	$CollisionShape2D.disabled = false
	pass
	
func doActionAttack():
	
	if !isOnAttackAction:
		$AnimatedSprite.animation = "attack_wp1"
		GLOBAL.change_sfx("attack1")
		isOnAttackAction = true
		velocity.x = 0
#	yield($AnimatedSprite.animation.ends_with("attack_wp1"), "true")
	pass

func cancelAttack():
	isOnAttackAction = false
#	$Attack_Area2D/CollisionShape2D_L.set_visible(false)
#	$Attack_Area2D/CollisionShape2D_R .set_visible(false)

func onHit():
	if !takingHit:
		#force other action stop
		isAttackActiving = false
		isOnAttackAction = false
		
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.animation = "take_hit"
		takingHit = true
		

func _process(delta):	
	
	if isOnAttackAction:
		if 	$AnimatedSprite.animation.begins_with("attack") :
			if $AnimatedSprite.frame == 3 :
				isOnAttackAction = false
				isAttackActiving = false
				setIdle()
			if $AnimatedSprite.frame == 2 :
				if  enemybody_in && is_instance_valid(inAtkZoneMob) :
					emit_signal("hit_monster",inAtkZoneMob)
#			#do reset to idle
	if takingHit :
		if takingHit 	|| $AnimatedSprite.animation.begins_with("take_hit") :
			if $AnimatedSprite.frame == 3 :
				takingHit = false
	
	if $AnimatedSprite.animation.match("run") && prev_pos != position :
		var posDiff = (prev_pos - position)
		if abs(posDiff.x) > 50 :
			prev_pos = position
		else :
			offset_counting += posDiff.x
			prev_pos = position
			addMovingEffect()
	pass

func _physics_process(delta):
	# move itself	
	if !doPause :
		if !takingHit:
			
			if onGrabBodyObj != null:
				if isTouchScreenOn :
					get_onGrab_mobile_input()
				else : 
					get_controller_input()
										
				if onGrabBodyObj != null :
					if onGrabBodyObj.isChainEnd() && onGrabBodyOffset.y > 25:
						releaseGrabbing()
					else :
						velocity = Vector2.ZERO
						var grabPos = onGrabBodyObj.get_global_position()
						position = grabPos + onGrabBodyOffset
					
			else : 
				if isTouchScreenOn :
					get_mobile_input()
				else : 
					get_controller_input()
					
				if !(is_on_floor() && jumping):
					velocity.y += gravity * delta
				velocity = move_and_slide(velocity,Vector2(0, -1))
				
				if velocity.y == 0 && velocity.x == 0 && isTouchScreenOn:
					if !isOnAttackAction && !$AnimatedSprite.animation.begins_with("idle")  :
						setIdle()
pass

func releaseGrabbing():
	onGrabBodyObj.doDisconnect()
	onGrabBodyObj = null

func grabAndHold(bodyToHold) -> bool:
	if onGrabBodyObj == null :
		onGrabBodyObj = bodyToHold
		onGrabBodyOffset = Vector2.ZERO
		return true
	elif onGrabBodyObj == bodyToHold:
		return true
	return false

	
func isEnemyBody(body):
	var obj_item := body as EnemyObj
	if obj_item : 
		return true
	
	return false

func isItemBody(body):
	var obj_item := body as ItemObj
	if obj_item : 
		return true
	
	return false

func isTraggerBtn(body):
	var obj_item := body as TraggerBtn
	if obj_item : 
		return true
	return false
	
func setEmeIn(body, isIn : bool) -> void:
	if isEnemyBody(body) :
		if isIn :
			inAtkZoneMob = body
			enemybody_in = true
		else :
			inAtkZoneMob = null
			enemybody_in = false

# function for multi monsters. however current game setting monster are not able to collaps 
func setEmeInList(body, isIn : bool, isLeft : bool) -> void:
	if isEnemyBody(body) :			
		var listTo = inAtkZoneMobs_R
		if isLeft:
			 listTo = inAtkZoneMobs_L
			
		var idx = listTo.find(body) 
		if idx >= 0:
			if !isIn :
				listTo.remove(idx)
		else:
			if isIn :
				listTo.append(body)

## =-==-=-=-=-=-=-= delegates =-=-=-=-=-=-=-=
func _on_Attack_Area2D_body_entered(body):
	if isEnemyBody(body) && !isFaseToLeft :
		setEmeIn(body, true)
		setEmeInList(body, true, true)

func _on_Attack_Area2D_body_exited(body):
	if isEnemyBody(body):
		setEmeIn(body, false)
		setEmeInList(body, false, true)

func _on_Attack_Area2DL_body_entered(body):
	if isEnemyBody(body) && isFaseToLeft :
		setEmeIn(body, true)
		setEmeInList(body, false, true)

func _on_Attack_Area2DL_body_exited(body):
	if isEnemyBody(body):
		setEmeIn(body, false)
		setEmeInList(body, false, false)

## evnet for body zone 
func _on_body_Area2D_body_entered(body):
	if isItemBody(body) : 
		emit_signal("item_touch",body)
	if isEnemyBody(body) :
		(body as EnemyObj).doActionDecisionWithPlayer(self)
		emit_signal("monster_touch",body)
		
	pass # Replace with function body.


