extends Object
class_name PlayerData

# Declare member variables here. Examples:
var name = ""
var level = 0
var level_exp = 0 #overall experiens got entirely
var hp = -1 #maximum
var sp = -1 #maximum
var balance = -1
var character_id = -1
var weapon_id = -1
var sheld_id = -1
var headware_id = -1
var bodyware_id = -1


func _init():
	hp = 50
	sp = 50
	balance = 0
	pass

func dataRestore(data):
	var dataDic := data as Dictionary
	if dataDic:
		name = dataDic.name
		level_exp = dataDic.level_exp
		balance = dataDic.balance
		character_id = dataDic.characterID
	getLevel()
		

func getDataDic():
	var dataDic = {}
	dataDic.name = name
	dataDic.level_exp = level_exp
	dataDic.balance = balance
	dataDic.characterID = character_id
	
	return dataDic
	
func getLevel() -> int:
	var left_exp = level_exp
	
	while left_exp > 0:
		var sh_exp = exp(level+1)
		level += 1
		left_exp -= sh_exp
	
	print("level : " + str(level))
	
	return 0
