class_name Player

extends Entity

signal player_died

const SPEED: float = 64.0

var arrows_per_minute: float = 48.0

var is_traitor: bool = false

var arrow_count: int = 6 :
	set(value):
		arrow_count = maxi(0, value)
	get:
		return arrow_count

@onready var cooldown_timer: Timer = $ShootCooldown
@onready var arrow_counter: ArrowCounter = $CanvasLayer/ArrowCounter

@export var user_input: UserInputComponent
@export var arrow: PackedScene
@export var player_data: VillagerData


@export var ancestor: VillagerData

func _ready() -> void:
	arrow_counter.update_count(arrow_count)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		shoot(get_global_mouse_position())


func _physics_process(_delta: float) -> void:
	if global_position.x < 64:
		velocity = Vector2.RIGHT * SPEED
	else:
		velocity = user_input.get_movement() * SPEED
	move_and_slide()


func shoot(at: Vector2 = Vector2.RIGHT) -> void:
	if not arrow_count > 0:
		return
	
	if not cooldown_timer.is_stopped():
		return
	
	cooldown_timer.start(60.0 / arrows_per_minute)
	var a: Projectile = arrow.instantiate()
	var dir: Vector2 = global_position.direction_to(at)
	a.configure(self, global_position, dir)
	$Container.add_child(a)
	add_arrows(-1)

func entity_died() -> void:
	player_died.emit()


func add_arrows(value: int) -> void:
	arrow_count += value
	arrow_counter.update_count(arrow_count)


func flee() -> void:
	print("player fleed")
	velocity = Vector2.LEFT * SPEED


func set_traitor() -> void:
	is_traitor = true
