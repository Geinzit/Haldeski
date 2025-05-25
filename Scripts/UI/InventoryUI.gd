extends Control

var slot_scene = preload("res://Scenes/UI/InventorySlot.tscn")

@onready var inventory_grid = $InventoryAnchor/InventoryGrid
@onready var inventory_label = $InventoryAnchor/InventoryLabel
@onready var inventory_panel = $InventoryAnchor/InventoryPanel
@onready var action_grid = $ActionAnchor/ActionGrid
@onready var status_panel = $StatusAnchor/StatusPanel
@onready var action_panel = $ActionAnchor/ActionPanel
@onready var action_label =  $ActionAnchor/ActionLabel
@onready var textbox_anchor = $TextboxAnchor
@onready var item_stats = $TextboxAnchor/ItemStats
@onready var description = $TextboxAnchor/Description
@onready var input_prompt = $TextboxAnchor/InputPrompt
@onready var textbox_anchor2 = $TextboxAnchor2
@onready var defense_status = $"StatusAnchor/StatusPanel/Defense Status"
@onready var game_over = $GameOver

var is_inventory_toggled: bool
var highlighted_slots: Array[InventorySlot]
var active_grid: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	highlighted_slots.clear()
	for i in range(20):
		highlighted_slots.append(null)
	Inventory.inventory_toggled.connect(Callable(inventoryToggledCallback))
	#connect("")
	inventory_grid.visible = false
	inventory_label.visible = false
	inventory_panel.visible = false
	action_grid.visible = false
	action_label.visible = false
	action_panel.visible = false
	status_panel.visible = false
	textbox_anchor2.visible = false
	textbox_anchor.visible = false
	game_over.visible = false
	
	# print(inventory_grid.get_child_count(), " ", action_grid.get_child_count())
	populateInventoryGrid()
	populateActionGrid()
	
	#signals
	Inventory.action_grid_added.connect(Callable(addActionSlot))
	Inventory.action_grid_removed.connect(Callable(removeActionSlot))
	Inventory.item_grid_added.connect(Callable(addInventoryItem))
	Inventory.item_grid_removed.connect(Callable(removeInventoryItem))
	Inventory.inventory_slot_added.connect(Callable(populateInventoryGrid))
	Inventory.direction_lock_changed.connect(Callable(showMessageDirectionLock))
	Inventory.defense_updated.connect(Callable(updateDefenseStatus))
	Inventory.show_item_drop.connect(Callable(showItemTextbox).bind(false))
	Inventory.unshow_item_drop.connect(Callable(unshowItemDropTextbox))
	Inventory.show_message.connect(Callable(showMessage))
	GameplayManager.game_over.connect(Callable(gameOver))
	
	is_inventory_toggled = false
	
	#testing
	Inventory.addItem(WeaponData.new(WeaponData.WeaponType.long_sword))
	Inventory.addItem(ArmorData.new(ArmorData.ArmorType.coat_black))
	Inventory.addItem(ArmorData.new(ArmorData.ArmorType.pants_black))
	Inventory.addItem(ArmorData.new(ArmorData.ArmorType.boots_grey))
	Inventory.addItem(ArmorData.new(ArmorData.ArmorType.gloves_black_2))
	Inventory.addItem(ArmorData.new(ArmorData.ArmorType.mask_black))

func gameOver():
	game_over.visible = true

func showMessageDirectionLock(is_direction_locked: bool):
	var message = "Player Direction is " + ("Locked" if is_direction_locked else "Unlocked")
	showMessage(message, 2.0)
	
func showMessage(message: String, secs: float):
	# print("showing message:", message, " ", secs, "s")
	if textbox_anchor2.visible == true:
		return
	textbox_anchor2.visible = true
	var messagefield = $TextboxAnchor2/Message
	messagefield.text = message
	await get_tree().create_timer(secs).timeout
	textbox_anchor2.visible = false

func inventoryToggledCallback():
	is_inventory_toggled = !is_inventory_toggled
	inventory_grid.visible = is_inventory_toggled
	inventory_label.visible = is_inventory_toggled
	inventory_panel.visible = is_inventory_toggled
	action_grid.visible = is_inventory_toggled
	action_panel.visible = is_inventory_toggled
	action_label.visible = is_inventory_toggled
	status_panel.visible = is_inventory_toggled
	textbox_anchor.visible = is_inventory_toggled
	if is_inventory_toggled:
		if inventory_grid.get_child_count() > 0:
			inventory_grid.get_child(0).grab_focus()
		# debug
		# for item in Inventory.items:
		#	print(item.name)
		# for action in Inventory.available_actions:
		#	print(action.name)	
	

