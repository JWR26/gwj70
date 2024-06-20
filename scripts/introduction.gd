extends Control

const INTRO_TEXT: PackedStringArray = [
	"A story is only born from the retelling of ages, coveted by humans within dusty mouths and books.",
	"But some stories shift before our very eyes, controlled by the threads of a higher power.",
	"This folklore tale is not one, but of many, and you will see that fate can be played if you are the writer...",
	]


var index: int = 0

var game_scene: String = "res://scenes/world.tscn"

@onready var label: Label = $Label


func update_text() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	tween.tween_property(label, "modulate", Color.TRANSPARENT, 2.0)
	if not index < INTRO_TEXT.size():
		await get_tree().create_timer(2.1).timeout
		get_tree().change_scene_to_file(game_scene)
		return
	
	tween.tween_property(label, "modulate", Color.WHITE, 2.0).set_delay(2.5)
	await get_tree().create_timer(2.1).timeout
	label.set_text(INTRO_TEXT[index])
	index += 1
	$Timer.start(6.0)

