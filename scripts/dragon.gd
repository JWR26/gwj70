class_name Dragon

extends Entity

const SPEED: float = 64.0
const FLEE_SPEED: float = 128.0

signal dragon_killed

signal dragon_flee

var list: Array[Entity]

var dragon_fled: bool = false
var phase: int = 1

var target_pos: Vector2 = Vector2.ZERO

## Distance to stay away from target entity
@export var hover_range: float = 120
@export var fireball: PackedScene

func _physics_process(delta: float) -> void:
	if not list.is_empty():
		target_pos = list[0].global_position
	
	var target_dir := global_position.direction_to(target_pos)
	var target_dist := global_position.distance_to(target_pos) 
	
	if target_dist > hover_range:
		velocity = target_dir * SPEED
	else:
		velocity = target_dir.rotated(PI/2) * SPEED
		
	
	if dragon_fled:
		velocity = global_position.direction_to(Vector2(1200, 1200)) * FLEE_SPEED
	
	move_and_slide()


func shoot_fireball(at: Vector2) -> void:
	var f: Area2D = fireball.instantiate()
	f.set_position(position)
	f.direction = (at-global_position).normalized()
	$FireballContainer.add_child(f)
	f.owner = self #error as owner must be ancestor in the tree...


func next_phase() -> void:
	phase += 1
	dragon_fled = false


func take_damage(damage: int, from: Node) -> void:
	# can't damage the fleeing dragon
	if dragon_fled:
		return
	# dragon can only take damage from the player, rest are for visuals
	if not from is Player:
		return
	
	super.take_damage(damage, owner)


func start_attack(pos: Vector2) -> void:
	target_pos = pos
	dragon_fled = false


func entity_died() -> void:
	dragon_killed.emit()
	super.entity_died()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Entity and body != self:
		list.append(body)
	


func _on_shoot_timer_timeout() -> void:
	if dragon_fled:
		return
	
	if list.is_empty():
		return
	
	list.sort_custom(func(a: Entity, b: Entity): return global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position))
	
	if global_position.distance_to(target_pos) > 320.0:
		return
	
	shoot_fireball(list.front().global_position)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Entity and body != self:
		list.erase(body)



func _on_health_component_hp_updated(new_value: int) -> void:
	if dragon_fled:
		return
	
	if new_value > (health_component.max_hp - (health_component.max_hp / 3.0 * phase)):
		return
	
	dragon_fled = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if dragon_fled:
		dragon_flee.emit()
