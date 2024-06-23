class_name Dragon

extends Entity

enum  STATE {
	PHASE_1,
	PHASE_2,
	PHASE_3,
	DEAD,
	}

const SPEED: Array[float] = [
	128.0,
	96.0,
	128.0,
	0.0,
	]

const START_POSITION: Vector2 = Vector2(640, 128)

signal dragon_killed

var entity_list: Array[Entity]

var current_state: STATE = STATE.PHASE_1

## Distance to stay away from target entity
@export var hover_range: float = 120
@export var fireball: PackedScene
@onready var right_wing_sprite: Sprite2D = $Body/RightWingSprite
@onready var body_sprite: Sprite2D = $Body/BodySprite
@onready var left_wing_sprite: Sprite2D = $Body/LeftWingSprite

var facing_right := false

func _ready() -> void:
	set_global_position(START_POSITION)
	request_ready()


func _physics_process(_delta: float) -> void:
	velocity = get_direction() * SPEED[current_state]
	move_and_slide()
	update_animation()

func update_animation() -> void:
	right_wing_sprite.flip_h = facing_right
	body_sprite.flip_h = facing_right
	left_wing_sprite.flip_h = facing_right
	
## returns the direction the dragon will travel based on the current_state.
func get_direction() -> Vector2:
	if current_state == STATE.PHASE_1:
		var target_pos: Vector2 = Vector2(512, 512)
		if not entity_list.is_empty():
			target_pos = entity_list[0].global_position
		
		var target_dir := global_position.direction_to(target_pos)
		var target_dist := global_position.distance_to(target_pos) 
		
		facing_right = target_dir.x > 0.01
		if target_dist > hover_range:
			return target_dir
		
		return target_dir.rotated(PI/2)
	
	return Vector2.ZERO



func shoot_fireball(at: Vector2) -> void:
	var a: Projectile = fireball.instantiate()
	var dir: Vector2 = global_position.direction_to(at)
	a.configure(self, global_position, dir)
	get_parent().add_child(a)


func take_damage(damage: int, from: Entity) -> void:
	# can't damage the fleeing dragon or the dead dragon
	if current_state > 2:
		return
	# dragon can only take damage from the player, rest are for visuals
	if not from is Player:
		return
	
	super.take_damage(damage, from)


func entity_died() -> void:
	current_state = STATE.DEAD
	dragon_killed.emit()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity and body != self:
		entity_list.append(body)
	


func _on_shoot_timer_timeout() -> void:
	if current_state == STATE.DEAD:
		return
	
	if entity_list.is_empty():
		return
	
	entity_list.sort_custom(func(a: Entity, b: Entity) -> bool: return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
	
	var target_pos: Vector2 = entity_list.front().global_position
	
	if global_position.distance_to(target_pos) > 320.0:
		return
	
	shoot_fireball(target_pos)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Entity and body != self:
		entity_list.erase(body)


