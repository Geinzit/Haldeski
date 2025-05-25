extends Resource
class_name DefenseProfile

@export var values: Dictionary = {
	"slash": 0,
	"pierce": 0,
	"blunt":0,
	"fire": 0,
	"frost": 0,
	"lightning": 0,
	"mental": 0
}

func _init(slash: int, pierce: int, blunt: int, fire: int, frost: int, lightning: int, mental: int):
	values["slash"] = slash
	values["pierce"] = pierce
	values["blunt"] = blunt
	values["fire"] = fire
	values["frost"] = frost
	values["lightning"] = lightning
	values["mental"] = mental
