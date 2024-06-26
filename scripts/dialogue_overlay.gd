class_name DialogueOverlay

extends CanvasLayer


signal narative_finished

signal story_text_updated

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
	
	story_message.modulate = Color.TRANSPARENT
	story_message.custom_minimum_size = Vector2(40, 160)
	story_text.modulate = Color.TRANSPARENT
	story_text.visible_ratio = 0.0
	
	story_text.set_text(narative)
	
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(story_message, "modulate", Color.WHITE, 0.3).set_delay(0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_message, "custom_minimum_size", Vector2(740, 160), 0.5).set_delay(0.8).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_text, "modulate", Color.WHITE, 0.8).set_delay(1.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_text, "visible_ratio", 1.0, 0.1).set_delay(1.0).set_trans(Tween.TRANS_LINEAR)
	
	
	# old code
	#if narative_displayed:
		#print("updating story")
		#$AnimationPlayer.play("hide_story_text")
		#await $AnimationPlayer.animation_finished
		#story_text.set_text(narative)
		#$AnimationPlayer.play_backwards("hide_story_text")
		#return
	#print("showing story")
	#story_text.set_text(narative)
	#$AnimationPlayer.play("show_story_message")
	#narative_displayed = true
	#if not auto_narrate:
		#await $AnimationPlayer.animation_finished
		#$AnimationPlayer.play("prompt_user")



func narrate_story(story: PackedStringArray) -> void:
	# check there is a voice line for each story line
	
	# first we shall animate the appearence of the scroll
	show_scroll()
	await get_tree().create_timer(1.5).timeout
	
	# update the text and play the voice line, the text updates when each voice line is finished
	var i: int = 0
	for s: String  in story:
		update_story_text(s)
		await story_text_updated
	
	hide_scroll()
	narative_finished.emit()


func hide_scroll() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(story_text, "modulate", Color.TRANSPARENT, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_text, "visible_ratio", 0.0, 0.1).set_delay(0.3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(story_message, "custom_minimum_size", Vector2(40, 160), 0.5).set_delay(0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_message, "modulate", Color.TRANSPARENT, 0.35).set_delay(0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)


func show_scroll() -> void:
	story_text.modulate = Color.TRANSPARENT
	story_text.visible_ratio = 0.0
	story_message.modulate = Color.TRANSPARENT
	story_message.custom_minimum_size = Vector2(40, 160)

	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(story_message, "modulate", Color.WHITE, 0.3).set_delay(0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_message, "custom_minimum_size", Vector2(740, 160), 0.5).set_delay(0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_text, "visible_ratio", 1.0, 0.1).set_delay(1.2).set_trans(Tween.TRANS_LINEAR)



func update_story_text(str: String) -> void:
	var tween: Tween = get_tree().create_tween()
	if story_text.text.length() > 0:
		tween.tween_property(story_text, "modulate", Color.TRANSPARENT, 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await get_tree().create_timer(0.6).timeout
	story_text.set_text(str)
	tween = get_tree().create_tween()
	tween.tween_property(story_text, "modulate", Color.WHITE, 0.6).set_delay(0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().create_timer(3.0).timeout
	story_text_updated.emit()



func hide_story() -> void:
	print("hiding story")
	$AnimationPlayer.play_backwards("show_story_message")
	narative_displayed = false
	await $AnimationPlayer.animation_finished
	narative_finished.emit()
	ingame_message.visible = true

