extends Node
class_name Weapon

@export var weapon_data: WeaponData

#var horizontal_direction
#var vertical_direction

# func performAction(action: WeaponAction, target):
#	if action.hitbox:


func setType(weapon_type: WeaponData.WeaponType) -> WeaponData:
	weapon_data = WeaponData.new(weapon_type)
	weaponUpdate(weapon_type)
	return weapon_data

func weaponUpdate(weapon_type:WeaponData.WeaponType):
	var weapon_sprite = get_node("WeaponSprite")
	if weapon_type == WeaponData.WeaponType.no_weapon:
		weapon_sprite.texture = null
	else:
		weapon_sprite.texture = weapon_data.weapon_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