func populateInventoryGrid():
	var number_to_add = Inventory.inventory_size - inventory_grid.get_child_count()
	print("adding ", number_to_add, " slots")
	for i in range(number_to_add):
		var slot_instance = slot_scene.instantiate()
		slot_instance.set_item(ItemData.new(ItemData.ItemType.no_item))
		inventory_grid.add_child(slot_instance)
	if is_inventory_toggled:
		if inventory_grid.get_child_count() > 0:
			inventory_grid.get_child(0).grab_focus()
			
func populateActionGrid():
	#print("number of available actions: ", Inventory.available_actions.size())
	var number_to_add = Inventory.action_size - action_grid.get_child_count()
	print("adding ",number_to_add, " actions")
	for i in range(number_to_add):
		var slot_instance = slot_scene.instantiate()
		slot_instance.set_item(WeaponAction.new(WeaponAction.ActionType.no_action))
		action_grid.add_child(slot_instance)

func addInventoryItem(item: ItemData):
	print("adding inventory slot...")
	var index = Inventory.items.size() - 1
	if index < inventory_grid.get_child_count():
		var child = inventory_grid.get_child(index)
		child.set_item(item)

func removeInventoryItem(index: int):
	if index < inventory_grid.get_child_count():
		var child = inventory_grid.get_child(index)
		for i in range(20):
			if highlighted_slots[i] == child:
				highlighted_slots[i] = null
		child.free()
		populateInventoryGrid()

func addActionSlot(action: WeaponAction):
	var index = Inventory.available_actions.size() - 1
	if index < action_grid.get_child_count():
		var child = action_grid.get_child(index)
		child.set_item(action)

func removeActionSlot(index: int):
	if index < action_grid.get_child_count():
		var child = action_grid.get_child(index)
		for i in range(20):
			if highlighted_slots[i] == child:
				highlighted_slots[i] = null
		child.free()
		populateActionGrid()

func updateDefenseStatus(defense_profile: DefenseProfile):
	defense_status.text = "Defense against: "
	for key in defense_profile.values.keys():
		defense_status.text += "\n"
		defense_status.text += key + " " + str(defense_profile.values[key])

