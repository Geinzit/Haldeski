extends Node

@onready var floor_tilemap: TileMapLayer = $FloorTileMap
@onready var wall_tilemap: TileMapLayer = $WallTileMap
@onready var map_size_x: int = 60
@onready var map_size_y: int = 60

var enemy_scene = preload("res://Scenes/PC/Enemy.tscn")
var item_scene = preload("res://Scenes/Items/Item.tscn")

func isWallAtCoordinate(position: Vector2i) -> bool:
	return wall_tilemap.get_cell_source_id(position) != -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameplayManager.floor_tilemap = floor_tilemap
	GameplayManager.wall_tilemap = wall_tilemap
	var floorattri: Array[int]
	if randi() % 2:
		floorattri = [randi() % 20, randi() % 20]
	else:
		floorattri = [randi()% 20]
	var wallattri: Array[int]
	if randi() % 2:
		wallattri = [randi() % 20, randi() % 20]
	else:
		wallattri = [randi() % 20]
	print(floorattri)
	populateFloorTiles(floorattri, MapData.FloorDistribution.random)
	populateWallTiles(wallattri, MapData.WallDistribution.random, 1000)
	populateEnemyInstances([randi() % Enemy.EnemyType.size()], MapData.WallDistribution.random, 50)
	populateItemInstances([randi() % 20], MapData.WallDistribution.random, 20)

func populateFloorTiles(attributes: Array[int], distribution: int):
	print("populating floor: ", attributes, " distribution: ", distribution)
	match distribution:
		MapData.FloorDistribution.random:
			for x in range(map_size_x):
				for y in range(map_size_y):
					var source_id = attributes[randi() % attributes.size()]
					var tileset_source = floor_tilemap.tile_set.get_source(source_id)
					var atlas_coords = tileset_source.get_tile_id(randi() % tileset_source.get_tiles_count())
					floor_tilemap.set_cell(Vector2i(x, y), source_id, atlas_coords)
		MapData.FloorDistribution.transitional:
			var a = 1

# count: when random, tile_number; when block, block_number
func populateWallTiles(attributes: Array[int], distribution: int, count: int, block_length: int = -1, block_width: int = -1):
	print("populating wall: ", attributes, " distribution: ", distribution)
	match distribution:
		MapData.WallDistribution.random:
			for i in range(count):
				var x: int = randi() % map_size_x
				var y: int = randi() % map_size_y
				var source_id = attributes[randi() % attributes.size()]
				var tileset_source = wall_tilemap.tile_set.get_source(source_id)
				var atlas_coords = tileset_source.get_tile_id(randi() % tileset_source.get_tiles_count())
				wall_tilemap.set_cell(Vector2i(x, y), source_id, atlas_coords)
		MapData.WallDistribution.block:
			for i in range(count):
				var sx: int = randi() % map_size_x
				var sy: int = randi() % map_size_y
				var lx: int = randi() % block_length + 1
				var ly: int = randi() % block_width + 1
				var source_id = attributes[randi() % attributes.size()]
				var tileset_source = wall_tilemap.tile_set.get_source(source_id)
				for x in range(sx, sx + lx):
					for y in range(sy, sy + ly):
						var atlas_coords = tileset_source.get_tile_id(randi() % tileset_source.get_tiles_count())
						wall_tilemap.set_cell(Vector2i(x, y), source_id, atlas_coords)

func populateEnemyInstances(attributes: Array[int], distribution: int, count: int):
	print("populating enemies: ", attributes, " distribution: ", distribution)
	var available_cells = []
	for i in range(map_size_x):
		for j in range(map_size_y):
			if !isWallAtCoordinate(Vector2i(i, j)):
				available_cells.append(Vector2i(i, j))
	#print(available_cells)
	match distribution:
		MapData.WallDistribution.random:
			for i in range(min(count, available_cells.size())):
				var pos = available_cells[randi() % available_cells.size()]
				available_cells.erase(pos)
				var attribute = attributes[randi() % attributes.size()]
				var enemy = enemy_scene.instantiate()
				enemy.position = Vector2(pos.x * 32 + 16, pos.y * 32 + 16)
				enemy.initialize(attribute)
				add_child(enemy)

func populateItemInstances(attributes: Array[int], distribution:int, count: int):
	for i in range(count):
		var x = randi() % map_size_x
		var y = randi() % map_size_y
		var item = item_scene.instantiate()
		if randi() % 2:
			item.init(0, WeaponData.WeaponType.random)
		else:
			item.init(1, 10 + randi() % 5)
		item.position = Vector2(x * 32 + 16, y * 32 + 16)
		add_child(item)

func placeItemAt(item_data: ItemData, position: Vector2):
	var item = item_scene.instantiate()
	if item_data is WeaponData:
		var weapon_data: WeaponData = item_data
		item.init(0, weapon_data.weapon_type_)
	elif item_data is ArmorData:
		var armor_data: ArmorData = item_data
		item.init(1, armor_data.armor_type_)
	item.position = Vector2(position.x, position.y)
	add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("!")
	pass
