extends ItemData
class_name WeaponData

enum WeaponType {
	no_weapon,
	long_sword,
	battle_axe,
	hammer,
	morningstar,
	spear,
	wand,
	holy_scourge,
	ankus,
	great_sword,
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

@export var weapon_sprite: CompressedTexture2D
@export var weapon_actions: Array[WeaponAction]
@export var damage_profile: DamageProfile
@export var damage_attributes: int
@export var weapon_type_: int

func _init(weapon_type: int):
	initializeDefaults(weapon_type)

func haldeski(h, a, l, d, e, s, k, i):
	return 128 * h + 64 * a + 32 * l + 16 *d + 8 * e + 4 * s + 2 * k + i

func initializeDefaults(weapon_type):
	var sprite_base_path = "res://assets/prototype/Dungeon Crawl Tiles/player"
	var icon_base_path = "res://assets/prototype/Dungeon Crawl Tiles/item/weapon"
	weapon_type_ = weapon_type
	match weapon_type:
		WeaponType.no_weapon:
			name = "no weapon"
			weapon_sprite = null
			icon = null
			weapon_actions.clear()
			description = "N/A"
		WeaponType.long_sword:
			var sprite_full_path = sprite_base_path + "/hand1/long_sword.png"
			var icon_full_path = icon_base_path + "/long_sword1.png"
			name = "Long Sword"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.slash))
			weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.cleave))
			description = "An average-sized double-bladed sword. Simplicity in itself."
			damage_attributes = haldeski(0, 0, 0, 0, 0, 1, 0, 0)
		WeaponType.battle_axe:
			var sprite_full_path = sprite_base_path + "/hand1/axe.png"
			var icon_full_path = icon_base_path + "/battle_axe1.png"
			name = "Battle Axe"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.cleave))
			description = "A heavy, sturdy, broad-bladed axe. Favored weapons of those who excel in raw strength."		
		WeaponType.hammer:
			var sprite_full_path = sprite_base_path + "/hand1/hammer2.png"
			var icon_full_path = icon_base_path + "/hammer1.png"
			name = "Hammer"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			#weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.slah))
			description = "A plain, medium sized hammer. Particularly effective against armored enemies."		
		WeaponType.morningstar:
			var sprite_full_path = sprite_base_path + "/hand1/morningstar1.png"
			var icon_full_path = icon_base_path + "/morningstar1.png"
			name = "Hammer"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			#weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.slah))
			description = "A plain, medium sized hammer. Particularly effective against armored enemies."
		WeaponType.spear:
			var sprite_full_path = sprite_base_path + "/hand1/spear1.png"
			var icon_full_path = icon_base_path + "/spear1_elven.png"
			name = "Spear"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			
			description = "A spear that utilizes long range and piercing attacks. One of the most common instruments of warfare."
		WeaponType.wand:
			var sprite_full_path = sprite_base_path + "/hand1/staff_plain.png"
			var icon_full_path = "res://assets/prototype/Dungeon Crawl Tiles/item/wand/gem_lead.png"
			name = "Wand"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			
			description = "A magic wand that does element damage to it targets. Alas, the true arts of mysticism is all but lost to the Maa-Lhed-Iktis, the only remaining are these cheaper imitations."
		
		WeaponType.holy_scourge:
			var sprite_full_path = sprite_base_path + "/hand1/holy_scourge1.png"
			var icon_full_path = "res://assets/prototype/Dungeon Crawl Tiles/item/weapon/holy_scourge.png"
			name = "Holy Scourge"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			
			description = "A holy weapon made by the Bhen-Ed-Iktis to worship their deity, Can be used to both charm and subdue their foes mentally."
		
		WeaponType.ankus:
			var sprite_full_path = sprite_base_path + "/hand1/rod_brown.png"
			var icon_full_path = "res://assets/prototype/Dungeon Crawl Tiles/item/weapon/ankus.png"
			name = "Ankus"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			
			description = "A ritualistic scepter that brings down deadly lightning to its surroundings. A symbolic monument to the Auc-Gne-Ilu"
			
		WeaponType.great_sword:
			var sprite_full_path = sprite_base_path + "/hand1/great_sword.png"
			var icon_full_path = "res://assets/prototype/Dungeon Crawl Tiles/item/weapon/orcish_greate_sword.png"
			name = "Great Sword"
			weapon_sprite = load(sprite_full_path)
			icon = load(icon_full_path)
			
			description = "A huge sword that weighs a ton. In-human strength is required properly use this weapon"
			
		WeaponType.random:
			var sprite_full_path = sprite_base_path + "/hand1/"
			var icon_full_path = "res://assets/prototype/Dungeon Crawl Tiles/item/weapon/"
			weapon_sprite = load(get_random_image(sprite_full_path))
			weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.random))
			weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.random))
			if randi()%2 == 0:
				weapon_actions.append(WeaponAction.new(WeaponAction.ActionType.random))
			icon = load(get_random_image(icon_full_path))
