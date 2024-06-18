class_name Fireball

extends Area2D

const SPEED: float = 192.0
@export var damage: int = 1

var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
	get:
		return direction


func _ready() -> void:
	rotation = Vector2.RIGHT.angle_to(direction)


func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta


func _on_body_entered(body: Node2D) -> void:
	if body == owner:
		return
	
	if body is VillageHouse and owner is Dragon:
		body.burn()
	
	if body is Entity:
		body.take_damage(damage, owner)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
