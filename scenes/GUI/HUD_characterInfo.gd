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

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func update():
	changeListedItem(CateType.Recover)
	# load player backpack records
	print("itme count : " + str(GLOBAL.playerData.items.size()))
	if GLOBAL.playerData.items:
		$item_info_rect/ScrollContainer/VScrollBar/ItemList.select(0)
		_on_ItemList_item_selected(0)
		itemIndex = 0
	else:
		$Control/lbl_name.text = "---"
		$Control/lbl_name2.text = "---"
		
	pass

func getItems() -> Array:
	var allItems := GLOBAL.playerData.items as Array
	return allItems

func changeListedItem(n_type : int):
	#do clear all existing development items from list before add new
	$item_info_rect/ScrollContainer/VScrollBar/ItemList.clear()
	
	#load item list
	var imagePath = "res://res/Texture/Food/"
	var imageExtension = ".png"
	var allItems = getItems()
	if allItems:
		for nItem in allItems:
			#{  "name": "Wine 2", "detail":"this is food. Recover SP 20", "price": 17,  "type": "Recover", "recoverType":"sp", "value":20 , "amt":0}
			imagePath = "res://res/Texture/Food/"
			if nItem.type == "Equipment":
				imagePath = "res://res/Texture/Equipment/"
			elif nItem.type == "Weapon":
				imagePath = "res://res/Texture/Weapon & Tool/"
				
			var texturePath = imagePath + nItem.name + imageExtension
			var texture = load(texturePath)
			var amt = nItem.amt
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
		var curAmt = allItems[itemIndex].amt
		if curAmt - 1 == 0:
			allItems.remove(itemIndex)
			itemIndex = 0 #reset the selected index
		else:
			allItems[itemIndex].amt -= 1
		GLOBAL.change_sfx("fooditemUse")
		update()
	pass # Replace with function body.
