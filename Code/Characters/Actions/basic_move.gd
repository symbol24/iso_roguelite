class_name BasicMove extends CharacterAction


var direction:Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if can_act:
		direction = Input.get_vector("left", "right", "up", "down")
		character.apply_central_force(direction * character.data.speed)
		character.linear_velocity.x = clampf(character.linear_velocity.x, -(character.data.speed/2), character.data.speed/2)
		character.linear_velocity.y = clampf(character.linear_velocity.y, -(character.data.speed/2), character.data.speed/2)
