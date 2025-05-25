extends ItemData
class_name ArmorData

enum ArmorType {
	no_armor_leg,
	no_armor_foot,
	no_armor_torso,
	no_armor_arm,
	no_armor_head,
	coat_black,
	pants_black,
	boots_grey,
	gloves_black_2,
	mask_black,
	head_random,
	leg_random,
	torso_random,
	arm_random,
	boots_random
}

enum ArmorSlot {
	Leg,
	Foot,
	Torso,
	Arm,
	Head,
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

@export var armor_sprite: CompressedTexture2D
@export var armor_bonuses: Array
@export var defense_profile: DefenseProfile
@export var armor_slot: int
@export var armor_type_: int
@export var weapon_actions: Array[WeaponAction]

func _init(armor_type: int):
	initializeDefaults(armor_type)
	
func initializeDefaults(armor_type):
	var sprite_base_path = "res://assets/prototype/Dungeon Crawl Tiles/player"
	var icon_base_path = "res://assets/prototype/Dungeon Crawl Tiles/item/armour"
	armor_type_ = armor_type
	match armor_type:
		ArmorType.no_armor_leg:
			name = "no armor"
			armor_sprite = null
			icon = null
			description = "N/A"
			armor_slot = ArmorSlot.Leg
			defense_profile = DefenseProfile.new(0, 0, 0, 0, 0, 0, 0)
		ArmorType.no_armor_foot:
			name = "no armor"
			armor_sprite = null
			icon = null
			description = "N/A"
			armor_slot = ArmorSlot.Foot
			defense_profile = DefenseProfile.new(0, 0, 0, 0, 0, 0, 0)
		ArmorType.no_armor_torso:
			name = "no armor"
			armor_sprite = null
			icon = null
			description = "N/A"
			armor_slot = ArmorSlot.Torso
			defense_profile = DefenseProfile.new(0, 0, 0, 0, 0, 0, 0)
		ArmorType.no_armor_arm:
			name = "no armor"
			armor_sprite = null
			icon = null
			description = "N/A"
			armor_slot = ArmorSlot.Arm
			defense_profile = DefenseProfile.new(0, 0, 0, 0, 0, 0, 0)
		ArmorType.no_armor_head:
			name = "no armor"
			armor_sprite = null
			icon = null
			description = "N/A"
			armor_slot = ArmorSlot.Head
			defense_profile = DefenseProfile.new(0, 0, 0, 0, 0, 0, 0)
		ArmorType.coat_black:
			var sprite_full_path = sprite_base_path + "/body/coat_black.png"
			var icon_full_path = sprite_full_path
			name = "Black Coat"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			description = "This is a coat, that is black."
			armor_slot = ArmorSlot.Torso
			defense_profile = DefenseProfile.new(9, 9, 9, 9, 9, 9, 0)
		ArmorType.pants_black:
			var sprite_full_path = sprite_base_path + "/legs/pants_black.png"
			var icon_full_path = sprite_full_path
			name = "Black Pants"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Leg
			defense_profile = DefenseProfile.new(5, 5, 5, 5, 5, 5, 0)
		ArmorType.boots_grey:
			var sprite_full_path = sprite_base_path + "/boots/middle_gray.png"
			var icon_full_path = sprite_full_path
			name = "Gray Boots"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Foot
			defense_profile = DefenseProfile.new(2, 2, 2, 2, 2, 2, 0)
		ArmorType.gloves_black_2:
			var sprite_full_path = sprite_base_path + "/gloves/glove_black2.png"
			var icon_full_path = sprite_full_path
			name = "Black Gloves"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Arm
			defense_profile = DefenseProfile.new(2, 2, 2, 2, 2, 2, 0)
		ArmorType.mask_black:
			var sprite_full_path = sprite_base_path + "/head/full_black.png"
			var icon_full_path = sprite_full_path
			name = "Black Mask"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Head
			defense_profile = DefenseProfile.new(4, 4, 4, 4, 4, 4, 0)
		ArmorType.head_random:
			var sprite_full_path = get_random_image(sprite_base_path + "/head/")
			var icon_full_path = sprite_full_path
			name = "Mask"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Arm
			defense_profile = DefenseProfile.new(randi()%5, randi()%5, randi()%5, randi()%5, randi()%5, randi()%5, 0)
		ArmorType.arm_random:	
			var sprite_full_path = get_random_image(sprite_base_path + "/gloves/")
			var icon_full_path = sprite_full_path
			name = "Gloves"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Arm
			defense_profile = DefenseProfile.new(randi()%3, randi()%3, randi()%3, randi()%3, randi()%3, randi()%3, 0)
		ArmorType.torso_random:
			var sprite_full_path = get_random_image(sprite_base_path + "/body/")
			var icon_full_path = sprite_full_path
			name = "Torso"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Torso
			defense_profile = DefenseProfile.new(randi()%10, randi()%10, randi()%10, randi()%10, randi()%10, randi()%10, 0)
		ArmorType.leg_random:
			var sprite_full_path = get_random_image(sprite_base_path + "/legs/")
			var icon_full_path = sprite_full_path
			name = "Leg"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Leg
			defense_profile = DefenseProfile.new(randi()%7, randi()%7, randi()%7, randi()%7, randi()%7, randi()%10, 0)		
		ArmorType.boots_random:	
			var sprite_full_path = get_random_image(sprite_base_path + "/boots/")
			var icon_full_path = sprite_full_path
			name = "boots"
			armor_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			armor_slot = ArmorSlot.Foot
			defense_profile = DefenseProfile.new(randi()%5, randi()%5, randi()%5, randi()%5, randi()%5, randi()%5, 0)
		
