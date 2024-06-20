class_name VillageHouse

extends StaticBody2D

enum  STATE {
	NONE,
	BUILT,
	BURNING,
	ASHES,
	}

const HOUSE_SPRITES: Array[Texture2D] = [
	preload("res://assets/art/house_none.png"),
	preload("res://assets/art/house.png"),
	preload("res://assets/art/house_fire.png"),
	preload("res://assets/art/house_ashes.png"),
	]

var current_state: STATE = STATE.NONE

@export var spawn_points: Array[Vector2] = []

func _ready() -> void:
	progress_state()


func burn() -> void:
	if not current_state == STATE.BUILT:
		return
	
	current_state = STATE.BURNING
	$Sprite2D.set_texture(HOUSE_SPRITES[current_state])


func progress_state() -> void:
	if current_state == STATE.BUILT:
		return
	
	current_state += 1
	current_state %= 4
	$CollisionShape2D.set_deferred("disabled", current_state == STATE.NONE)
	$Sprite2D.set_texture(HOUSE_SPRITES[current_state])


func get_spawn_points() -> Array:
	if current_state != STATE.BUILT:
		return []
	
	return spawn_points.map(func(vec: Vector2) -> Vector2: return vec + global_position)

