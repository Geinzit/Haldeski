extends Actor
class_name Enemy

var hitbox: Area2D

enum EnemyType{
	animals,
	demons,
	draco,
	fungi_plants,
	holy,
	nonliving,
	spriggan,
	statues,
	undead,
	undead_skeletons,
	undead_spectrals,
	unique,
	npc,
	abberations,
	abyss,
	amorphous,
	dragons,
	eyes,
	vault,
}

enum EnemyAI {
	aggressive,
	defensive,
	immobile,
	cowardly,
	chaotic
}

enum EnemyAggro {
	hate,
	dislike,
	neutral,
	like,
	love
}

var enemy_aggro
var enemy_AI

var damage_profile: DamageProfile

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

func initialize(enemy_type: int):
	var enemy_sprite = $EnemySprite
	var sprite_base_path = "res://assets/prototype/Dungeon Crawl Stone Soup Supplemental/monster/"
	defense_profile = DefenseProfile.new(randi() % 30, randi() % 30, randi() % 30, randi() % 30, randi() % 30, randi() % 30, randi() % 30)
	damage_profile = DamageProfile.new(randi() % 10, randi() % 10, randi() % 10, randi() % 10, randi() % 10, randi() % 10, randi() % 10)
	match enemy_type:
		EnemyType.animals:
			sprite_base_path += "animals/"
			
		EnemyType.demons:
			sprite_base_path += "demons/"
			
		EnemyType.draco:
			sprite_base_path += "draconic/"
			
		EnemyType.fungi_plants:
			sprite_base_path += "fungi_plants/"
			
		EnemyType.holy:
			sprite_base_path += "holy/"
		EnemyType.nonliving:
			sprite_base_path += "nonliving/"
			
		EnemyType.spriggan:
			sprite_base_path += "spriggan/"
			pass
		EnemyType.statues:
			sprite_base_path += "statues/"
			pass
		EnemyType.undead:
			sprite_base_path += "undead/"
			pass
		EnemyType.undead_skeletons:
			sprite_base_path += "undead/skeletons/"
			pass
		EnemyType.undead_spectrals:
			sprite_base_path += "undead/spectrals/"
			pass
		EnemyType.unique:
			sprite_base_path += "unique/"
			pass
		EnemyType.npc:
			pass
		EnemyType.abberations:
			sprite_base_path += "aberration/"
			pass
		EnemyType.abyss:
			sprite_base_path += "abyss/"
			pass
		EnemyType.amorphous:
			sprite_base_path += "amorphous/"
			pass
		EnemyType.dragons:
			sprite_base_path += "dragons/"
			pass
		EnemyType.eyes:
			sprite_base_path += "eyes/"
			pass
		EnemyType.vault:
			sprite_base_path += "vault/"
			pass
	var sprite_path = get_random_image(sprite_base_path)
	#print(sprite_path)
	enemy_sprite.texture = load(sprite_path)
	
	enemy_AI = randi() % 5
	
	# hitbox-related
	hitbox = $Hitbox
	hitbox.area_entered.connect(Callable(hitboxEnteredCallback))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func hitboxEnteredCallback(area: Area2D):
	print("hit!...")
	var action = area.get_parent()
	if action and action is Action:
		print("is Action!!!")
		var weapon_action = action.weapon_action
		takeDamage(weapon_action)

func barUpdate():
	var health_bar = $EnemySprite/Healthbar
	var mental_bar = $EnemySprite/Mentalbar
	# print("updating bar...")
	health_bar.size.x = int(32.0 * hp / max_hp)
	if mental >= 0:
		mental_bar.color = Color(0, 1, 0, 0)
	else:
		mental_bar.color = Color(1, 1, 1, 0)
	mental_bar.size.x = int(32.0 * abs(mental) / 100)

func dis(a: Vector2, b: Vector2):
	return abs(a.x - b.x) + abs(a.y - b.y)

var messages = [
	"In endless conflict are we doomed... We, the woeful Maa-Lhed-Ikti...", 
	"you aren't welcome here, stranger... Best leave if you value your life...",
	"Do you hold any hatred still? Careful, shouldst you wield it as a weapon, as it only ever grows...",
	"Another one seeking answers? Hate to break it to you but, only despair layeth yonder...",
	"Go away, please... I wish not to speak...",
	"Keep that sword arm steady, you might not have it soon...",
	"Curse my wretched weakness. I am Maa-Lhed-Ikti, I was born to fight, not rotting paralyzed in this stink hole!",
	"Please, all mighty Caretaker! Heed the plees of your rueful subjugates, have you not taken enough?...",
	"Don't go crazy with that scary weapon of yours. Not eveyone is mad out for blood here.",
	"It's no use... He has forsaken us. Redemption for us was not his intention, but eternal suffer..."
	]

func actionUpdate():
	if hp <= 0:
		queue_free()
	if !is_moving:
		var pos = GameplayManager.player_pos
		var rx = [1, 0, -1, 0]
		var ry = [0, 1, 0, -1]
		var i = randi() % 4
		if enemy_AI == EnemyAI.aggressive:
			var new_p: Vector2 = Vector2(position.x + rx[i], position.y + ry[i]) 
			if dis(position, pos) < 10 * 32 and dis(new_p, pos) < dis(position, pos):
				moveIn(Vector2(rx[i], ry[i]), 0.5)
			else:
				moveIn(Vector2(rx[i], ry[i]), 0.5)
		elif enemy_AI == EnemyAI.defensive:
			if randi() % 4 == 0:
				moveIn(Vector2(rx[i], ry[i]), 0.5)
		elif enemy_AI == EnemyAI.immobile:
			if dis(position, pos) <= 64:
				print("should show message...")
				Inventory.emit_signal("show_message", messages[randi() % messages.size()] , 7.0)
			pass
		elif enemy_AI == EnemyAI.cowardly:
			moveIn(Vector2(rx[i], ry[i]), 0.5)
		elif enemy_AI == EnemyAI.cowardly:
			moveIn(Vector2(rx[i], ry[i]), 0.5)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	barUpdate()
	
	actionUpdate()
	pass
