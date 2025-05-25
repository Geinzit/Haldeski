extends Actor

@onready var player_hitbox: Area2D = $PlayerHitbox

@export var weapon_action1: WeaponAction
@export var weapon_action2: WeaponAction
@export var weapon_action3: WeaponAction
@export var weapon_action4: WeaponAction

var action1_cooldown: float
var action2_cooldown: float
var action3_cooldown: float
var action4_cooldown: float


var inventory_toggled: bool


var is_direction_locked: bool
var is_direction_locking: bool
var have_item_on_ground: bool
var item_on_ground

func weaponChangedCallback(weapon_type: int, left_or_right: bool):
	if left_or_right: # right
		var weapon_data = get_node("Equipment/Weapon/WeaponR").weapon_data
		# update available actions
		if weapon_data.weapon_type_ != WeaponData.WeaponType.no_weapon:
			for action in weapon_data.weapon_actions:
				Inventory.removeAction(action)
				updateActionSlotRemovedAction(action.action_type_)
				
		weapon_data = get_node("Equipment/Weapon/WeaponR").setType(weapon_type)
		if weapon_data.weapon_type_ != WeaponData.WeaponType.no_weapon:
			for action in weapon_data.weapon_actions:
				Inventory.addAction(action)
				
		get_node("Equipment/Weapon/WeaponR/WeaponRSlot/WeaponRIcon").texture = weapon_data.icon
	else:             # left
		var weapon_data = get_node("Equipment/Weapon/WeaponL").weapon_data
		if weapon_data.weapon_type_ != WeaponData.WeaponType.no_weapon:
			for action in weapon_data.weapon_actions:
				Inventory.removeAction(action)
				updateActionSlotRemovedAction(action.action_type_)
		weapon_data = get_node("Equipment/Weapon/WeaponL").setType(weapon_type)
		if weapon_data.weapon_type_ != WeaponData.WeaponType.no_weapon:
			for action in weapon_data.weapon_actions:
				Inventory.addAction(action)
		get_node("Equipment/Weapon/WeaponL/WeaponLSlot/WeaponLIcon").texture = weapon_data.icon
	# updateActions()

func armorChangedCallback(armor_type: int):
	var armor_data = ArmorData.new(armor_type)
	var armor_slot = armor_data.armor_slot
	var armor: Armor
	var armorIcon
	match armor_slot:
		ArmorData.ArmorSlot.Leg:
			armor = get_node("Equipment/Armor/Leg")
			armorIcon = get_node("Equipment/Armor/Leg/LegSlot/LegIcon")
		ArmorData.ArmorSlot.Torso:
			armor = get_node("Equipment/Armor/Torso")
			armorIcon = get_node("Equipment/Armor/Torso/TorsoSlot/TorsoIcon")
		ArmorData.ArmorSlot.Foot:
			armor = get_node("Equipment/Armor/Foot")
			armorIcon = get_node("Equipment/Armor/Foot/FootSlot/FootIcon")
		ArmorData.ArmorSlot.Arm:
			armor = get_node("Equipment/Armor/Arm")
			armorIcon = get_node("Equipment/Armor/Arm/ArmSlot/ArmIcon")
		ArmorData.ArmorSlot.Head:
			armor = get_node("Equipment/Armor/Head")
			armorIcon = get_node("Equipment/Armor/Head/HeadSlot/HeadIcon")
	var old_armor_data = armor.armor_data
	#remove old armor
	var defense_values = old_armor_data.defense_profile.values
	# remove available actions from gerr
	for action in old_armor_data.weapon_actions:
			Inventory.removeAction(action)
	# remove defense values
	var pc_values = defense_profile.values
	for key in defense_values.keys():
		if pc_values.has(key):
			pc_values[key] -= defense_values[key]
			
	
	armor.setType(armor_type)
	armorIcon.texture = armor_data.icon
	defense_values = armor_data.defense_profile.values
	# add available actions from gear
	if !armor_data.name.begins_with("no_"):
		for action in armor_data.weapon_actions:
			Inventory.addAction(action)
	# add defense values
	for key in defense_values.keys():
		if pc_values.has(key):
			pc_values[key] += defense_values[key]
			
	Inventory.updateDefenseProfile(defense_profile)

func pickUpItem(item: ItemData):
	if Inventory.inventory_size <= Inventory.items.size():
		return
	Inventory.addItem(item)
	item_on_ground.queue_free()
	
	
func updateActionSlotRemovedAction(action_type: int):
	if weapon_action1.action_type_ == action_type:
		weapon_action1 = WeaponAction.new(WeaponAction.ActionType.no_action)
	if weapon_action2.action_type_ == action_type:
		weapon_action2 = WeaponAction.new(WeaponAction.ActionType.no_action)
	if weapon_action3.action_type_ == action_type:
		weapon_action3 = WeaponAction.new(WeaponAction.ActionType.no_action)
	if weapon_action4.action_type_ == action_type:
		weapon_action4 = WeaponAction.new(WeaponAction.ActionType.no_action)

