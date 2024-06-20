extends CharacterBody2D

class_name Entity

@export var health_component: HealthComponent


func take_damage(damage: int, _from: Entity) -> void:
	health_component.take_damage(damage)
