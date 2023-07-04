extends EnemyObj

export (PackedScene) var EmitAttack

var isPlayInRange_close = false
var playerBody
var ranged_atk_coolDownTime = 0
var ranged_atk_count = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	hp = 50
	atk = 2
	curKind = Kind.boss
	base_ItemDrop = 10
	base_ItemDrop_rand = 10
	myName = "EyeBall Bat King"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	._process(delta)
	
	# reset ranged attack count
	if ranged_atk_coolDownTime > 0:
		ranged_atk_coolDownTime -= delta
		if ranged_atk_coolDownTime <=0 :
			ranged_atk_count = 2  
	pass

# =-=-=- overrided 
func _doChangeDirection():
	setFlip(!$AnimatedSprite.is_flipped_h())
	if $AnimatedSprite.is_flipped_h():
		$Area_Direction.rotation_degrees = 180
		$Area_CloseComb.rotation_degrees = 180
		$Area_Emit.rotation_degrees = 180
	else :
		$Area_Direction.rotation_degrees = 0
		$Area_CloseComb.rotation_degrees = 0
		$Area_Emit.rotation_degrees = 0


# =-=-=-=-=- action logics

func attack_close():
	yield(get_tree().create_timer(1),"timeout")	
	if isPlayInRange_close :
		setAnimType(ActionType.CloseAttack)
		if playerBody :
			playerBody.onHit()
	else :
		yield(get_tree().create_timer(1),"timeout")
		attack_distance()
	pass

func attack_distance():
#	yield(get_tree().create_timer(2),"timeout")	
	
	if EmitAttack && ranged_atk_count > 0:
		setAnimType(ActionType.RangeAttack)
		var nEA = EmitAttack.instance() as emit_bullet
		nEA.position = position + Vector2(0, -25)
		get_parent().add_child(nEA)
		nEA.fire(!isFliped())
		ranged_atk_count -= 1
		if ranged_atk_count <= 0:
			ranged_atk_coolDownTime = 5

	pass
	
func _on_Area_Emit_body_entered(body):
	var player := body as KinematicBody2D
	if player && player.name.match(GLOBAL.playerObjName): 
		attack_distance()
	pass # Replace with function body.

func _on_Area_CloseComb_body_entered(body):
	var player := body as KinematicBody2D
	if player && player.name.match(GLOBAL.playerObjName): 
		attack_close()
		playerBody = player
		isPlayInRange_close = true
	pass # Replace with function body.

func _on_Area_CloseComb_body_exited(body):
	isPlayInRange_close = false
	playerBody = null
	pass # Replace with function body.