func actionSlotChangedCallback(action_type: int, action_slot_number: int):
	var action = WeaponAction.new(action_type)
	match action_slot_number:
		1:
			weapon_action1 = action
		2:
			weapon_action2 = action
		3:
			weapon_action3 = action
		4:
			weapon_action4 = action
			
func inventoryToggledCallback():
	inventory_toggled = !inventory_toggled
	var weapon_l_slot = get_node("Equipment/Weapon/WeaponL/WeaponLSlot")
	var weapon_r_slot = get_node("Equipment/Weapon/WeaponR/WeaponRSlot")
	var leg_slot = get_node("Equipment/Armor/Leg/LegSlot")
	var torso_slot = get_node("Equipment/Armor/Torso/TorsoSlot")
	var arm_slot = get_node("Equipment/Armor/Arm/ArmSlot")
	var foot_slot = get_node("Equipment/Armor/Foot/FootSlot")
	var head_slot = get_node("Equipment/Armor/Head/HeadSlot")
	weapon_l_slot.visible = !weapon_l_slot.visible
	weapon_r_slot.visible = !weapon_r_slot.visible
	leg_slot.visible = !leg_slot.visible
	torso_slot.visible = !torso_slot.visible
	arm_slot.visible = !arm_slot.visible
	foot_slot.visible = !foot_slot.visible
	head_slot.visible = !head_slot.visible

func playerCollisionCallback(area: Area2D):
	print("hit with ...")
	var collision_target = area.get_parent()
	if collision_target is Action:
		var weapon_action = collision_target.weapon_action
		print("action: ", weapon_action.name)
		takeDamage(weapon_action)
	elif collision_target is Item:
		have_item_on_ground = true
		var item = collision_target.item_data
		item_on_ground = collision_target
		print("item: ", item.name)
		Inventory.emit_signal("show_item_drop", item)
	elif collision_target is Enemy:
		var damage_values= collision_target.damage_profile.values
		var defense_values = defense_profile.values
		var mental_damage
		var hp_damage = 0
		for key in damage_values.keys():
			if defense_values.has(key):
				var damage = int(damage_values[key] * (100 - defense_values[key]) / 100.0)
				print("taken " + key + " damage ", damage)
				if key == "mental":
					mental_damage = damage
				else:
					hp_damage += damage
		# print("taken damage! hp: ", hp_damage, " mental: ", mental, " with action: " + weapon_action.name)
		hp -= hp_damage
		mental -= mental_damage
		print("taken hp damage: ", hp_damage, "remaining hp: ", hp)

func playerLeaveCollisionCallback(area: Area2D):
	var collision_target = area.get_parent()
	if collision_target is Action:
		return
	elif collision_target is Item and item_on_ground == collision_target:
		have_item_on_ground = false
		var item = collision_target.item_data
		Inventory.emit_signal("unshow_item_drop", item)	

func getInputDirection() -> Vector2:
	return Vector2(
		Input.get_action_strength("inputRight") - Input.get_action_strength("inputLeft"),
		Input.get_action_strength("inputDown") - Input.get_action_strength("inputUp")
	)

func getInputLockDirection():
	return Input.get_action_strength("inputAction5")
	
func getInputPickUp():
	return Input.get_action_strength("inputAction6")	

