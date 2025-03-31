class_name ObjectiveArrow extends Control


var target_position:Vector2 = Vector2.ZERO
var player:Character = null


func _process(_delta: float) -> void:
	_update_rotation()


func _update_rotation() -> void:
	if target_position != Vector2.ZERO and player != null:
		var target_angle:float = Vector2.UP.angle_to(target_position)
		rotation = target_angle
