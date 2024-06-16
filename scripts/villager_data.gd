class_name VillagerData
## Base class for the data associated with a villager. This will contain names, ages and other useful data that can be called from inworld. This should allow a small database of villagers to be built, and then populate the world with them randomly

extends Resource

## Villager Name
@export var name: String  = ""
## Villager age
@export var age: int = 0
## This contains a single sentence of dialogue that can be displayed above the villager when the dragon has fled.
@export var post_combat_dialogue: String = ""
## The dialogue that is displayed on a villager inhabiting the final world
@export var end_game_dialogue: String = ""
## To be said about the player upon their death when playing as this villager
@export var death_description: String = ""
## To be said about the player who slays the dragon, who will obviously be dead at the point of telling the tale.
@export var eulogy: String = ""
