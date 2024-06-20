class_name HealthBar
## Functionality for the healthbar

extends PanelContainer

const DELAY: float = 0.4

@onready var over: TextureProgressBar = $Over
@onready var under: TextureProgressBar = $Under
@onready var hp_label: Label = $Label

@export var initial_health: int = 5 :
	set(value):
		initial_health = value

func _ready() -> void:
	update_max_health(initial_health)
	over.value = over.max_value
	under.value = under.max_value
	display_hp(over.value, over.max_value)


func update_max_health(value: int) -> void:
	over.max_value = value
	under.max_value = value


func display_hp(value: int, max_hp: int) -> void:
	var text: String = str(value) + " / " + str(max_hp)
	hp_label.set_text(text)


func update_hp(value: int) -> void:
	var tween: Tween = get_tree().create_tween()
	var immediate_bar: TextureProgressBar = under if value == over.max_value else over
	var delayed_bar: TextureProgressBar = over if value == over.max_value else under
	immediate_bar.value = value
	display_hp(value, under.max_value)
	tween.tween_property(delayed_bar, "value", value, DELAY).set_delay(DELAY).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
