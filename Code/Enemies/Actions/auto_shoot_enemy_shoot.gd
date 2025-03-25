class_name AutoShootEnemyShoot extends EnemyProjectileShoot


@export var shoot_direction:Vector2 = Vector2.LEFT


func _shoot_one_bullet(pos:Vector2) -> void:
	if projectile == null:
		projectile = load(data.projectile_uid)
	
	var new_proj:Projectile = projectile.instantiate()
	level.add_child(new_proj)
	if not new_proj.is_node_ready(): await new_proj.ready
	var rot:float =  Vector2.RIGHT.angle_to(shoot_direction)
	new_proj.setup_attack(data.get_projectile_data(), enemy, pos, rot)
	new_proj.name = data.id + &"_projectile_0"
	new_proj.trigger()
