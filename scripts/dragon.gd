class_name Dragon

extends Entity

const SPEED: float = 64.0

signal dragon_killed

var list: Array[Entity]


@export var fireball: PackedScene



func _physics_process(_delta: float) -> void:
	move_and_slide()


func shoot_fireball(at: Vector2) -> void:
	var f: Area2D = fireball.instantiate()
	f.set_position(position)
	f.direction = (at-global_position).normalized()
	$FireballContainer.add_child(f)
	f.owner = self

func entity_died() -> void:
	dragon_killed.emit()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity and body != self:
		list.append(body)


func _on_shoot_timer_timeout() -> void:
	if list.is_empty():
		return
	
	shoot_fireball(list.front().global_position)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Entity and body != self:
		list.erase(body)
