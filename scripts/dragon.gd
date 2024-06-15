class_name Dragon

extends CharacterBody2D

const SPEED: float = 64.0

signal dragon_killed

var list: Array[CharacterBody2D]


@export var fireball: PackedScene



func _physics_process(delta: float) -> void:
	move_and_slide()


func shoot_fireball(at: Vector2) -> void:
	var f: Area2D = fireball.instantiate()
	f.set_position(position)
	f.direction = (at-global_position).normalized()
	$FireballContainer.add_child(f)
	f.owner = self

func hit() -> void:
	dragon_killed.emit()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Villager or body is Player:
		list.append(body)


func _on_shoot_timer_timeout() -> void:
	if list.is_empty():
		return
	
	shoot_fireball(list.front().global_position)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Villager or body is Player:
		list.erase(body)
