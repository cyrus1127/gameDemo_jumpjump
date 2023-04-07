extends ItemData


# Called when the node enters the scene tree for the first time.
func _ready():
	type = ItemType.Weapon #as deafault
	pass # Replace with function body.


func setItemWith(data):
	.setItemWith(data)
	
	var dataDic := data as Dictionary
	if dataDic:
		type = dataDic.type
		
	pass
	
func getItemDic():
	
	var dataDic = .getItemDic()
	dataDic.p_AP = p_AP
	dataDic.p_DP = p_DP
	dataDic.p_HP = p_HP
	dataDic.p_SP = p_SP
	
	return dataDic
