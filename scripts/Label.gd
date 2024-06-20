extends Label

signal narative_finished

func update_story(narative_text: String) -> void:
	set_text(narative_text)
	await get_tree().create_timer(5.0).timeout
	narative_finished.emit()
