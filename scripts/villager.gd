class_name Villager

extends CharacterBody2D

@export var arrow: PackedScene



func hit() -> void:
	queue_free()
