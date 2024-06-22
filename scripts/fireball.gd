class_name Projectile

extends Area2D


var direction: Vector2 = Vector2.RIGHT:
	set(value):
		direction = value
	get:
		return direction

var fired_by: Entity

@export var data: ProjectileData

func _ready() -> void:
	rotation = Vector2.RIGHT.angle_to(direction)
	$Sprite2D.set_texture(data.texture)


func _physics_process(delta: float) -> void:
	position += direction * data.speed * delta


func configure(by: Entity, from: Vector2, dir: Vector2) -> void:
	fired_by = by
	set_global_position(from)
	direction = dir


func _on_body_entered(body: Node2D) -> void:
	if body == fired_by:
		return
	
	if body is VillageHouse and fired_by is Dragon:
		body.burn()
	
	if body is Entity:
		body.take_damage(data.damage, fired_by)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
