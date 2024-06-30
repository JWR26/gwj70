class_name VillagerData
## Base class for the data associated with a villager. This will contain names, ages and other useful data that can be called from inworld. This should allow a small database of villagers to be built, and then populate the world with them randomly

extends Resource

## Villager Name
@export var name: String  = ""

@export var descendents: Array[VillagerData] = []

@export var intro: Array[NarrativeEvent]
@export var declared_traitor: Array[NarrativeEvent]
@export var traitor_death: Array[NarrativeEvent]
@export var death: Array[NarrativeEvent]
@export var victory: Array[NarrativeEvent]
@export var forgivness: Array[NarrativeEvent]
@export var well: Array[NarrativeEvent]


func get_descendent() -> VillagerData:
	if descendents.is_empty():
		return null
	return descendents[randi() % descendents.size()]
