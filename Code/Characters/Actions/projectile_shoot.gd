class_name ProjectileShoot extends CharacterAction

@export var spawn_points:Array[Marker2D]

var projectile:PackedScene
var shooting:bool = false
var cycling:bool = false
var proj_count:int = 0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(data.input_name):
		shooting = true
		get_viewport().set_input_as_handled()
	elif event.is_action_released(data.input_name):
		shooting = false
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	super(delta)
	if character.is_alive and can_act and shooting and current_charges > 0 and not cycling: _cycle_shoot()


func _activate(_character:Node2D) -> void:
	character = _character
	can_act = true
	delay_timer = 0.0


func _cycle_shoot() -> void:
	if not timer_active:
		current_charges -= 1
		delay_timer = data.action_delay / (data.attack_speed + character.data.attack_speed)
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
	new_proj.setup_attack(data, character, pos, character.rotation)
	new_proj.name = &"projectile_0"
	new_proj.trigger()


func _reduce_delay_timer(value:float = 0.0) -> void:
	delay_timer -= value
	delay_timer = max(0.0, delay_timer)
	if delay_timer <= 0.0:
		can_act = true
		timer_active = false
	Signals.ActionTimer.emit(data.id, delay_timer, data.action_delay / (data.attack_speed + character.data.attack_speed))
