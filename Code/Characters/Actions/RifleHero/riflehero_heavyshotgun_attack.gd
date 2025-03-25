class_name RifleHeroShotgunAttack extends RaycastShoot


var is_up:bool = true


func _shoot_one_bullet(pos:Vector2) -> void:
	if line == null:
		line = load(data.projectile_uid)
		
	if line != null:
		var y:float = randf_range(-5, 5)
		var new_line:Line2D = line.instantiate()
		raycast.add_child(new_line)
		if not new_line.is_node_ready(): await new_line.ready
		new_line.global_position = pos
		var rand_offset:float = 10 * proj_count if is_up else -10 * proj_count
		rand_offset += randf_range(3, -3)
		is_up = not is_up
		raycast.target_position.x = data.life_time_distance
		raycast.target_position.y += rand_offset
		var target_pos:Vector2 = _get_target_pos()
		if target_pos == Vector2.ZERO: target_pos = raycast.target_position
		else: target_pos = raycast.to_local(target_pos)
		new_line.set_point_position(1, target_pos)
		get_tree().create_timer(data.life_timer).timeout.connect(new_line.queue_free)
		
		if last_hit != null:
			if last_hit.has_method(&"receive_damage"):
				print("hit")
				last_hit.receive_damage(_get_damage())
