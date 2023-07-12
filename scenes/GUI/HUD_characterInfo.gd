extends Node2D

signal closed
signal player_recovered(hp , sp)

# Declare member variables here. Examples:
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
	_on_btn_inventory_pressed()
	reviewEquipments()
#	# load player backpack records
	if GLOBAL.playerData.items:
		$user_info_rect/lbl_level.text = "LV : " + str(GLOBAL.playerData.level)
		$user_info_rect/ProgressBar_exp.value = GLOBAL.playerData.left_exp
		$user_info_rect/ProgressBar_exp.max_value = GLOBAL.playerData.getExp(GLOBAL.playerData.level)
		
		$user_info_rect/lbl_p_str.text = "STR : " + str(GLOBAL.playerData.getStr())
		$user_info_rect/lbl_p_dev.text = "DEV : " + str(GLOBAL.playerData.getDex())
		
	pass

func getItems() -> Array:
	var allItems := GLOBAL.playerData.items as Array
	return allItems
	
func initBaseHPSP(n_hp, n_sp):
	$user_info_rect/ProgressBar_HP.max_value = n_hp
	$user_info_rect/ProgressBar_SP.max_value = n_sp
	update_hp(n_hp)
	update_sp(n_sp)

func update_hp(n_val):
	$user_info_rect/ProgressBar_HP.value = n_val;
	pass

func update_sp(n_val):
	$user_info_rect/ProgressBar_SP.value = n_val;
	pass

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

func isWearingEquipment(item):
	if (item.type == "Equipment" || item.type == "Weapon" ) :
		if (item as Dictionary).keys().find('equiped') != -1 :
			if item.equiped == true :
				return true

	return false

#=-=-=-=-=--= delegates =-=-=-=-=-=-=-=

func _on_eqSlot_pressed(extra_arg_0):
	
	var playerData = GLOBAL.playerData
	var prevEqId = -1
	#should unequip the wearing item
	match (extra_arg_0):
		1:
			prevEqId = playerData.headware_id
			playerData.headware_id = -1
		2:
			prevEqId = playerData.bodyware_id
			playerData.bodyware_id = -1
		3:
			prevEqId = playerData.weapon_id
			playerData.weapon_id = -1
		4:
			prevEqId = playerData.sheld_id
			playerData.sheld_id = -1
			
	var allItems = getItems()
	if allItems:
		for nItem in allItems:
			if nItem.type == "Equipment" || nItem.type == "Weapon":
				if isWearingEquipment(nItem) && nItem.id == prevEqId:
					nItem.equiped = false
					(slots[extra_arg_0 -1] as TouchScreenButton ).hide()
					print("equipment slot - "+str(extra_arg_0)+" unequiped")
						
	update()
	$HUD_inventory.update()
	
	pass # Replace with function body.


func _on_HUD_node_characterInfo_listHaveChanged():
	update()
	pass # Replace with function body.

func _on_TextureButton_pressed():
	emit_signal("closed")
	hide()
	pass # Replace with function body.


func _on_btn_inventory_pressed():
	$user_info_rect.show()
	$HUD_inventory.show()
	$HUD_skillmap.hide()
	pass # Replace with function body.


func _on_btn_skill_pressed():
	$user_info_rect.hide()
	$HUD_inventory.hide()
	$HUD_skillmap.show()
	pass # Replace with function body.


func _on_HUD_inventory_player_recovered(hp_val, sp_val):
	emit_signal("player_recovered",hp_val,sp_val)
	pass # Replace with function body.
