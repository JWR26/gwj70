class_name VillageExit

extends Area2D




func _on_body_entered(body: Player) -> void:
	if not body:
		return
	
	body.flee()
