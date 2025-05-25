extends Node

var floor_tilemap: TileMapLayer
var wall_tilemap: TileMapLayer

var player_pos: Vector2

signal game_over

func checkWallatCoordinate(position: Vector2i) -> bool:
	# print("checking position: ", position, " id is ", wall_tilemap.get_cell_source_id(position))
	return wall_tilemap.get_cell_source_id(position) != -1

func checkFloorAtCoordinate(position: Vector2i) -> bool:
	return floor_tilemap.get_cell_source_id(position) != -1

func gameOver():
	emit_signal("game_over")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
