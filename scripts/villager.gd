class_name Villager

extends Entity

const SPEED: float = 48.0

var arrows_per_minute: float = 24.0
var dragon: Dragon

var hover_range: float = 100.0

@export var quiver: PackedScene
@export var arrow: PackedScene


func _physics_process(delta: float) -> void:
	if not dragon:
		return
	
	var target_dir := global_position.direction_to(dragon.global_position)
	var target_dist := global_position.distance_to(dragon.global_position) 
	
	if target_dist > hover_range:
		velocity = target_dir * SPEED
	else:
		velocity = Vector2.ZERO
		
	
	move_and_slide()


func entity_died() -> void:
	var q: Quiver = quiver.instantiate()
	q.set_global_position(global_position)
	get_parent().call_deferred("add_child", q)
	super.entity_died()


func shoot(at: Vector2 = Vector2.RIGHT) -> void:
	var a: Area2D = arrow.instantiate()
	a.set_position(position)
	var dir: Vector2 = global_position.direction_to(at)
	a.direction = dir
	$Container.add_child(a)
	a.owner = self



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Dragon:
		dragon = body


func _on_shoot_timer_timeout() -> void:
	if not dragon:
		return
	
	if global_position.distance_to(dragon.global_position) > 280.0:
		return
	
	shoot(dragon.global_position)
