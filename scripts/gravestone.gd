class_name Gravestone

extends StaticBody2D

const HEALTH_RESTORED: int = 3

signal player_mourned(text: String)

var can_mourn: bool = false
var has_mourned: bool = false

var player: Player

var eulogy: String = "Here lies. Burned to ash by the dragon."

@onready var text_prompt: Label = $Label

func _ready() -> void:
	text_prompt.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if not can_mourn:
			return
		
		if has_mourned:
			return
		
		has_mourned = true
		text_prompt.hide()
		player.heal(HEALTH_RESTORED, player) # negated the damage for a healing effect.
		player_mourned.emit(eulogy)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	if has_mourned:
		return
	player = body
	can_mourn = true
	text_prompt.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	can_mourn = false
	text_prompt.hide()


