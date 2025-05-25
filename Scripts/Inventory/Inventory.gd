extends Node

signal item_grid_added(item)
signal item_grid_removed(index)
signal weapon_changed(weapon_type, left_or_right)
signal armor_changed(armor_type)
signal inventory_slot_added
signal actions_slot_changed(action_type, action_slot_number)
signal action_grid_removed(index)
signal action_grid_added(action)
signal direction_lock_changed(is_locked)
signal inventory_toggled
signal defense_updated(defense_profile)
signal show_item_drop(item_data)
signal unshow_item_drop(item_data)
signal show_message(message, time)


@export var max_slots:int = 20
@export var inventory_size: int = 10
@export var action_size: int = 40

var is_open: bool

func isInventoryOpen():
	return is_open

var items: Array[ItemData] = []
var available_actions: Array[WeaponAction] = []

func addItem(item: ItemData):
	if inventory_size <= items.size():
		return
	print("adding item...")
	items.append(item)
	emit_signal("item_grid_added", item)

# remove an item
func removeItem(item: ItemData):
	var index: int = items.find(item)
	if index == -1: return
	items.erase(items[index])	
	emit_signal("item_grid_removed", item)

func addAction(action:WeaponAction):
	available_actions.append(action)
	emit_signal("action_grid_added", action)

func removeAction(action: WeaponAction):
	var index: int = available_actions.find(action)
	if index == -1: return
	available_actions.erase(available_actions[index])
	emit_signal("action_grid_removed", index)

func equipWeapon(weapon_type: int, left_or_right: bool):
	emit_signal("weapon_changed", weapon_type, left_or_right)
		
func equipArmor(armor_type: int):
	emit_signal("armor_changed", armor_type)

func changeActionSlot(action_type: int, action_slot_number:int):
	emit_signal("actions_slot_changed", action_type, action_slot_number)
	
func updateDefenseProfile(defense_profile: DefenseProfile):
	emit_signal("defense_updated", defense_profile)	
	
func examineItem(item: Resource):
	if item is WeaponData:
		var weapon_data: WeaponData = item
	pass
	
#func getItemByName(name: String):
#	for item in items:
#		if item.
		
func clearInventory():
	items.clear()

func toggleInventory():
	is_open = !is_open
	emit_signal("inventory_toggled")
	

func getInputOpenInventory():
	return Input.get_action_strength("openInventory")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_open = false
	
	# testing purpose
	#for i in range(10):
	#	items.append(ItemData.new(ItemData.ItemType.no_item))

	#items[0] = WeaponData.new(WeaponData.WeaponType.long_sword)
	#items[1] = ArmorData.new(ArmorData.ArmorType.coat_black)
	#items[2] = ArmorData.new(ArmorData.ArmorType.pants_black)
	#items[3] = ArmorData.new(ArmorData.ArmorType.boots_grey)
	#items[4] = ArmorData.new(ArmorData.ArmorType.gloves_black_2)
	#items[5] = ArmorData.new(ArmorData.ArmorType.mask_black)


func _input(event):
	if event.is_action_pressed("openInventory"):
		toggleInventory()
