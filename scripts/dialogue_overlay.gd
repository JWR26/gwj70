class_name DialogueOverlay
## A class for displaying onscreen dialogue acompanied by audio. The Dialogue Overlay consists of two main components a story narration overlay and an event narration.
extends CanvasLayer

## Emitted when the current narrative event has finished
signal narative_finished
## Scroll animation has finished. Only used internally to sequence the dialogue overlay
signal scroll_shown

## Contains the most recent narrative event in the form of an array of NarativeEvents
var current_event: Array[NarrativeEvent] = []
## Current index of the narrative to be displayed
var current_index: int = 0
## True while a story narration is in progress
var is_narrating: bool = false

## Reference to the event panel
@onready var ingame_message: PanelContainer = $IngameMessage
## Reference to the event label
@onready var ingame_message_label: Label = $IngameMessage/Label
## Reference to the narration label
@onready var story_text: Label = $StoryMessage/Label
## Reference to the narration scroll panel background
@onready var story_message: PanelContainer = $StoryMessage


func _input(event: InputEvent) -> void:
	# only process input when a story event is in progress
	if not is_narrating:
		print("Dialogue overaly does not process input")
		return
	
	if event.is_action_pressed("interact"):
		progress_narration()

## Triggers a narrative sequence.
func narrate_story(story: Array[NarrativeEvent]) -> void:
	print("narrating story")
	is_narrating = true
	current_event = story
	current_index = 0
	# story cuts an event short
	$EventAudioPlayer.stop()
	ingame_message.modulate = Color.TRANSPARENT
	
	# animate the appearence of the scroll then start the narration
	show_scroll()
	await scroll_shown
	update_story_text()

## Hides the story narration scroll from the screen, stopping any audio currently playing.
func hide_scroll() -> void:
	# finishing dialogue before the audio ends cuts the audio short
	$NarrativeAudioPlayer.stop()
	is_narrating = false
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(story_text, "modulate", Color.TRANSPARENT, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_text, "visible_ratio", 0.0, 0.1).set_delay(0.3).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(story_message, "custom_minimum_size", Vector2(40, 160), 0.5).set_delay(0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(story_message, "modulate", Color.TRANSPARENT, 0.35).set_delay(0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

## Triggers the appearence of the scroll background
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
	await tween.finished
	scroll_shown.emit()

## Updates the onscreen text display and triggers the start of the narration
func update_story_text() -> void:
	print("updating story")
	var tween: Tween = get_tree().create_tween()
	story_text.modulate = Color.TRANSPARENT
	story_text.set_text(current_event[current_index].text)
	tween.tween_property(story_text, "modulate", Color.WHITE, 0.25).set_delay(0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	# when the updated text appears we will start the audio
	$NarrativeAudioPlayer.set_stream(current_event[current_index].audio)
	await tween.finished
	$NarrativeAudioPlayer.play()

## Advances the narrative
func progress_narration() -> void:
	current_index += 1
	# finish the narration
	if not current_index < current_event.size():
		hide_scroll()
		narative_finished.emit()
		return
	
	update_story_text()

## If a story or event is not being played, play the given event. Shows text on the screen and starts the audio
func narrate_event(event: NarrativeEvent) -> void:
	if $NarrativeAudioPlayer.is_playing():
		return
	
	if $EventAudioPlayer.is_playing():
		return
	
	ingame_message.modulate = Color.TRANSPARENT
	ingame_message_label.set_text(event.text)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(ingame_message, "modulate", Color.WHITE, 1.0)
	$EventAudioPlayer.set_stream(event.audio)
	$EventAudioPlayer.play()


func _on_narrative_audio_player_finished() -> void:
	# Show the prompt to continue the narrative when the audio has finished playing
	$AnimationPlayer.play("prompt_user")


func _on_event_audio_player_finished() -> void:
	# Hide the event message
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(ingame_message, "modulate", Color.TRANSPARENT, 1.0)
