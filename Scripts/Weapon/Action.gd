extends Node2D
class_name Action

var weapon_action: WeaponAction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func hitTargetDisable(area):
	var hitbox: Area2D = $Hitbox
	hitbox.monitoring = false

func init(weapon_action_: WeaponAction):
	var hitbox: Area2D = $Hitbox
	weapon_action = weapon_action_
	var action_sprite: Sprite2D = $ActionSprite
	hitbox.scale = Vector2(weapon_action.range_x, weapon_action.range_y)
	action_sprite.texture = weapon_action.texture
	var height = action_sprite.texture.get_height()
	var width = action_sprite.texture.get_width()
	action_sprite.scale = Vector2(weapon_action.range_x * 32.0 / width, weapon_action.range_y * 32.0 / height)
	#hitbox.connect("area_entered", Callable(hitTargetDisable))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass
