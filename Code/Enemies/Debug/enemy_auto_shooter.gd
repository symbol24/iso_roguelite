class_name AutoShooter extends Enemy



func _check_death() -> void:
	if data.current_hp <= 0:
		is_alive = false
		Signals.EnemyDeath.emit(data)
		await get_tree().create_timer(1).timeout
		_respawn()
		

func _respawn() -> void:
	data.setup_data()
	if hp_bar: hp_bar.value = data.current_hp / data.max_hp
	is_alive = true
