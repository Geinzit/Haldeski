extends Resource
class_name ItemData

@export var name: String
@export var icon: CompressedTexture2D
@export var description: String

enum ItemType {
	no_item,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init(item_type: int = 0):
	match item_type:
		ItemType.no_item:
			name = "no_item"
			icon = null
			description = "N/A"
