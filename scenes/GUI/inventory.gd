extends Node2D

signal listHaveChanged
# Declare member variables here. Examples:
enum CateType{
	All,
	Recover,
	Equipment,
}

var curSelectingType = CateType.All
var itemIndex = -1
var onlistingItem = []

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func getItems() -> Array:
	var allItems := GLOBAL.playerData.items as Array
	return allItems

func update():
	changeListedItem(curSelectingType)
	# load player backpack records
	print("itme count : " + str(GLOBAL.playerData.items.size()))
	if GLOBAL.playerData.items:
		$ScrollContainer/VScrollBar/ItemList.select(0)
		_on_ItemList_item_selected(0)
		itemIndex = 0
	else:
		$Control/lbl_name.text = "---"
		$Control/lbl_name2.text = "---"
	pass
	

func changeListedItem(n_type : int):
	#do clear all existing development items from list before add new
	$ScrollContainer/VScrollBar/ItemList.clear()
	

	#load item list
	var allItems = getItems()
	onlistingItem.clear()
	if allItems:
				
		for nItem in allItems:
			#{  "name": "Wine 2", "detail":"this is food. Recover SP 20", "price": 17,  "type": "Recover", "recoverType":"sp", "value":20 , "amt":0}
			var texture
			match (n_type):
				CateType.All :
					if (nItem.type == "Equipment" || nItem.type == "Weapon" ) :
						if !isWearingEquipment(nItem):
							texture = GLOBAL.getEquipmentTexture(nItem.name, nItem.type == "Weapon")
					else :
						texture = GLOBAL.getCommonItemTexture(nItem.name)
				CateType.Recover:
					if nItem.type == "Recover": 
						texture = GLOBAL.getCommonItemTexture(nItem.name)
				CateType.Equipment:
					if (nItem.type == "Equipment" || nItem.type == "Weapon" ) && !isWearingEquipment(nItem) :
						texture = GLOBAL.getEquipmentTexture(nItem.name, nItem.type == "Weapon")
				
				
			if texture:
				onlistingItem.push_back(nItem)
				var amt = 1
				if (nItem as Dictionary).keys().find('amt') != -1 :
					amt = nItem.amt
				$ScrollContainer/VScrollBar/ItemList.add_item("x"+str(amt), texture ,true)
		
	pass

func isWearingEquipment(item):
	if (item.type == "Equipment" || item.type == "Weapon" ) :
		if (item as Dictionary).keys().find('equiped') != -1 :
			if item.equiped == true :
				return true
				
	return false


func equipItem(data):
	var id = data.id
	if data.type.match("Weapon") : 
		if GLOBAL.playerData.weapon_id == -1 :
			GLOBAL.playerData.weapon_id = id
			return true
		else : 
			#do swipe the equipment 
			print("swipe the equipment done")
	elif data.type.match("Equipment") : 
		if GLOBAL.playerData.bodyware_id == -1 :
			GLOBAL.playerData.bodyware_id = id
			return true
		else : 
			#do swipe the equipment 
			print("swipe the equipment done")
	
	return false

# =-=-=-==-=- delegate =-=-==-=-=-


func _on_ItemList_item_selected(index):
	itemIndex = index

	if onlistingItem.size() > 0 && itemIndex < onlistingItem.size():
		$Control/lbl_name.text = onlistingItem[itemIndex].name
		$Control/lbl_name2.text = onlistingItem[itemIndex].detail
	
	#change button text
	if onlistingItem.size() > 0 && itemIndex > -1:
		var curType = onlistingItem[itemIndex].type
		if curType.match("Recover") :
			$Control/btn_use/lbl_.text = "Use"
			$Control/btn_set.disabled = false
		elif curType.match("Weapon") || curType.match("Equipment"):
			$Control/btn_use/lbl_.text = "Equip"
			$Control/btn_set.disabled = true
		else :
			$Control/btn_use.disabled = true
			$Control/btn_set.disabled = true
	
	pass # Replace with function body.

func _on_btn_use_button_down():
	
	var allItems = getItems()
	
	if  allItems && onlistingItem.size() > 0 && itemIndex > -1:
		var curType = onlistingItem[itemIndex].type
		var itemName = onlistingItem[itemIndex].name
		var itemIndexInFullList = -1
		
		#search the item index in full list
		for index in allItems.size():
			var item = allItems[index]
			if item.name.match(itemName) :
				if curType.match("Recover") :
					itemIndexInFullList = index
					break
				else :
					if !isWearingEquipment(item) :
						itemIndexInFullList = index
						break
		
		# handle found item
		if itemIndexInFullList >= 0:
			if curType.match("Recover"):
				var curAmt = onlistingItem[itemIndex].amt
				if curAmt - 1 == 0:
					allItems.remove(itemIndexInFullList)
					itemIndex = 0 #reset the selected index
				else:
					allItems[itemIndexInFullList].amt -= 1
				GLOBAL.change_sfx("fooditemUse")
			elif curType.match("Weapon") || curType.match("Equipment"):
				print('should equip item')
				if equipItem(allItems[itemIndexInFullList]) :
					print('item equiped')	
					(allItems[itemIndexInFullList] as Dictionary)["equiped"] = true
				else :
					print('item cant equip with some issues')	
			else :
				print('other types')
			
		update()
		emit_signal("listHaveChanged")
	pass # Replace with function body.

func _on_btn_filter_button_down(extra_arg_0):
	if curSelectingType != extra_arg_0 :
		curSelectingType = extra_arg_0
		update()
	pass # Replace with function body.
