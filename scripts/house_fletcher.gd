extends VillageHouse

@onready var timer: Timer = $Timer

@export var quiver_scene: PackedScene


func _on_timer_timeout() -> void:
	if not current_state == STATE.BUILT:
		return
	
	print("spawn quivers")
	for pos in spawn_points:
		var q: Quiver = quiver_scene.instantiate()
		q.set_global_position(pos)
		add_child(q)

