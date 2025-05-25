extends ItemData
class_name WeaponAction

@export var damage_profile: DamageProfile
@export var action_cost: int = 1
@export var cooldown: float = 2.0
@export var texture: CompressedTexture2D
@export var startup_time: float
@export var hitbox_time: float
@export var windup_time: float
@export var action_type_: int
@export var range_x: int
@export var range_y: int

enum ActionType {
	no_action,
	slash,
	cleave,
	random
}

func get_random_image(path: String) -> String:
	var dir = DirAccess.open(path)
	
	# try to open the folder
	if !dir:
		print("Failed to open folder:", path)
		return ""
	
	dir.list_dir_begin()
	var files = []
	var file = dir.get_next()
	while file != "":
		if !dir.current_is_dir() and file.get_extension().to_lower() in ["png", "jpg", "jpeg", "bmp", "tga", "webp"]:
			files.append(path + file) 
		file = dir.get_next()
	dir.list_dir_end()
	
	if files.size() > 0:
		return files[randi() % files.size()]
	return ""

func _init(action_type: int):
	action_type_ = action_type
	match action_type:
		ActionType.no_action:
			name = "no_action"
			damage_profile = DamageProfile.new(0, 0, 0, 0, 0, 0, 0)
			action_cost = 0
			cooldown = 0
			texture = null
			icon = null
			description = ""
		ActionType.slash:
			name = "slash"
			damage_profile = DamageProfile.new(10, 0, 0, 0, 0, 0, 0)
			action_cost = 1
			cooldown = 1.0
			startup_time = 0.0
			hitbox_time = 0.5
			windup_time = 0.0
			range_x = 1
			range_y = 1
			texture = load("res://assets/prototype/Effects/Alternative 3/1/Alternative_3_02.png")
			icon = load("res://assets/prototype/Dungeon Crawl Stone Soup Supplemental/effect/cloud_forest_fire.png")
			description = ""
		ActionType.cleave:
			name = "cleave"
			damage_profile = DamageProfile.new(15, 0, 0, 0, 0, 0, 0)
			action_cost = 2
			cooldown = 1.5
			startup_time = 0.5
			hitbox_time = 0.5
			windup_time = 0.5
			range_x = 1
			range_y = 2
			texture = load("res://assets/prototype/Effects/Alternative 1/1/Alternative_1_02.png")
			icon = load("res://assets/prototype/Dungeon Crawl Stone Soup Supplemental/effect/irradiate_0.png")
			# hitbox = load(scene_path + "WeaponActionHitbox_slash.tscn")
		ActionType.random:
			name = "RNG"
			damage_profile = DamageProfile.new(randi()% 20, randi()% 20, randi()% 20, randi()% 20, randi()% 20, randi()% 20, randi()% 20) 
			action_cost = randi() % 3 + 1
			cooldown = randi() % 20 / 10.0
			startup_time = randi() % 10 / 10.0
			hitbox_time = randi() % 10 / 10.0
			windup_time = randi() % 10 / 10.0
			range_x = randi() % 3 + 1
			range_y = randi() % 3 + 1
			var image_path = get_random_image("res://assets/prototype/Dungeon Crawl Stone Soup Supplemental/effect/")
			texture = load(image_path)
			icon = load(image_path)
