class_name Player

extends CharacterBody2D

signal player_died

const SPEED: float = 64.0

@export var user_input: UserInputComponent
@export var arrow: PackedScene


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		shoot()


func _physics_process(delta: float) -> void:
	velocity = user_input.get_movement() * SPEED
	move_and_slide()


func shoot() -> void:
	var a: Area2D = arrow.instantiate()
	a.set_position(position)
	$Container.add_child(a)
	a.owner = self

func hit() -> void:
	player_died.emit()
	queue_free()
