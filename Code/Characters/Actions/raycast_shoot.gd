class_name RaycastShoot extends ProjectileShoot


@export var raycast:RayCast2D

var line:PackedScene = null
var last_hit:Node2D = null


func _shoot_one_bullet(pos:Vector2) -> void:
	if line == null:
		line = load(data.projectile_uid)
		
	if line != null:
		var y:float = randf_range(-5, 5)
		var new_line:Line2D = line.instantiate()
		raycast.add_child(new_line)
		if not new_line.is_node_ready(): await new_line.ready
		new_line.global_position = pos
		var rand_offset:float = randf_range(-5, 5)
		raycast.target_position.y += rand_offset
		var target_pos:Vector2 = _get_target_pos()
		if target_pos == Vector2.ZERO: target_pos = raycast.target_position
		else: target_pos = raycast.to_local(target_pos)
		new_line.set_point_position(1, target_pos)
		get_tree().create_timer(data.life_timer).timeout.connect(new_line.queue_free)
		
		if last_hit != null:
			if last_hit.has_method(&"receive_damage"):
				last_hit.receive_damage(_get_damage())


func _get_target_pos() -> Vector2:
	raycast.force_raycast_update()
	if raycast.is_colliding():
		last_hit = raycast.get_collider()
		return raycast.get_collision_point()
	
	last_hit = null
	return Vector2.ZERO


func _get_damage() -> Damage:
	var result:Damage = Damage.new()
	var cc_check:float = randf()
	var cc:float = data.crit_chance + character.data.crit_chance
	if cc_check <= cc:
		result.is_critical = true
	var cd:float = 1.0 + data.crit_damage + character.data.crit_damage if result.is_critical else 1.0
	result.value = (data.damage + character.data.damage) * cd
	result.type = data.damage_type
	result.sub_types = data.sub_damage_types.duplicate(true)
	return result