func getInputAction():
	var action1 = Input.get_action_strength("inputAction1")
	var action2 = Input.get_action_strength("inputAction2")
	var action3 = Input.get_action_strength("inputAction3")
	var action4 = Input.get_action_strength("inputAction4")
	
	if action1 and action1_cooldown == 0:
		return [weapon_action1, 1]
	if action2 and action2_cooldown == 0:
		return [weapon_action2, 2]
	if action3 and action3_cooldown == 0:
		return [weapon_action3, 3]
	if action4 and action4_cooldown == 0:
		return [weapon_action4, 4]
		
	return [WeaponAction.new(WeaponAction.ActionType.no_action), 0]
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# super._init(10, 10, 10, 10, 10, 10, 10, 10, 0)
	# for testing, plZZZ remember to update
	super._ready()
	# get_node("Equipment/Weapon/WeaponR").setType(WeaponData.WeaponType.long_sword)
	# weapon_action1 = WeaponAction.new(WeaponAction.ActionType.slash)
	
	# slots invisible
	get_node("Equipment/Weapon/WeaponR/WeaponRSlot").visible = false
	get_node("Equipment/Weapon/WeaponL/WeaponLSlot").visible = false
	get_node("Equipment/Armor/Leg/LegSlot").visible = false
	get_node("Equipment/Armor/Torso/TorsoSlot").visible = false
	get_node("Equipment/Armor/Arm/ArmSlot").visible = false
	get_node("Equipment/Armor/Foot/FootSlot").visible = false
	get_node("Equipment/Armor/Head/HeadSlot").visible = false
	
	get_node("Equipment/Weapon/WeaponR").setType(WeaponData.WeaponType.no_weapon)
	get_node("Equipment/Weapon/WeaponL").setType(WeaponData.WeaponType.no_weapon)
	get_node("Equipment/Armor/Foot").setType(ArmorData.ArmorType.no_armor_foot)
	get_node("Equipment/Armor/Leg").setType(ArmorData.ArmorType.no_armor_leg)
	get_node("Equipment/Armor/Arm").setType(ArmorData.ArmorType.no_armor_arm)
	get_node("Equipment/Armor/Torso").setType(ArmorData.ArmorType.no_armor_torso)
	get_node("Equipment/Armor/Head").setType(ArmorData.ArmorType.no_armor_head)
	
	weapon_action1 = WeaponAction.new(WeaponAction.ActionType.no_action)
	weapon_action2 = WeaponAction.new(WeaponAction.ActionType.no_action)
	weapon_action3 = WeaponAction.new(WeaponAction.ActionType.no_action)
	weapon_action4 = WeaponAction.new(WeaponAction.ActionType.no_action)
	
	# connect Inventory signals
	Inventory.weapon_changed.connect(Callable(weaponChangedCallback))
	Inventory.actions_slot_changed.connect(Callable(actionSlotChangedCallback))
	Inventory.inventory_toggled.connect(Callable(inventoryToggledCallback))
	Inventory.armor_changed.connect(Callable(armorChangedCallback))
	
	player_hitbox.connect("area_entered", Callable(playerCollisionCallback))
	player_hitbox.connect("area_exited", Callable(playerLeaveCollisionCallback))

func lockDirection():
	if is_direction_locking:
		return
	is_direction_locking = true
	is_direction_locked = !is_direction_locked
	# print("locking...")
	Inventory.emit_signal("direction_lock_changed", is_direction_locked)
	await get_tree().create_timer(2.0).timeout
	is_direction_locking = false
	
func processPlayerInput(delta: float) -> void:
	# print(inventory_toggled)
	if(inventory_toggled):
		return
	
	var input_direction = getInputDirection()
	if input_direction and !is_moving:
		if(!is_direction_locked):
			horizontal_direction = input_direction.x
			vertical_direction = input_direction.y
		moveIn(input_direction, 0.2)
	
	var input_lock_direction = getInputLockDirection()
	if input_lock_direction:
		lockDirection()
		
	var pick_up_item = getInputPickUp()	
	if pick_up_item and have_item_on_ground:
		pickUpItem(item_on_ground.item_data)
		
	var weapon_action_cooldown = getInputAction()
	if weapon_action_cooldown[0].name != "no_action" and !is_performing_action:
		performAction(weapon_action_cooldown[0])
		match weapon_action_cooldown[1]:
			1:
				action1_cooldown = weapon_action_cooldown[0].cooldown
			2:
				action2_cooldown = weapon_action_cooldown[0].cooldown
			3:
				action3_cooldown = weapon_action_cooldown[0].cooldown
			4:
				action4_cooldown = weapon_action_cooldown[0].cooldown

func updatePlayerStatus(delta:float) -> void:
	super.statUpdate()
	if Inventory.inventory_size != 10 + int(strength / 10):
		Inventory.inventory_size = 10 + int(strength / 10)
		Inventory.emit_signal("inventory_slot_added")
	
	if have_item_on_ground:
		Inventory.emit_signal("show_item_drop", item_on_ground.item_data)
		
	if action1_cooldown >= 0: 
		action1_cooldown = max(0, action1_cooldown - delta)
	if action2_cooldown >= 0: 
		action2_cooldown = max(0, action2_cooldown - delta)
	if action3_cooldown >= 0: 
		action3_cooldown = max(0, action3_cooldown - delta)
	if action4_cooldown >= 0: 
		action4_cooldown = max(0, action4_cooldown - delta)

	GameplayManager.player_pos = position
	barUpdate()
	
func barUpdate():
	var health_bar = $Healthbar
	var mental_bar = $Mentalbar
	# print("updating bar...")
	health_bar.size.x = int(32.0 * hp / max_hp)
	if mental >= 0:
		mental_bar.color = Color(0, 1, 0, 0)
	else:
		mental_bar.color = Color(1, 1, 1, 0)
	mental_bar.size.x = int(32.0 * abs(mental) / 100)
	
	if hp <= 0:
		GameplayManager.gameOver()
		set_process(false)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# update skills cooldowns

		
	# process player inputs
	processPlayerInput(delta)
	
	updatePlayerStatus(delta)
	
