extends Object
class_name PlayerData

# Declare member variables here. Examples:
var name = ""
var level = 0
var level_exp = 0 #overall experiens got entirely
var left_exp = -1 #current after cal
var hp = -1 #maximum
var sp = -1 #maximum
var balance = -1 #money
var character_id = -1
var weapon_id = -1
var sheld_id = -1
var headware_id = -1
var bodyware_id = -1
var items : Array = []


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
	#update cur level
	level = getLevel()

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
	
func getExp(lv):
	var exp_begin = 10 #is basic
	var max_level = 100 #a maximum 
	var lv2Cal = min(max_level , lv)
	
	var nExp =  exp_begin
	if lv2Cal > 0 :
		nExp = (((lv2Cal) - log(lv2Cal)) *exp_begin) +  ((lv2Cal+1 - log(lv2Cal+1)) *exp_begin)

	print(" ->>> level : " + str(lv2Cal) +" => nExp " + str(floor(nExp)))
	
	return nExp
	
func getLevel() -> int:
	left_exp = level_exp
	var calLv = 0;
	var deductExp = getExp(calLv)
	while left_exp - deductExp >= 0:
		left_exp -= deductExp
		calLv += 1
		deductExp = getExp(calLv)
		
	print("level : " + str(calLv) + ", exp :" + str(left_exp))
	
	return calLv
	
# =-=-=-=-=-=-= by level =-=-=-=-=-=-=-=-=
func addExp(nExp):
	level_exp += nExp
	#update cur level
	level = getLevel()


func getTotalHP():
	var tHP = hp
	var eqSlot = []
	
	return hp
	
# by level
func getStr():
	var tStr = 1
	
	return tStr
	
# by level
func getDex():
	var tDex = 1
	
	return tDex
	
func getTotalAtk():
	var tAtk = 1 + getStr() * 0.5
	var eqSlot = []
	
	return tAtk
	
	
	
	
