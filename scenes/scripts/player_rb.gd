extends KinematicBody2D
signal hit_monster
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

#var move_direction:Vector2 = Vector2.RIGHT
var velocity = Vector2()
var jumping = false
var jumpVecCosumming = 0
var doPause = false

var takingHit = false

var isOnAttackAction = false
var isAttackActiving = false
var isAtkOnLeft = false
var enemybody_in = false
var inAtkZoneMob

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func start(pos):
	position = pos
	resume()
	pass

func resume():
	doPause = false
	pass

func stop():
#	speed = 0
#	jump_speed = 0
#	gravity = 0
	doPause = true
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
	
	if move_input.x > 0.3 || move_input.x < -0.3:
		if move_input != Vector2.ZERO: velocity = move_input * speed
	
		var right = move_input.x > 0
		var left = move_input.x < 0
	
		if velocity.y != 0:
			if velocity.y != 0 : 
				cancelAttack()
				$AnimatedSprite.animation = "jump"	
		elif velocity.x != 0:
			if  (right || left) :
				cancelAttack()
				$AnimatedSprite.animation = "run"		
				$AnimatedSprite.flip_h = left
				isAtkOnLeft = left
	else :
		$AnimatedSprite.animation = "idle"
		velocity = Vector2.ZERO
	
	pass

func get_controller_input():

	velocity.x = 0
	
	var right = Input.is_action_pressed("ui_right")
	var left = Input.is_action_pressed("ui_left") 
	var down = Input.is_action_pressed("ui_down")
	var jump = Input.is_action_pressed("ui_up") 
	var jump_release = Input.is_action_just_released("ui_up")
	var attack = Input.is_action_pressed("ui_select")
	
	if attack:
		doActionAttack()
	else :
		if right: 
			velocity.x += speed
		if left:
			velocity.x -= speed
		if jump and !jumping:
			if velocity.y >= 0 && velocity.y <= 10 && jumpVecCosumming == 0: # give some margin
				velocity.y = jump_speed
				jumpVecCosumming += jump_speed
#				print("Add jump" + str(velocity))
				if !is_on_floor():
					print("hit the top ?? " + str(velocity))	
			else:
				print("jumping not finished" + str(velocity))
		if jump_release:
			if jumpVecCosumming < 0:
				jumpVecCosumming = 0 # reset as button released 
		if down and dropEnable:
			player_drop_from_curPlatefrom()
		
		if takingHit :
			$AnimatedSprite.animation = "take_hit"
		elif isOnAttackAction:
			$AnimatedSprite.animation = "attack_wp1"
		elif (Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left")  || (velocity.x > -1 && velocity.x < 1 && velocity.y >= 0)):
			$AnimatedSprite.animation = "idle"
		else:
			if velocity.y != 0:
				if velocity.y != 0 : 
					cancelAttack()
					$AnimatedSprite.animation = "jump"	
			if velocity.x != 0:
				if  (right || left) :
					cancelAttack()
					$AnimatedSprite.animation = "run"		
					$AnimatedSprite.flip_h = left
					isAtkOnLeft = left
			
	pass

func player_drop_from_curPlatefrom():
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.35), "timeout")
	$CollisionShape2D.disabled = false
	pass
	
func doActionAttack():
	
	isOnAttackAction = true
	$AnimatedSprite.animation = "attack_wp1"
#	yield($AnimatedSprite.animation.ends_with("attack_wp1"), "true")
	pass

func cancelAttack():
	isOnAttackAction = false
#	$Attack_Area2D/CollisionShape2D_L.set_visible(false)
#	$Attack_Area2D/CollisionShape2D_R .set_visible(false)

func onHit():
	$AnimatedSprite.animation = "take_hit"
	takingHit = true

func _process(delta):	
	
	if isOnAttackAction:
		if 	$AnimatedSprite.animation.begins_with("attack") :
			if $AnimatedSprite.frame == 3 :
				isOnAttackAction = false
				isAttackActiving = false
			if $AnimatedSprite.frame == 2 :
				if  enemybody_in && inAtkZoneMob:
					emit_signal("hit_monster",inAtkZoneMob)
#			#do reset to idle
	if takingHit :
		if 	$AnimatedSprite.animation.begins_with("take_hit") :
			if $AnimatedSprite.frame == 3 :
				takingHit = false
	
	pass

func _physics_process(delta):
	# move itself	
	if !doPause :
		
		if isTouchScreenOn :
			get_mobile_input()
		else : 
			get_controller_input()
		
		if is_on_floor():
			if jumping:
				jumping = false
				$AnimatedSprite.animation = "idle"
		else :
			velocity.y += gravity * delta
		velocity = move_and_slide(velocity,Vector2(0, -1))
pass


func checkEnemyInAttackZone(body):
	
	pass

func _on_DeadArea_player_in():
	
	pass # Replace with function body.


#func _on_Attack_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
#	var mob := body as RigidBody2D
#	if mob && ($Attack_Area2D/CollisionShape2D_R.is_visible_in_tree() || $Attack_Area2D/CollisionShape2D_L.is_visible_in_tree()):
#		emit_signal("hit_monster",body)
#	pass # Replace with function body.


func _check_isMob(body) -> bool:
	var mob := body as RigidBody2D
	if mob :
		return true
	return false

func setEmeIn(body, isIn : bool) -> void:
	if _check_isMob(body) :
		if isIn :
			inAtkZoneMob = body
			enemybody_in = true
		else :
			inAtkZoneMob = null
			enemybody_in = false

## evnet for attack zone 
func _on_Attack_Area2D_body_entered(body):
	if !isAtkOnLeft :
		setEmeIn(body, true)

func _on_Attack_Area2D_body_exited(body):
	if !isAtkOnLeft :
		setEmeIn(body, false)

func _on_Attack_Area2DL_body_entered(body):
	if isAtkOnLeft :
		setEmeIn(body, true)

func _on_Attack_Area2DL_body_exited(body):
	if isAtkOnLeft :
		setEmeIn(body, false)

## evnet for body zone 
func _on_body_Area2D_body_entered(body):
	var mob := body as RigidBody2D
	if mob :
		emit_signal("monster_touch",body)
	pass # Replace with function body.



