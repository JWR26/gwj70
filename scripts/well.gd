class_name VillageWell

extends StaticBody2D

signal entered_well

const DAMAGE: int = 100

var can_hide: bool = false
var player: Player

@onready var text_prompt: Label = $Label


func _ready() -> void:
	text_prompt.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not can_hide:
			return
		
		entered_well.emit()




func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player = body
	can_hide = true
	text_prompt.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	can_hide = false
	text_prompt.hide()

