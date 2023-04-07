extends Node2D


# Declare member variables here. Examples:
export var haveEnemies = false
export (PackedScene) var Mob
export (PackedScene) var Trap

var velocity = Vector2()
var screen_size
var isMap_moveable = false 
var map_width
var gameStart = false

## =-=-=-=-=- player informations
var player_hp = 100
var player_sp = 100
var player_coins = 0
var player_exp = 0
var score = 0 # only for each level
var jumpCount = 0 # only for each level
var fallCount = 0 # only for each level

## =-=-==-=-=- on map enemies
var mobs = []
var mobPaths = []

## =-=-==-=-=- on map traps
var traps = []
var trapPaths = []

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$Player_RigidBody2D/Camera2D .position = Vector2(-100,-350)
	
	#Player data ready
	player_coins =  GLOBAL.playerData.balance
	player_exp = GLOBAL.playerData.level_exp
	player_hp = GLOBAL.playerData.hp
	player_sp = GLOBAL.playerData.sp
	
	#Scene ready
	$Player_RigidBody2D.start($pos_start.position)
	$HUD_level.update_hp(player_hp)
	$HUD_level.update_coin(GLOBAL.playerData.balance)
	
	var mapBase = $map/map_base
	var cell_bounds = mapBase.get_used_rect()
	var cell_to_pixel = Transform2D(Vector2(mapBase.cell_size.x * mapBase.scale.x, 0), Vector2(0, mapBase.cell_size.y * mapBase.scale.y) , Vector2())
	var mapSize = Rect2(cell_to_pixel * cell_bounds.position, cell_to_pixel * cell_bounds.size).size
	map_width = mapSize.x
	
	addMob()
	addTrap()
	
	yield(get_tree(),"idle_frame")
	yield(get_tree().create_timer(1),"timeout")
	gameStart = true
	
	pass # Replace with function body.

func addMob():
#	for idx in get_child_count():
#		var childPath := get_child(idx) as Path2D
#		if childPath:
#			print("have Mob Path")
#
#			var pathFol = childPath.get_child(0) as PathFollow2D
#			var mob = Mob.instance()
#
#			mobPaths.push_back(pathFol)
#			add_child(mob)
#			pathFol.set_process(true)
#			mob.position = pathFol.position
#			mob.rotation = pathFol.rotation
#
#			#set the mob with path
#			var mob_set = {}
#			mob_set.path = pathFol
#			mob_set.prog = 0
#			mob_set.flip = false
#			mob_set.mob = mob
#			mobs.push_back(mob_set)
	pass
			
func addTrap():
	for idx in get_child_count():
		var childPath := get_child(idx) as Path2D
		if childPath:
			var pathFol 
			var obj			
			
			for ci in childPath.get_child_count() :
				var child = childPath.get_child(ci)
				if child.get_class() == "PathFollow2D" :
					pathFol = child as PathFollow2D
				else :
					obj = child as TrapObj
			#			print("have Trap Path : " + childPath.get_name() )
			if obj :
				trapPaths.push_back(pathFol)
				pathFol.set_process(true)
				obj.position = pathFol.position
				obj.rotation = pathFol.rotation
				
				#set the mob with path
				var obj_set = {}
				obj_set.path = pathFol
				obj_set.prog = 0
				obj_set.flip = false
				obj_set.mob = obj
				traps.push_back(obj_set)			
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_input()
#	if velocity.x != 0:
#		$map.position += (velocity.normalized() * 1) * delta
#		$map.position.x = clamp($map.position.x, screen_size.x - map_width , 0)
#		velocity.x = 0
	updateEachTrap(delta)
	
	
## =-=-=-=-=-=-=-=-= Processing function
func get_input():
	
	if isMap_moveable :
		var right = Input.is_action_pressed("ui_right")
		var left = Input.is_action_pressed("ui_left")
		if right:
			velocity.x -= 1
		if left:
			velocity.x += 1
		
	pass

#var playInTheMiddle = false
func check_play_pos():
	
	pass # Replace with function body.


