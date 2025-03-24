extends TwinStickAim


@export var raycast:RayCast2D


func _process(delta: float) -> void:
	if can_act and ready_to_move: 
		if is_gamepad:
			var aim_direction:Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			if aim_point_for_controller.position.x != data.reticle_distance: aim_point_for_controller.position.x = data.reticle_distance
			reticle.global_position = aim_point_for_controller.global_position
			var gamepad_pos:Vector2 = Vector2(data.life_time_distance, raycast.to_local(reticle.global_position).y)
			raycast.target_position = gamepad_pos
			var target_angle:float = Vector2.RIGHT.angle_to(last_direction)
			rotation = target_angle
			last_direction = aim_direction
			
		else: 
			pos = get_global_mouse_position()
			reticle.global_position = pos
			raycast.target_position = raycast.to_local(reticle.global_position)
			look_at(reticle.global_position)
	
		if detecting_mouse_movement: mouse_move_detection_timer += delta
