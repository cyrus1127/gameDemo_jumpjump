extends Object
class_name PlayerData

# Declare member variables here. Examples:
var name = ""
var level = 0
var level_exp = 0 #overall experiens got entirely
var hp = -1 #maximum
var sp = -1 #maximum
var balance = -1 #money
var character_id = -1
var weapon_id = -1
var sheld_id = -1
var headware_id = -1
var bodyware_id = -1
var items = []


func _init():
	hp = 50
	sp = 50
	balance = 0
	pass

func getValueFromKey(var dicData : Dictionary, var key:String , var returnVal = ""):
	if dicData.has(key):
		var val = dicData[key]
		if val:
			return val
	return returnVal

func dataRestore(data):
	var dataDic := data as Dictionary
	if dataDic:
		character_id = getValueFromKey(dataDic,"characterID",-1)
		name = getValueFromKey(dataDic,"name")
		level = getValueFromKey(dataDic,"level",-1)
		level_exp = getValueFromKey(dataDic,"level_exp",-1)
		balance = getValueFromKey(dataDic,"balance",-1) 
		weapon_id = getValueFromKey(dataDic,"weapon_id",-1)
		sheld_id = getValueFromKey(dataDic,"sheld_id",-1)
		headware_id = getValueFromKey(dataDic,"headware_id",-1)
		bodyware_id = getValueFromKey(dataDic,"bodyware_id",-1)
		items = getValueFromKey(dataDic, "items", [])
	getLevel()

func getDataDic() -> Dictionary:
	var dataDic = {}
	dataDic.characterID = character_id
	dataDic.name = name
	dataDic.level = level
	dataDic.level_exp = level_exp
	dataDic.balance = balance
	dataDic.weapon_id = weapon_id
	dataDic.sheld_id = sheld_id
	dataDic.headware_id = headware_id
	dataDic.bodyware_id = bodyware_id
	dataDic.items = items
	return dataDic
	
func getLevel() -> int:
	var left_exp = level_exp
	
	while left_exp > 0:
		var sh_exp = exp(level+1)
		level += 1
		left_exp -= sh_exp
	
	print("level : " + str(level))
	
	return 0
