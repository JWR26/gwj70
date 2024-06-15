extends Node2D

var player: Player
var dragon: Dragon

var dragon_killed: bool = false

@onready var camera: GameCamera = $Camera2D
@export var dragon_scene: PackedScene

@export var player_scene: PackedScene


func _input(event: InputEvent) -> void:
	if dragon_killed:
		return
	
	if event.is_action_pressed("ui_accept"):
		add_dragon()
		add_player()
		$CanvasLayer.hide()
	
	if event.is_action_pressed("ui_select"):
		camera.reparent(self)
		camera.reset_position()
		$CanvasLayer.show()
		$CanvasLayer/Label.update_story()


func add_dragon() -> void:
	dragon = dragon_scene.instantiate()
	dragon.set_position(Vector2(960, 384))
	dragon.dragon_killed.connect(_on_dragon_killed)
	add_child(dragon)


func add_player() -> void:
	player = player_scene.instantiate()
	player.set_position(Vector2(704, 384))
	player.player_died.connect(_on_player_killed)
	add_child(player)
	camera.reparent(player)
	camera.reset_position()



func progress_story() -> void:
	camera.reparent(self)
	camera.reset_position()
	$CanvasLayer.show()
	$CanvasLayer/Label.update_story(dragon_killed)


func _on_dragon_killed() -> void:
	call_deferred("remove_child", player)
	dragon_killed = true
	progress_story()


func _on_player_killed() -> void:
	call_deferred("remove_child", dragon)
	progress_story()

