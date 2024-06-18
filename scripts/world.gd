extends Node2D

const UPGRADE_DIALOGUE: PackedStringArray = [
	"During the dragon's absence, the villagers built a workshop and Fletchers got to work crafting more arrows...",
	"Unbeknown to the villagers, a strange whitch emptied a vial into the fountain...",
	]


var player: Player
var dragon: Dragon

var dragon_killed: bool = false
var generation_count: int = 0

var dragon_defeated_by: Array[VillagerData] = []

@onready var book_overlay: StoryBook = $CanvasLayer/Book

@onready var camera: GameCamera = $Camera2D
@export var dragon_scene: PackedScene

@export var player_scene: PackedScene
@export var houses: Array[VillageHouse]

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
	if not dragon:
		dragon = dragon_scene.instantiate()
		dragon.dragon_killed.connect(_on_dragon_killed)
		dragon.dragon_flee.connect(_on_dragon_flee)
	
	add_child(dragon)
	dragon.start_attack(Vector2(960, 384))


func add_player() -> void:
	if not player:
		player = player_scene.instantiate()
		player.set_position(Vector2(704, 384))
		player.player_died.connect(_on_player_killed)
	add_child(player)
	camera.reparent(player)
	camera.reset_position()



func progress_story(focal_point: Node) -> void:
	generation_count += 1
	
	camera.reparent(focal_point)
	camera.reset_position()
	
	for child in get_children():
		if child is VillageHouse:
			child.progress_state(generation_count)
	
	$CanvasLayer.show()
	
	$CanvasLayer/Label.update_story(dragon_killed)


func _on_dragon_killed() -> void:
	update_story()
	call_deferred("remove_child", player)
	for v in dragon_defeated_by:
		print(v.name)
	dragon_killed = true
	progress_story(self)


func _on_player_killed() -> void:
	call_deferred("remove_child", dragon)
	progress_story(self)


func _on_dragon_flee() -> void:
	print("dragon fled and is offscreen")
	update_story()
	call_deferred("remove_child", dragon)
	call_deferred("remove_child", player)
	progress_story(self)


func update_story() -> void:
	if dragon_defeated_by.find(player.player_data) == -1:
		dragon_defeated_by.append(player.player_data)

