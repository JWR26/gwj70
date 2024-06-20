class_name Fountain

extends StaticBody2D

const HEALTH_RESTORED: int = 10

var can_heal: bool = false
var player: Player

@onready var text_prompt: Label = $Label

func _ready() -> void:
	text_prompt.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not can_heal:
			return
		
		player.heal(HEALTH_RESTORED, self) # negated the damage for a healing effect.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	player = body
	can_heal = true
	text_prompt.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	can_heal = false
	text_prompt.hide()
