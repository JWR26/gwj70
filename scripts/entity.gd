extends CharacterBody2D

class_name Entity

@export var health: int

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		entity_died()

func entity_died() -> void:
	pass
