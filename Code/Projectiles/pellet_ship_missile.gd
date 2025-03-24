class_name PelletShipMissile extends Projectile


func setup_attack(_data:ActionData, _owner:Node2D, pos:Vector2 = Vector2.ZERO, rot:float = 0.0) -> void:
	data = _data
	attack_owner = _owner
	if pos != Vector2.ZERO:
		global_position = pos
		origin = pos
	scale *= 1 + data.projectile_size + attack_owner.data.projectile_size
	rotation = rot + randf_range(-0.1, 0.1)
	direction = direction.rotated(rotation)
	life_timer = data.projectile_life_time
