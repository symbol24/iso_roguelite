class_name DestructibleObjective extends Enemy


func _death() -> void:
	queue_free()
