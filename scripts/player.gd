class_name Player

extends Entity

signal player_died()

const SPEED: float = 128.0

var arrows_per_minute: float = 48.0

var is_traitor: bool = false

var arrow_count: int = 6 :
	set(value):
		arrow_count = maxi(0, value)
	get:
		return arrow_count

@onready var cooldown_timer: Timer = $ShootCooldown
@onready var arrow_counter: ArrowCounter = $CanvasLayer/ArrowCounter
@onready var status_message: StatusMessage = $StatusMessage
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_audio: AudioStreamPlayer2D = $ShootAudio

@export var user_input: UserInputComponent
@export var arrow: PackedScene
@export var player_data: VillagerData

var input_blocked := false


func _ready() -> void:
	arrow_counter.update_count(arrow_count)
	sprite.play("idle")


func _input(event: InputEvent) -> void:
	if input_blocked:
		return
	if event.is_action_pressed("attack"):
		shoot(get_global_mouse_position())


func _physics_process(_delta: float) -> void:
	if input_blocked:
		return
	velocity = user_input.get_movement() * SPEED
		
	move_and_slide()
	
	if !is_shooting:
		if velocity.length_squared() > 0.01:
			sprite.play("run")
			sprite.flip_h = velocity.x < 0
		else:
			sprite.play("idle")

var is_shooting = false

func shoot(at: Vector2 = Vector2.RIGHT) -> void:
	
	if not arrow_count > 0:
		status_message.display_status("Need Arrows", Vector2.ZERO, 20, Color.DARK_RED)
		return
	
	if not cooldown_timer.is_stopped():
		return
	
	cooldown_timer.start(60.0 / arrows_per_minute)
	var a: Projectile = arrow.instantiate()
	var dir: Vector2 = global_position.direction_to(at)
	a.configure(self, global_position, dir)
	$Container.add_child(a)
	add_arrows(-1)
	is_shooting = true
	sprite.play("shoot")
	shoot_audio.play()
	sprite.flip_h = (get_global_mouse_position() - global_position).x < 0
	await sprite.animation_finished
	is_shooting = false

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
	
func _on_dialogue_started() -> void:
	input_blocked = true
	
func _on_dialogue_ended() -> void:
	input_blocked = false

