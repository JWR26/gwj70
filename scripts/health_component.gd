class_name HealthComponent
## Base class that manages HitPoints for entities. All logic pertaining to health is handled within the class. Other classes wishing to use the health should be connected to the signals provided and not directly access the varialbes.

extends Node

## Emitted each time the hp value is modified.
signal hp_updated(new_value)
## Emitted when the hp reaches zero.
signal hp_depleted
## Emmitted when changing the max_hp value.
signal max_hp_updated(new_value)

## Current HitPoints.
@export var hp: int = 5
## Maximum allowed hit points.
@export var max_hp: int = 5

## Applies negative damage of ammount max_hp to fully restore the hp.
func reset_hp() -> void:
	take_damage(-max_hp)

## modifies the current hp by the passed in value.
func take_damage(value: int) -> void:
	hp = clamp(hp - value, 0, max_hp)
	hp_updated.emit(hp)
	if hp == 0:
		hp_depleted.emit()

## Update the max_hp.
func update_max_hp(value: int) -> void:
	max_hp = value
	hp = value
	max_hp_updated.emit(max_hp)
	hp_updated.emit(hp)

