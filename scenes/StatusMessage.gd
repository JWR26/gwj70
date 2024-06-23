extends Node2D

class_name StatusMessage


var font := preload("res://assets/fonts/knights-quest.regular.ttf")

class Status extends RefCounted:
	var text:String
	var lifetime:float
	var color:Color
	var position: Vector2
	var size:int = 16

var status : Status = Status.new()
var tween: Tween

func _ready() -> void:
	z_index = 40

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if status.lifetime > 0:
		status.lifetime -= 0.01
		draw_string_outline(font, status.position, status.text, HORIZONTAL_ALIGNMENT_CENTER, -1, status.size, 8, Color(0,0,0,1))
		draw_string(font, status.position, status.text, HORIZONTAL_ALIGNMENT_CENTER, -1, status.size, status.color)

func display_status(text: String, pos: Vector2, size: float = 20, color: Color = Color.WHITE) -> void:
	status.text = text
	status.position = pos - font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, size) / 2
	status.lifetime = .5
	status.color = color
	status.size = size
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	tween.tween_property(status, "position", status.position+Vector2(0,-10), .5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(status, "size", status.size+5, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
