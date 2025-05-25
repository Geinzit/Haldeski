extends Button
class_name InventorySlot

var item: ItemData
@onready var unselected_icon = preload("res://assets/prototype/Dungeon Crawl Tiles/UNUSED/gui/tab_unselected_square.png")
@onready var selected_icon = preload("res://assets/prototype/Dungeon Crawl Tiles/UNUSED/gui/tab_selected_square.png")
var is_highlighted: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	focus_mode = FocusMode.FOCUS_ALL
	icon = unselected_icon
	# print("instantiated...")
	#connect("focus_entered", Callable(focusChangedCallback))
	#connect("focus_exited", Callable(focusChangedCallback))
	#update_visuals()

#func focusChangedCallback():
#	is_highlighted = !is_highlighted
#	update_visuals()

func update_visuals():
	is_highlighted = !is_highlighted
	if is_highlighted:
		icon = selected_icon
		grab_focus()
	else:
		icon = unselected_icon	

func set_item(new_item: ItemData):
	item = new_item
	get_node("ItemIcon").texture = new_item.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
