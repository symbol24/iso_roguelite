class_name EnemyProjectileShoot extends EnemyAction


@export var spawn_points:Array[Marker2D]

var projectile:PackedScene
var shooting:bool = false
var cycling:bool = false
var proj_count:int = 0


func _process(delta: float) -> void:
	super(delta)
	if can_act and shooting and not cycling: _cycle_shoot()


func _activate(_enemy:Node2D) -> void:
	if _enemy == enemy:
		can_act = true
		delay_timer = 0.0
		shooting = true


func _cycle_shoot() -> void:
	if not timer_active:
		delay_timer = data.delay_between_attacks
		cycling = true
		for i in data.count_per_attack:
			for point in spawn_points:
				_shoot_one_bullet(point.global_position)
				proj_count += 1
			if data.count_per_attack > 1 and data.delay_between_proj > 0.0:
				await get_tree().create_timer(data.delay_between_proj).timeout
		cycling = false
		timer_active = true
		proj_count = 0


func _shoot_one_bullet(pos:Vector2) -> void:
	if projectile == null:
		projectile = load(data.projectile_uid)
	
	var new_proj:Projectile = projectile.instantiate()
	level.add_child(new_proj)
	if not new_proj.is_node_ready(): await new_proj.ready
	new_proj.setup_attack(data.get_projectile_data(), enemy, pos, enemy.rotation)
	new_proj.name = data.id + &"_projectile_0"
	new_proj.trigger()
