class_name VillageHouse

extends StaticBody2D

enum  STATE {
	NONE,
	BUILT,
	BURNING,
	ASHES,
	}


var current_state: STATE = STATE.NONE

@export var spawn_points: Array[Vector2] = []

@export var house_texture: Sprite2D
@export var burned_texture: Sprite2D

func _ready() -> void:
	progress_state()


func burn() -> void:
	if not current_state == STATE.BUILT:
		return
	
	current_state = STATE.BURNING
	burned_texture.show()
	house_texture.hide()
	print("Burning. House state: ", current_state)

func progress_state() -> void:
	print("House state: ", current_state)
	if current_state != STATE.BUILT:
		current_state += 1
		current_state %= 4
	
	$CollisionShape2D.set_deferred("disabled", current_state == STATE.NONE)
	print("House state updated to: ", current_state)
	
	if current_state == STATE.BUILT:
		burned_texture.hide()
		house_texture.show()
		return
	
	if current_state == STATE.ASHES:
		burned_texture.show()
		house_texture.hide()
		return
	
	burned_texture.hide()
	house_texture.hide()
	


func get_spawn_points() -> Array:
	if current_state != STATE.BUILT:
		return []
	
	return spawn_points.map(func(vec: Vector2) -> Vector2: return vec + global_position)

