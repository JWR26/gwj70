class_name ArrowCounter

extends PanelContainer

@onready var count: Label = $HSplitContainer/Count

func update_count(value: int) -> void:
	count.set_text(str(value))
