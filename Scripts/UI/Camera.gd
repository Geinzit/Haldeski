extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_pos = get_parent().get_node("PC").position
	if player_pos.y - position.y < 150:
		if player_pos.y >= 150:
			position.y = player_pos.y - 150
	elif player_pos.y - position.y > 450 and player_pos.y >= 450:
		if player_pos.y >= 450:
			position.y = player_pos.y - 450
	if player_pos.x - position.x < 200 and player_pos.x >= 200:
		if player_pos.x >= 200:
			position.x = player_pos.x - 200
	elif player_pos.x - position.x > 600 and player_pos.x >= 600:
		if player_pos.x >= 600:
			position.x = player_pos.x - 600
