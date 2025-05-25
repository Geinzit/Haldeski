extends Node2D
class_name Item
var item_data: ItemData
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init(type: int, data_type: int):
	print("initing item drop....")
	var icon: Sprite2D = $Icon
	var item_area: Area2D = $ItemArea
	if type == 0: # Weapon
		item_data = WeaponData.new(data_type)
	elif type == 1: # Armor
		item_data = ArmorData.new(data_type)
	icon.texture = item_data.icon
	# item_area.connect("area_entered", Callable())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
