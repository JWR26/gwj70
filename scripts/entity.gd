extends CharacterBody2D

class_name Entity

@export var health_component: HealthComponent


func take_damage(damage: int, from: Node) -> void:
	health_component.take_damage(damage)

func entity_died() -> void:
	queue_free()
