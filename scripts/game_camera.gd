class_name GameCamera

extends Camera2D


func reset_position() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)


