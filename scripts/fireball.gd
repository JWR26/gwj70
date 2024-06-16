class_name Fireball

extends Area2D

const SPEED: float = 128.0
@export var damage: int = 1

var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
	get:
		return direction


func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body == owner:
		return
	
	if body is Entity:
		body.take_damage(damage)
		queue_free()
