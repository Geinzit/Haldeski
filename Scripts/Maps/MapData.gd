extends Resource
class_name MapData

enum FloorType {
	tutorial_pad,
	grass,
	black_cobalt,
	cage,
	crypt_domino,
	demonic_red,
	etched,
	frozen,
	green_bones,
	deep_ice,
	infernal,
	lair,
	bog_green,
	cobble_blood,
	crystal,
	dirt,
	nerves,
	sand_stone,
	vines,
	grey_dirt,
	hive,
	ice,
	lair2,
	lava,
	marble,
	mesh,
	pebble_brown,
	pedestal,
	rect_grey,
	rough_red,
	sandstone,
	snake,
	swamp,
	tomb,
	volcanic,
	white_marble,
	mud,
	orc
}

enum WallType {
	bars_red,
	catacombs,
	church,
	cobalt_rock,
	cobalt_stone,
	crystal,
	emerald,
	hell,
	lab_metal,
	lab_rock,
	lab_stone,
	lair,
	metal_white,
	orc,
	pebble_red,
	relief_brown,
	shoal,
	slime,
	slime_stone,
	snake,
	stone_brown,
	stone_dark,
	stone_gray,
	transparent_stone,
	undead_brown,
	zot_blue,
	mirrored,
	permarock_clear,
	permarock,
	silver
}

enum FloorDistribution {
	random,
	transitional,
	
}


enum WallDistribution {
	random,
	block,
	tight
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
