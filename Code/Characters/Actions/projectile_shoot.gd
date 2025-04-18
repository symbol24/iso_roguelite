class_name ProjectileShoot extends CharacterAction

@export var spawn_points:Array[Marker2D]
@export var rotation_node:Node2D

var projectile:PackedScene
var shooting:bool = false
var cycling:bool = false
var proj_count:int = 0
var can_shoot:bool:
	get:
		if data.uses_charges and current_charges > 0: return true
		elif not data.uses_charges and delay_timer <= 0.0: return true
		return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(data.input_name):
		shooting = true
		get_viewport().set_input_as_handled()
	elif event.is_action_released(data.input_name):
		shooting = false
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	super(delta)
	if character.is_alive and can_act and shooting and can_shoot and not cycling: _cycle_shoot()


func _activate(_character:Node2D) -> void:
	character = _character
	can_act = true
	delay_timer = 0.0
	current_charges = max_charges


func _cycle_shoot() -> void:
	can_act = false
	cycling = true
	if data.uses_charges:
		if current_charges == max_charges: delay_timer = action_delay
		else:
			if delay_timer <= 0.0: delay_timer = action_delay
		current_charges -= 1
	else: delay_timer = action_delay
	for i in data.count_per_attack:
		for point in spawn_points:
			_shoot_one_bullet(point.global_position)
			proj_count += 1
		if data.count_per_attack > 1 and data.delay_between_proj > 0.0:
			await get_tree().create_timer(data.delay_between_proj).timeout
	cycling = false
	timer_active = true
	if data.uses_charges: shooting = false
	proj_count = 0


func _shoot_one_bullet(pos:Vector2) -> void:
	if projectile == null:
		projectile = load(data.projectile_uid)
	
	var new_proj:Projectile = projectile.instantiate()
	level.add_child(new_proj)
	if not new_proj.is_node_ready(): await new_proj.ready
	new_proj.setup_attack(data, character, pos, rotation_node.rotation)
	new_proj.name = &"projectile_0"
	new_proj.trigger()


func _reduce_delay_timer(value:float = 0.0) -> void:
	delay_timer -= value
	delay_timer = max(0.0, delay_timer)
	if data.uses_charges and current_charges > 0:
		can_act = true
	if delay_timer <= 0.0:
		if not data.uses_charges: can_act = true
		else:
			current_charges += 1
			if current_charges == max_charges:
				timer_active = false
			if current_charges < max_charges:
				timer_active = true
				delay_timer = action_delay
	Signals.ActionTimer.emit(data.id, delay_timer, action_delay)
