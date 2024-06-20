class_name Villager

extends Entity

const SPEED: float = 48.0

signal villager_killed_by_player


var arrows_per_minute: float = 24.0
var dragon: Dragon
var player: Player

var target: Entity

var hover_range: float = 100.0

var is_dead: bool = false

@export var quiver: PackedScene
@export var arrow: PackedScene


func _physics_process(_delta: float) -> void:
	if is_dead:
		return
	
	if not target:
		return
	
	var target_dir := global_position.direction_to(target.global_position)
	var target_dist := global_position.distance_to(target.global_position) 
	
	if target_dist > hover_range:
		velocity = target_dir * SPEED
	else:
		velocity = Vector2.ZERO
		
	
	move_and_slide()


func entity_died() -> void:
	var q: Quiver = quiver.instantiate()
	q.set_global_position(global_position)
	get_parent().call_deferred("add_child", q)
	is_dead = true
	hide()
	$CollisionShape2D.set_deferred("disabled", true)


func shoot(at: Vector2 = Vector2.RIGHT) -> void:
	if is_dead:
		return
	var a: Projectile = arrow.instantiate()
	var dir: Vector2 = global_position.direction_to(at)
	a.configure(self, global_position, dir)
	get_parent().add_child(a)


func take_damage(damage: int, from: Entity) -> void:
	if is_dead:
		return
	if from is Player:
		villager_killed_by_player.emit()
	
	super.take_damage(damage, from)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	
	if body is Dragon:
		dragon = body
		return
	
	if body is Player:
		player = body
		return


func _on_shoot_timer_timeout() -> void:
	if is_dead:
		return
	
	target = determine_target()
	
	if not target:
		return
	
	if global_position.distance_to(target.global_position) > 280.0:
		return
	
	shoot(target.global_position)


func determine_target() -> Entity:
	var player_distance: float = 500000.0 # large number
	var dragon_distance: float = 500000.0
	
	if player:
		if player.is_traitor:
			player_distance = global_position.distance_to(player.global_position)
	
	if dragon:
		dragon_distance = global_position.distance_to(dragon.global_position)
	
	if player_distance < dragon_distance:
		return player
	
	return dragon
