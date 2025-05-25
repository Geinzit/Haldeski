extends Node2D
class_name Actor

# Attributes
@export var hatred: int
@export var avarice: int
@export var lechery: int
@export var dexterity: int
@export var endurance: int
@export var strength: int
@export var knowledge: int
@export var insight: int

var action_hitbox = preload("res://Scenes/Weapon/Action.tscn")

# stats
@export_range(0, 1000)
var max_hp: int
var hp: int
@export_range(1, 10)
var max_action_points: int
@export_range(-100, 100)
var mental: int

var defense_profile: DefenseProfile

# more stats
var evasion_chance: int

# facing direction
var horizontal_direction: int = 1
var vertical_direction: int = 0

var is_moving: bool
var is_performing_action: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	defense_profile = DefenseProfile.new(0, 0, 0, 0, 0, 0, 0)
	pass # Replace with function body.
	
func _init(h: int = 10, a: int = 10, l: int = 10, d: int = 10, e: int = 10, s: int = 10, k: int = 10, i: int = 10, mental_: int = 0):
	init(h, a, l, d, e, s, k, i, mental_)
	
func init(h: int = 10, a: int = 10, l: int = 10, d: int = 10, e: int = 10, s: int = 10, k: int = 10, i: int = 10, mental_: int = 0):
	hatred = h
	avarice = a
	lechery = l
	dexterity = d
	endurance = e
	strength = s
	knowledge = k
	insight = i
	mental = mental_
	
	statUpdate()
	hp = max_hp

func moveIn(moveDirection, time):
	#var viewport = get_viewport()
	var targetPosition = position + moveDirection * 32
	var grid_position = Vector2i(targetPosition.x / 32, targetPosition.y / 32)
	
	# var Targetposition = position + moveDirection / 32
	
	#var relative_to_viewport_position = Vector2i(position) - viewport.position
	
	if moveDirection.x and moveDirection.y:
		var target_position2 = position + Vector2(moveDirection.x, 0) * 32
		var target_position3 = position + Vector2(0, moveDirection.y) * 32
		var grid_position2 = Vector2i(target_position2.x / 32, target_position2.y / 32)
		var grid_position3 = Vector2i(target_position3.x / 32, target_position3.y / 32)
		if GameplayManager.checkWallatCoordinate(grid_position2) or GameplayManager.checkWallatCoordinate(grid_position3):
			return
	
	if GameplayManager.checkWallatCoordinate(grid_position):
		return
	if !GameplayManager.checkFloorAtCoordinate(grid_position):
		return
	#set_process(false)
	is_moving = true
	var tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", targetPosition, time)
	#if(relative_to_viewport_position.x > 600 || relative_to_viewport_position.y > 400):
	# tween.tween_property(viewport, "position", viewport.position + Vector2i(moveDirection) * 32, 0.5)
	
	await get_tree().create_timer(time).timeout
	
	position = targetPosition
	is_moving = false
	#set_process(true)
	# start interpolating movement

func takeDamage(weapon_action: WeaponAction):
	var damage_values= weapon_action.damage_profile.values
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
	print("taken damage! hp: ", hp_damage, " mental: ", mental, " with action: " + weapon_action.name)
	hp -= hp_damage
	mental -= mental_damage
			
func performAction(action: WeaponAction):
	# TODO animate weapon
	is_performing_action = true
	
	await get_tree().create_timer(action.startup_time).timeout
	
	var hitbox_instance: Action = action_hitbox.instantiate()
	hitbox_instance.init(action)
	
	add_child(hitbox_instance)
	if horizontal_direction:
		#print(hitbox_instance.transform, horizontal_direction)
		hitbox_instance.transform.origin.x += horizontal_direction * 32
		if horizontal_direction == -1:
			hitbox_instance.transform.x = Vector2(-1, 0)
	elif vertical_direction:
		hitbox_instance.transform.origin.y += vertical_direction * 32
		if vertical_direction == 1:
			hitbox_instance.transform.x = Vector2(0, 1)
			hitbox_instance.transform.y = Vector2(1, 0)
		else:
			hitbox_instance.transform.x = Vector2(0, -1)
			hitbox_instance.transform.y = Vector2(1, 0)	
	# adjust position etc.
	await get_tree().create_timer(action.hitbox_time).timeout
	
	remove_child(hitbox_instance)
	
	await get_tree().create_timer(action.windup_time).timeout
	is_performing_action  = false


func statUpdate():
	evasion_chance = int(100.0 / (1 + exp(-0.05 * (dexterity - 50))))
	max_hp = 100 + 2 * endurance
	max_action_points = int(1 + 9 * pow(insight / 100, 0.7))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	statUpdate()
	pass
