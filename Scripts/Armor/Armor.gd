extends Node
class_name Armor

@export var armor_data: ArmorData

#var horizontal_direction
#var vertical_direction

# func performAction(action: WeaponAction, target):
#	if action.hitbox:


# call when hit enemy
func computeDamage(damage_profile: DamageProfile, defense_profile: DefenseProfile):
	# TODO
	pass

func setType(armor_type: ArmorData.ArmorType) -> ArmorData:
	armor_data = ArmorData.new(armor_type)
	armorUpdate(armor_type)
	return armor_data

func armorUpdate(armor_type: ArmorData.ArmorType):
	var armor_sprite = get_node("ArmorSprite")
	if armor_type < 5:
		armor_sprite.texture = null
	else:
		armor_sprite.texture = armor_data.armor_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
