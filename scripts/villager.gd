class_name Villager

extends Entity

@export var arrow: PackedScene

func entity_died() -> void:
	queue_free()
