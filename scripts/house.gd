class_name VillageHouse

extends StaticBody2D

enum  STATE {
	NONE,
	BUILT,
	BURNING,
	ASHES,
	GONE,
	}

var current_state: STATE = STATE.NONE
var burned: bool = false

@export var generation: int = 0

func burn() -> void:
	if burned:
		return
	
	if current_state == STATE.NONE:
		return
	
	burned = true
	$Sprite2D2.show()
	current_state = STATE.BURNING


func progress_state(wave: int = 0) -> void:
	if current_state == STATE.ASHES:
		current_state = STATE.GONE
		$Sprite2D3.hide()
	
	if current_state == STATE.BURNING:
		current_state = STATE.ASHES
		$Sprite2D2.hide()
		$Sprite2D3.show()
		$Sprite2D.hide()
	
	if current_state == STATE.NONE and wave == generation:
		current_state = STATE.BUILT
		$Sprite2D4.show()
		$Sprite2D.show()
	
	
