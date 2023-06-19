extends Node2D

signal closed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum CateType{
	Recover,
	Equipment,
	All
}
var itemIndex = 0
var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$user_info_rect/mode.stop()
	
	slots = [$user_info_rect/slot_head/tb_equirping, $user_info_rect/slot_body/tb_equirping, $user_info_rect/slot_weap1/tb_equirping, $user_info_rect/slot_weap2/tb_equirping]
	update()
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update():
	changeListedItem(CateType.Recover)
	reviewEquipments()
	# load player backpack records
	print("itme count : " + str(GLOBAL.playerData.items.size()))
	if GLOBAL.playerData.items:
		$item_info_rect/ScrollContainer/VScrollBar/ItemList.select(0)
		_on_ItemList_item_selected(0)
		itemIndex = 0
		
		$user_info_rect/lbl_p_str.text = "STR : " + str(GLOBAL.playerData.getStr())
		$user_info_rect/lbl_p_dev.text = "DEV : " + str(GLOBAL.playerData.getDex())
		
	else:
		$Control/lbl_name.text = "---"
		$Control/lbl_name2.text = "---"
		
	pass

func getItems() -> Array:
	var allItems := GLOBAL.playerData.items as Array
	return allItems

# check and update gear info
func reviewEquipments():
	var checklist = [GLOBAL.playerData.headware_id, GLOBAL.playerData.bodyware_id, GLOBAL.playerData.weapon_id, GLOBAL.playerData.sheld_id]
	
	for index in checklist.size():
		var id = checklist[index]
		print("latest equipment slot["+str(index)+"] id : " + str(id))
		if id != -1 :
			#do set equipment
			var itemName = ''
			var allEqItems = GLOBAL.items_equipment_data_all["values"] as Array
			for eqItem in allEqItems :
				if eqItem.id == id && itemName.length() == 0 :
					itemName = eqItem.name
			
			if itemName.length() > 0 :
				var slot = slots[index] as TouchScreenButton
				var texture = GLOBAL.getEquipmentTexture(itemName, index >= 2)
				slot.set_texture(texture)
				slot.show()
	pass

func changeListedItem(n_type : int):
	#do clear all existing development items from list before add new
	$item_info_rect/ScrollContainer/VScrollBar/ItemList.clear()
	
	#load item list
	var allItems = getItems()
	if allItems:
		for nItem in allItems:
			#{  "name": "Wine 2", "detail":"this is food. Recover SP 20", "price": 17,  "type": "Recover", "recoverType":"sp", "value":20 , "amt":0}
			var texture
			if nItem.type == "Equipment":
				texture = GLOBAL.getEquipmentTexture(nItem.name)
			elif nItem.type == "Weapon":
				texture = GLOBAL.getEquipmentTexture(nItem.name, true)
			else : 
				texture = GLOBAL.getCommonItemTexture(nItem.name)
				
			if texture:
				var amt = 1
				if (nItem as Dictionary).keys().find('amt') != -1 :
					amt = nItem.amt
				$item_info_rect/ScrollContainer/VScrollBar/ItemList.add_item("x"+str(amt), texture ,true)
		
	pass


func _on_TextureButton_pressed():
	emit_signal("closed")
	hide()
	pass # Replace with function body.


func _on_ItemList_item_selected(index):
	itemIndex = index

	var allItems = getItems()
	if allItems && itemIndex < allItems.size():
		$Control/lbl_name.text = allItems[itemIndex].name
		$Control/lbl_name2.text = allItems[itemIndex].detail
	
	pass # Replace with function body.

func _on_btn_use_button_down():
	var allItems = getItems()
	if allItems:
		
		var curType = allItems[itemIndex].type
		
		if curType.match("Recover"):
			var curAmt = allItems[itemIndex].amt
			if curAmt - 1 == 0:
				allItems.remove(itemIndex)
				itemIndex = 0 #reset the selected index
			else:
				allItems[itemIndex].amt -= 1
			GLOBAL.change_sfx("fooditemUse")
		elif curType.match("Weapon") || curType.match("Equipment"):
			print('should equip item')
			if equipItem(allItems[itemIndex]) :
				print('item equiped')	
				(allItems[itemIndex] as Dictionary)["equiped"] = true
			else :
				print('item cant equip with some issues')	
		else :
			print('other types')
			
		update()
	pass # Replace with function body.

func equipItem(data):
	var id = data.id
	if data.type.match("Weapon") : 
		GLOBAL.playerData.weapon_id = id
		return true
	elif data.type.match("Equipment") : 
		GLOBAL.playerData.bodyware_id = id
		return true
	
	return false

func _on_eqSlot_pressed(extra_arg_0):
	
	#should unequip the wearing item
	
	
	match (extra_arg_0):
		1:
			GLOBAL.playerData.headware_id = -1
		2:
			GLOBAL.playerData.bodyware_id = -1
		3:
			GLOBAL.playerData.weapon_id = -1
		4:
			GLOBAL.playerData.sheld_id = -1
			
	var slot = slots[extra_arg_0 -1] as TouchScreenButton
	slot.hide()	
	print("equipment slot - "+str(extra_arg_0)+" unequiped")
	
	pass # Replace with function body.