func _input(event: InputEvent) -> void:
	if !is_inventory_toggled:
		return
		
	var slot: InventorySlot = get_viewport().gui_get_focus_owner()
	
	if(slot == null):
		return
	
	var item = slot.item
	if item.name.begins_with("no_"):
		return
	if event.is_action_pressed("inputAction1"):
		if item is WeaponData: # WeaponR
			if !slot.is_highlighted: # equip something that's not equipped
				Inventory.equipWeapon(item.weapon_type_, true)
				if(highlighted_slots[0]):
					highlighted_slots[0].update_visuals()
				highlighted_slots[0] = slot
				slot.update_visuals()
			else:
				if highlighted_slots[1] == slot: # equip something in the other hand
					Inventory.equipWeapon(WeaponData.WeaponType.no_weapon, false)
					Inventory.equipWeapon(item.weapon_type_, true)
					highlighted_slots[1] = null
					highlighted_slots[0] = slot
				else: # unequip
					Inventory.equipWeapon(WeaponData.WeaponType.no_weapon, true)
					highlighted_slots[0] = null
					slot.update_visuals()
		elif item is ArmorData: # Armor
			if !slot.is_highlighted:
				Inventory.equipArmor(item.armor_type_)
				match item.armor_slot:
					ArmorData.ArmorSlot.Leg:
						if(highlighted_slots[2] && highlighted_slots[2] != slot):
							highlighted_slots[2].update_visuals()
						highlighted_slots[2] = slot
					ArmorData.ArmorSlot.Arm:
						if(highlighted_slots[3] && highlighted_slots[3] != slot):
							highlighted_slots[3].update_visuals()
						highlighted_slots[3] = slot
					ArmorData.ArmorSlot.Head:
						if(highlighted_slots[4] && highlighted_slots[4] != slot):
							highlighted_slots[4].update_visuals()
						highlighted_slots[4] = slot
					ArmorData.ArmorSlot.Torso:
						if(highlighted_slots[5] && highlighted_slots[5] != slot):
							highlighted_slots[5].update_visuals()
						highlighted_slots[5] = slot
					ArmorData.ArmorSlot.Foot:
						if(highlighted_slots[6] && highlighted_slots[6] != slot):
							highlighted_slots[6].update_visuals()
						highlighted_slots[6] = slot
			else: #unequip
				match item.armor_slot:
					ArmorData.ArmorSlot.Leg:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_leg)
						highlighted_slots[2] = null
					ArmorData.ArmorSlot.Arm:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_arm)
						highlighted_slots[3] = null
					ArmorData.ArmorSlot.Head:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_head)
						highlighted_slots[4] = null
					ArmorData.ArmorSlot.Torso:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_torso)
						highlighted_slots[5] = null
					ArmorData.ArmorSlot.Foot:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_foot)
						highlighted_slots[6] = null
			slot.update_visuals()
		elif item is WeaponAction:
			if highlighted_slots[7] != slot:
				Inventory.changeActionSlot(item.action_type_, 1)
				if highlighted_slots[7]:
					highlighted_slots[7].update_visuals()
				for i in range(7, 11):
					if highlighted_slots[i] == slot:
						highlighted_slots[i].update_visuals()
						highlighted_slots[i] = null
						Inventory.changeActionSlot(WeaponAction.ActionType.no_action, i-6)
				highlighted_slots[7] = slot
			else:
				Inventory.changeActionSlot(WeaponAction.ActionType.no_action, 1)
				highlighted_slots[7] = null
			slot.update_visuals()
	elif event.is_action_pressed("inputAction2"):
		if item is WeaponData: # WeaponL
			if !slot.is_highlighted:
				Inventory.equipWeapon(item.weapon_type_, false)
				if highlighted_slots[1] and highlighted_slots[1] != slot:
					highlighted_slots[1].update_visuals()
				highlighted_slots[1] = slot
				slot.update_visuals()
			else:
				if highlighted_slots[0] == slot:
					highlighted_slots[0] = null
					highlighted_slots[1] = slot
					Inventory.equipWeapon(WeaponData.WeaponType.no_weapon, true)
					Inventory.equipWeapon(item.weapon_type_, false)
				else:	
					Inventory.equipWeapon(WeaponData.WeaponType.no_weapon, false)
					highlighted_slots[1] = null
					slot.update_visuals()
		elif item is WeaponAction:
			if highlighted_slots[8] != slot:
				Inventory.changeActionSlot(item.action_type_, 2)
				if highlighted_slots[8]:
					highlighted_slots[8].update_visuals()
				for i in range(7, 11):
					if highlighted_slots[i] == slot:
						highlighted_slots[i].update_visuals()
						highlighted_slots[i] = null
						Inventory.changeActionSlot(WeaponAction.ActionType.no_action, i-6)
				highlighted_slots[8] = slot
			else:
				Inventory.changeActionSlot(WeaponAction.ActionType.no_action, 2)
				highlighted_slots[8] = null
			slot.update_visuals()
	elif event.is_action_pressed("inputAction3"):
		if item is WeaponAction:
			if highlighted_slots[9] != slot:
				Inventory.changeActionSlot(item.action_type_, 3)
				if highlighted_slots[9]:
					highlighted_slots[9].update_visuals()
				for i in range(7, 11):
					if highlighted_slots[i] == slot:
						highlighted_slots[i].update_visuals()
						highlighted_slots[i] = null
						Inventory.changeActionSlot(WeaponAction.ActionType.no_action, i-6)
				highlighted_slots[9] = slot
			else:
				Inventory.changeActionSlot(WeaponAction.ActionType.no_action, 3)
				highlighted_slots[9] = null
			slot.update_visuals()
	elif event.is_action_pressed("inputAction4"):
		if item is WeaponAction:
			if highlighted_slots[10] != slot:
				Inventory.changeActionSlot(item.action_type_, 4)
				if highlighted_slots[10]:
					highlighted_slots[10].update_visuals()
				for i in range(7, 11):
					if highlighted_slots[i] == slot:
						highlighted_slots[i].update_visuals()
						highlighted_slots[i] = null
						Inventory.changeActionSlot(WeaponAction.ActionType.no_action, i-6)
				highlighted_slots[10] = slot
			else:
				Inventory.changeActionSlot(WeaponAction.ActionType.no_action, 4)
				highlighted_slots[10] = null
			slot.update_visuals()
		elif item is WeaponData:
			var pc = get_parent().get_parent().get_node("PC")
			if pc.have_item_on_ground:
				return
			if slot.is_highlighted:
				if slot == highlighted_slots[0]: # RWeapon
					Inventory.equipWeapon(WeaponData.WeaponType.no_weapon, true)
					highlighted_slots[0] = null
				else: # LWeapon
					Inventory.equipWeapon(WeaponData.WeaponType.no_weapon, false)
					highlighted_slots[1] = null
			removeItemFromGrid(slot)
		elif item is ArmorData:
			var pc = get_parent().get_parent().get_node("PC")
			if pc.have_item_on_ground:
				return
			if slot.is_highlighted:
				match item.armor_slot:
					ArmorData.ArmorSlot.Leg:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_leg)
						highlighted_slots[2] = null
					ArmorData.ArmorSlot.Arm:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_arm)
						highlighted_slots[3] = null
					ArmorData.ArmorSlot.Head:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_head)
						highlighted_slots[4] = null
					ArmorData.ArmorSlot.Torso:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_torso)
						highlighted_slots[5] = null
					ArmorData.ArmorSlot.Foot:
						Inventory.equipArmor(ArmorData.ArmorType.no_armor_foot)
						highlighted_slots[6] = null
			removeItemFromGrid(slot)

		# switch grid focus
	
