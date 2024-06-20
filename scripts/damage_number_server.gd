extends Node2D

var font := preload("res://assets/fonts/knights-quest.regular.ttf")

class Hit:
	var position:Vector2
	var amount:String
	var lifetime:float
	var color:Color
	var size:int = 16

var hits : Array[Hit] = []
func _ready() -> void:
	z_index = 30
	#scale = Vector2(0.5, 0.5)

func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var deleted : Array[Hit] = []
	for i in hits:
		i.lifetime -= 0.01
		draw_string_outline(font, i.position, i.amount, HORIZONTAL_ALIGNMENT_LEFT, -1, i.size, 8, Color(0,0,0,1))
		draw_string(font, i.position, i.amount, HORIZONTAL_ALIGNMENT_LEFT, -1, i.size, i.color)
		
		if i.lifetime <= 0:
			deleted.push_back(i)
	
	for i in deleted:
		hits.erase(i)

func display_damage(text:String, pos: Vector2) -> void:
	display_text(text, pos, Color.WHITE)

func display_heal(text:String, pos:Vector2) -> void:
	display_text(text, pos, Color.GREEN)
	
func display_text(text: String, pos: Vector2, color: Color) -> void:
	var nf := Hit.new()
	nf.amount = text
	nf.position = pos
	nf.lifetime = 1.1
	nf.color = color
	nf.size = 10
	
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(nf, "position", nf.position+Vector2(randi_range(-15,15),-30), 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(nf, "size", nf.size+20, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	hits.append(nf)
	