func updateEachTrap(delta):
	#update mob
	if traps.size() :
		for obj_set in traps:
			var pathFol = obj_set.path as PathFollow2D
			var prog = obj_set.prog
			var flip = obj_set.flip as bool
			var obj = obj_set.mob as TrapObj
			# handle flip

			# caluate
			if flip :
				prog -= obj.getMoveSpeed(1) * delta
				pathFol.set_offset(prog)
				if pathFol.get_unit_offset() <= 0.1 :
					flip = false	
			else : 
				prog += obj.getMoveSpeed(1) * delta	
				pathFol.set_offset(prog)
				if pathFol.get_unit_offset() >= 1 - 0.1 :
					flip = true
				
	#		print("mobPathProc : " + str(mobPathProc) + ".  u_offset : " + str($enemiesPath/PathFollow2D.unit_offset))
			 #update offset		
			obj.position = pathFol.position
			obj.rotation = pathFol.rotation
			obj.setFlip(flip)
			if !obj.is_monitoring():
				obj.set_monitoring(true)
			
			## Do update
			obj_set.prog = prog
			obj_set.flip = flip
	pass
	
func deductPlayHP(d_HP):
	if gameStart :
		player_hp -= d_HP
		$Player_RigidBody2D.onHit()
		$HUD_level.update_hp(player_hp)
		if player_hp <= 0: # give reset
			$HUD_level.showDeadView(false)
	pass

func _on_DeadArea2D_player_in():
	$Player_RigidBody2D.stop()
	# reset player positon
	deductPlayHP(30)
	if player_hp > 0: # give reset# game over
		$HUD_level.showDeadView(true)
pass 


func _on_GoalArea_player_in():
	$Player_RigidBody2D.stop()
	$HUD_level.showResult(score, jumpCount, fallCount)
pass # Replace with function body.


func _on_HUD_level_btn_pressed_backtotitle():
	GLOBAL.back_to_title()
	pass # Replace with function body.


func _on_HUD_level_btn_pressed_nextlevel():
	GLOBAL.next_scene()
	pass # Replace with function body.


func _on_HUD_level_btn_pressed_retry():
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_HUD_level_timeToReset():
	$HUD_level.update_hp(player_hp)
	$Player_RigidBody2D.start($pos_start.position)
	pass # Replace with function body.


func _on_Coin_coin_hit(obj):
	var coin := obj as GameObj
	if coin and gameStart : 
		print("object id " + str(coin.id))
		GLOBAL.playerData.balance += coin.value
		score += coin.value
		$HUD_level.update_coin(GLOBAL.playerData.balance)
		
	pass # Replace with function body.



func _on_HUD_level_meun_onshow():
	$Player_RigidBody2D.stop()
	pass # Replace with function body.


func _on_HUD_level_meun_closed():
	$Player_RigidBody2D.resume()
	pass # Replace with function body.


func _on_Player_RigidBody2D_hit_monster(body):
	var cMod := body as EnemyObj
	if  cMod :
		score += 1
		
		## remove mob
		var rm_idx = -1
		if mobs.size() :
			for i in mobs.size():
				var mob_set = mobs[i]
				var mob = mob_set.mob as EnemyObj
				if mob == cMod:
					rm_idx = i
					break
		
		if rm_idx > -1:
			mobs.remove(rm_idx)
		cMod.killed()
	
	pass # Replace with function body.


func _on_Player_RigidBody2D_monster_touch(body):
	var cMod := body as EnemyObj
	if  cMod:
		deductPlayHP(10)
		
	pass # Replace with function body.


func _on_dropAbleArea_player_in():
	$Player_RigidBody2D.dropEnable = true
	pass # Replace with function body.


func _on_dropAbleArea_player_out():
	$Player_RigidBody2D.dropEnable = false
	pass # Replace with function body.


func _on_Trap_player_collap():
	deductPlayHP(10)
	pass # Replace with function body.


func _on_pathTrap_player_collap():
	deductPlayHP(10)
	pass # Replace with function body.
