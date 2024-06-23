class_name GameManager

extends Node

const FOUNTAIN_MESSAGE: PackedStringArray = [
	"To combat the fire’s searing touch, %s scooped up some water from the village fountain. Amazingly the water healed %s's wounds. The magic of hydration."
	]

const INTRO_TEXT: PackedStringArray = [
	"Now enough of that high fantasy blather, this is a tale of greed’s consequence. And it concerns a man called Osric.",
	"His tale begins as the young man is hurrying back on his little sprite legs to Dragonnosh Village after stealing a mystical dragon’s egg. Bad idea you say? You don’t need to tell me, as the dragon had followed his trail.",
	"It gave Osric a chance to hand over the egg and it would flap away. But if refused, it would make charred human skewers for entertainment, returning annually to wreak havoc. Standard dragon behaviour.",
	"Our egg-stealer wanted fame, so he looked at the dragon and said, “Do one.”",
	]

const OSTRIC: VillagerData = preload("res://resources/villagers/ostric.tres")
const MYRABETH: VillagerData = preload("res://resources/villagers/myrabeth.tres")

var player: Player
var dragon: Dragon

var dragon_killed: bool = false
var first_run: bool = true
var traitor_threshold: int = 2
var recursing: bool = true

@onready var camera: GameCamera = $Camera2D
@onready var dialogue_overlay: DialogueOverlay = $DialogueOverlay

@export var dragon_scene: PackedScene
@export var player_scene: PackedScene
@export var villager_scene: PackedScene
@export var gravestone_scene: PackedScene

@export var character_list: Array[VillagerData]

func _ready() -> void:
	character_list.shuffle()
	character_list.push_back(MYRABETH)
	character_list.push_back(OSTRIC)
	start_story()
	dialogue_overlay.auto_narrate = true
	for text in INTRO_TEXT:
		dialogue_overlay.show_story(text)
		await get_tree().create_timer(text.length() * 0.055).timeout
		#await get_tree().create_timer(1.0).timeout
	dialogue_overlay.hide_story()
	dialogue_overlay.auto_narrate = false


func add_dragon() -> void:
	if not dragon:
		dragon = dragon_scene.instantiate()
		dragon.dragon_killed.connect(_on_dragon_killed)
	
	add_child(dragon)


func add_player(data: VillagerData) -> void:
	player = player_scene.instantiate()
	player.set_position(Vector2(640, 640))
	player.player_died.connect(_on_player_killed)
	player.player_data = data
	add_child(player)
	camera.reparent(player)
	camera.focus_on(Vector2(0,32), Vector2(4,4))
	dialogue_overlay.show_story(player.player_data.intro)
	character_list.erase(data)


func advance_world_state() -> void:
	# update the houses and spawn the villagers
	for child in get_children():
		if child is VillageHouse:
			child.progress_state()
			add_villagers(child)
	
	if character_list.is_empty():
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
		return
	
	var next: VillagerData = player.player_data.get_descendent()
	if next == null:
		next = character_list.front()
	add_player(next)


func clean_scene() -> void:
	for child in get_children():
		if child is Villager:
			child.queue_free()
		
		if child is Quiver:
			child.queue_free()
		
		if child is Projectile:
			child.queue_free()
		
		if child is Gravestone:
			child.has_mourned = false


func progress_story(text: String) -> void:
	clean_scene()
	dialogue_overlay.show_story(text)


func start_story() -> void:
	# update the houses and spawn the villagers
	for child in get_children():
		if child is VillageHouse:
			child.progress_state()
			add_villagers(child)
	add_player(OSTRIC)


func _on_dragon_killed() -> void:
	dragon_killed = true
	call_deferred("remove_child", player)
	call_deferred("remove_child", dragon)
	clean_scene()
	progress_story(player.player_data.victory)

func _on_player_killed() -> void:
	remove_child(dragon)
	var gravestone_text: String = "Here lies %s. Slain by the scaled beast" % player.player_data.name
	place_graveston(player.global_position, gravestone_text)
	remove_child(player)
	clean_scene()
	if traitor_threshold > 0:
		progress_story(player.player_data.death)
	else:
		progress_story(player.player_data.traitor)
	traitor_threshold = 2


func add_villagers(house: VillageHouse) -> void:
	for pos: Vector2 in house.get_spawn_points():
		var v: Villager = villager_scene.instantiate()
		v.set_global_position(pos)
		v.villager_killed_by_player.connect(_on_villager_killed_by_player)
		add_child(v)


func _on_villager_killed_by_player() -> void:
	traitor_threshold -= 1
	if traitor_threshold == 0:
		player.set_traitor()
		var traitor_text: String = "%s is attacking us! Death to the Traitor!" % player.player_data.name
		dialogue_overlay.show_ingame_message(traitor_text)


func _on_dialogue_overlay_narative_finished() -> void:
	if dragon_killed:
		get_tree().change_scene_to_file("res://scenes/ending.tscn")
		return
	if recursing:
		print("no advance")
		camera.focus_on()
		add_dragon()
		recursing = false
		return
	# ostric is on the first playthoug so add the dragon and get playing
	recursing = true
	print("advancing world state")
	advance_world_state()
	return


func _on_fountain_fountain_used() -> void:
	randomize()
	var i: int = randi() % FOUNTAIN_MESSAGE.size()
	var text: String = FOUNTAIN_MESSAGE[i].replace("%s", player.player_data.name)
	dialogue_overlay.show_ingame_message(text)


func _on_well_entered_well() -> void:
	remove_child(player)
	remove_child(dragon)
	camera.reparent($Well)
	print("pan to well")
	camera.focus_on(Vector2(0, 32), Vector2(2,2))
	progress_story(player.player_data.well)



func _on_gravestone_player_mourned(text: String) -> void:
	dialogue_overlay.show_ingame_message(text)


func place_graveston(at: Vector2, text: String) -> void:
	# dont put a gravestone too close to a house
	for child in get_children():
		if not child is VillageHouse:
			continue
		if child.global_position.distance_to(at) < 96.0:
			return
	
	var g: Gravestone = gravestone_scene.instantiate()
	g.eulogy = text
	g.set_global_position(at)
	g.player_mourned.connect(_on_gravestone_player_mourned)
	call_deferred("add_child", g)
	camera.call_deferred("reparent", g)
	print("pan to gravestone")
	camera.focus_on(Vector2(0, 64), Vector2(2,2))


