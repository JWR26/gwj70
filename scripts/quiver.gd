class_name Quiver

extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	body.add_arrows(4)
	queue_free()
