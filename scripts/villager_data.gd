class_name VillagerData
## Base class for the data associated with a villager. This will contain names, ages and other useful data that can be called from inworld. This should allow a small database of villagers to be built, and then populate the world with them randomly

extends Resource

## Villager Name
@export var name: String  = ""

@export var descendents: Array[VillagerData] = []

@export_multiline var intro: String
@export_multiline var traitor: String
@export_multiline var death: String
@export_multiline var victory: String
@export_multiline var well: String


func get_descendent() -> VillagerData:
	if descendents.is_empty():
		var next: VillagerData = load("res://resources/villagers/myrabeth.tres")
		return next.get_descendent()
	return descendents[randi() % descendents.size()]
