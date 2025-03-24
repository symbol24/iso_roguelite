class_name LaserShoot extends ProjectileShoot


var laser:Laser = null
var charging:bool = false
var current_charge:float = 9.9:
	set(value):
		current_charge = value
		current_charge = clampf(current_charge, 0.0, data.max_charge)
		if not charging and current_charge <= 0.0:
			_release_shoot()
		elif charging and current_charge >= data.max_charge:
			charging = false


func _process(delta: float) -> void:
	if can_act and shooting and not cycling: _cycle_shoot()
	elif can_act and not shooting and cycling: _release_shoot()
	if cycling: current_charge -= delta
	if charging: current_charge += data.max_charge * (delta / data.charge_time)
	if timer_active: 
		delay_timer -= delta
		if delay_timer <= 0.0:
			timer_active = false
			charging = true


func _cycle_shoot() -> void:
	cycling = true
	Signals.ToggleRotation.emit(true)
	for point in spawn_points:
		_shoot_one_bullet(point.global_position)


func _release_shoot() -> void:
	remove_child(laser)
	cycling = false
	shooting = false
	delay_timer = data.action_delay / (data.attack_speed + character.data.attack_speed)
	timer_active = true
	Signals.ToggleRotation.emit(false)


func _shoot_one_bullet(pos:Vector2) -> void:
	if projectile == null:
		projectile = load(data.projectile_uid)

	if laser == null:
		laser = projectile.instantiate()
		
	add_child(laser)
	if not laser.is_node_ready(): await laser.ready
	laser.setup_attack(data, character, pos, 0.0)
	var new_length:float = data.length
	
	laser.setup_length(new_length)
