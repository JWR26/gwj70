class_name GameCamera

extends Camera2D


func focus_on(pos: Vector2 = Vector2.ZERO, zoom_in: Vector2 = Vector2.ONE) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", Vector2.ZERO, 0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "offset", pos, 0.75)
	tween.tween_property(self, "zoom", zoom_in, 0.75)
