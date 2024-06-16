extends Control

const INTRO_TEXT: PackedStringArray = [
	"Tales are passed from generation to generation.",
	"With origins no longer truely known, each listener will experience the enthraling tale of the teller.",
	"And in turn, go on to tell their own interpritation of the events they were told.",
	"These tales are folklore.",
	"Its time I told you a story that someone once told me...",
	]


var index: int = 0

var game_scene: String = "res://scenes/world.tscn"

@onready var label: Label = $Label


func update_text() -> void:
	if not index < INTRO_TEXT.size():
		get_tree().change_scene_to_file(game_scene)
		return
	
	label.modulate = Color.TRANSPARENT
	label.set_text(INTRO_TEXT[index])
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color.WHITE, 2.0)
	index += 1
	$Timer.start(6.0)
