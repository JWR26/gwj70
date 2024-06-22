class_name DialogueOverlay

extends CanvasLayer

signal narative_finished

var auto_narrate: bool = true
var narative_displayed: bool = false

@onready var ingame_message: PanelContainer = $IngameMessage
@onready var message_label: Label = $IngameMessage/Label
@onready var story_text: Label = $StoryMessage/Label
@onready var story_message: PanelContainer = $StoryMessage


func _input(event: InputEvent) -> void:
	if not narative_displayed:
		return
	
	if auto_narrate:
		return
	
	if event.is_action_pressed("ui_select"):
		hide_story()


func show_ingame_message(message: String) -> void:
	message_label.set_text(message)
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(ingame_message, "modulate", Color.WHITE, 0.2)
	tween.tween_property(message_label, "modulate", Color.WHITE, 0.25).set_delay(0.15)
	tween.tween_property(ingame_message, "modulate", Color.TRANSPARENT, 0.2).set_delay(4)
	tween.tween_property(message_label, "modulate", Color.TRANSPARENT, 0.25).set_delay(4.1)


func show_story(narative: String) -> void:
	ingame_message.visible = false
	$StoryMessage/Label2.visible = not auto_narrate
	if narative_displayed:
		print("updating story")
		$AnimationPlayer.play("hide_story_text")
		await $AnimationPlayer.animation_finished
		story_text.set_text(narative)
		$AnimationPlayer.play_backwards("hide_story_text")
		return
	print("showing story")
	story_text.set_text(narative)
	$AnimationPlayer.play("show_story_message")
	narative_displayed = true
	if not auto_narrate:
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play("prompt_user")


func hide_story() -> void:
	print("hiding story")
	$AnimationPlayer.play_backwards("show_story_message")
	narative_displayed = false
	await $AnimationPlayer.animation_finished
	narative_finished.emit()
	ingame_message.visible = true

