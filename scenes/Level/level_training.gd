extends "res://scenes/scripts/level_logic.gd"

export (PackedScene) var dropItem

func genItem():
	print("drop items")
	pass

func genMob():
	if Mob :
		var nMob = Mob.instance()
		var nLoc = $Path_mobGen/PathFollow2D
		nLoc.offset = randi()
		nMob.position = nLoc.position
		add_child(nMob)
		(nMob as EnemyObj).auto_move = true
		print("drop monster")
	pass



# =-=-=-=-=- override functions =-=--=-=-=-=-
func addTrap():
	print("in Training room currently, auto gen trap & monster function is disabled")
	pass

func deductPlayHP(d_HP):
	if gameStart :
#		player_hp -= d_HP
		$Player_RigidBody2D.onHit()
		$HUD_level.update_hp(player_hp)
		if player_hp <= 0: # give reset
			$HUD_level.showDeadView(false)
	pass


# =-=-=-=-=- signal functions =-=--=-=-=-=-

func _on_TraggerBtn_player_traggered( id ):
	print("traggerBtn "+ str(id)+" is traggered")
	
	match(id):
		0:
			genMob()
		1:
			genItem()
	
	pass # Replace with function body.