func removeItemFromGrid(slot):
	var pc = get_parent().get_parent().get_node("PC")
	var map = get_parent().get_parent().get_node("Map")
	var position = pc.position
	map.placeItemAt(slot.item, position)
	Inventory.items.erase(slot.item)		
	slot.free()
	populateInventoryGrid()
		
func unshowItemDropTextbox(item: ItemData):
	textbox_anchor.visible = false

func showItemTextbox(item: ItemData, inventory_or_ground: bool):
	if item.name.begins_with("no_"):
		textbox_anchor.visible = false
		return
		
	textbox_anchor.visible = true
	
	if item is WeaponData:
		item_stats.text = "Name: " + item.name + "\n"
		item_stats.text += "Type: Weapon" + "\n"
		item_stats.text += "Availabe Actions: "
		for action in item.weapon_actions:
			item_stats.text += action.name+ " "
		if inventory_or_ground:
			input_prompt.text = "z: equip/unequip right x: equip/unequip left v: drop"
	elif item is ArmorData:
		item_stats.text = "Name: " + item.name + "\n"
		item_stats.text += "Type: Armor, Slot: " + ArmorData.ArmorSlot.keys()[item.armor_slot] + "\n"
		item_stats.text += "Slash Defense: " + str(item.defense_profile.values["slash"]) + "\n"
		item_stats.text += "Blunt Defense: " + str(item.defense_profile.values["blunt"]) + "\n"
		item_stats.text += "Pierce Defense: " + str(item.defense_profile.values["pierce"]) + "\n"
		item_stats.text += "Fire Defense: " + str(item.defense_profile.values["fire"]) + "\n"
		item_stats.text += "Frost Defense: " + str(item.defense_profile.values["frost"]) + "\n"
		item_stats.text += "Lightning Defense: " + str(item.defense_profile.values["lightning"]) + "\n"
		for action in item.weapon_actions:
			item_stats.text += action.name+ " "
		if inventory_or_ground:
			input_prompt.text = "z: equip/unequip x: equip/unequip left v: drop"
	elif item is WeaponAction:
		item_stats.text = "Name: " + item.name + "\n"
		item_stats.text += "Type: Action" + "\n"
		item_stats.text += "Slash Damage: " + str(item.damage_profile.values["slash"]) + "\n"
		item_stats.text += "Blunt Damage: " + str(item.damage_profile.values["blunt"]) + "\n"
		item_stats.text += "Pierce Damage: " + str(item.damage_profile.values["pierce"]) + "\n"
		item_stats.text += "Fire Damage: " + str(item.damage_profile.values["fire"]) + "\n"
		item_stats.text += "Frost Damage: " + str(item.damage_profile.values["frost"]) + "\n"
		item_stats.text += "Lightning Damage: " + str(item.damage_profile.values["lightning"]) + "\n"
		if inventory_or_ground:
			input_prompt.text = "z,x,c,v: assign action to button pressed"
	else:
		item_stats.text = "Name: " + item.name + "\n"
	if !inventory_or_ground:
		input_prompt.text = "s: pick up"
	description.text = "Description:\n" + item.description

func showSlotTextbox():
	var slot: InventorySlot = get_viewport().gui_get_focus_owner()
	if slot:
		var item = slot.item
		showItemTextbox(item, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_inventory_toggled:
		showSlotTextbox()
	#elif textbox_anchor.visible:
	#	textbox_anchor.visible = false
	pass
