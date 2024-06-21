extends CharacterBody2D

class_name Entity

@export var health_component: HealthComponent


func take_damage(damage: int, from: Entity) -> void:
	DamageNumbersServer.display_damage(str(damage), global_position)
	health_component.take_damage(damage)

func heal(amount: int, from: Node) -> void:
	DamageNumbersServer.display_heal(str(amount), global_position)
	health_component.take_damage(-amount)

func entity_died() -> void:
	queue_free()
