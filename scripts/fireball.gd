class_name Fireball

extends Area2D

const SPEED: float = 128.0

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
	
	if body.has_method("hit"):
		body.hit()
		queue_free()
