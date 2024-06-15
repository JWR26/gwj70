class_name UserInputComponent

extends InputComponent


func get_movement() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
