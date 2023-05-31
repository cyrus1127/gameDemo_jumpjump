class_name ItemData
extends Object


enum ItemType {Potion, Equipment, Weapon, Resources}

# Declare member variables here. Examples:
var id
var name
var description
var type   #Should be extended by ... (Weapon/Equipment/Potion)
var image
var quantity
var p_val = 0  #the item origial price to buy
var p_AP = 0  #Should be extended by ... (Weapon/Equipment)
var p_DP = 0  #Should be extended by ... (Weapon/Equipment)
var p_HP = 0  #Should be extended by ... (Weapon/Equipment/Potion)
var p_SP = 0  #Should be extended by ... (Weapon/Equipment/Potion)


# Called when the node enters the scene tree for the first time.
func _ready():
	type = ItemType.Resources #as deafault
	pass # Replace with function body.

# =-=-=-=-=- data get set
func setItemWith(data):
	var dataDic := data as Dictionary
	if dataDic:
		id = dataDic.id
		name = dataDic.name
		description = dataDic.description
		image = dataDic.image
		quantity = dataDic.quantity
		p_val = dataDic.p_val
	pass
	
func getItemDic():
	var dataDic = {}
	dataDic.id = id
	dataDic.name = name
	dataDic.description = description
	dataDic.image = image
	dataDic.quantity = quantity
	dataDic.p_val = p_val
	return dataDic


func changeAmount(nAmount):
	quantity = nAmount
	

