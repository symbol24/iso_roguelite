class_name CharacterBodyMove extends CharacterAction


var direction:Vector2 = Vector2.ZERO
var boosting:bool = false


func _ready() -> void:
	super()
	Signals.ActionToggled.connect(_toggle_boost)


func _physics_process(delta: float) -> void:
	if can_act:
		direction = Input.get_vector("left", "right", "up", "down")
		#print(direction)
		if character != null:
			var vel:Vector2 = _get_velocity(direction, character.velocity, delta)
			character.set_new_vel(vel, direction)


func _get_velocity(_direction:Vector2, current:Vector2, delta:float) -> Vector2:
	var new_vel:Vector2 = current
	var boost:float = data.boost_multiplyer if boosting else 1.0
	if _direction != Vector2.ZERO:
		var x:float = move_toward(new_vel.x, _direction.x * character.data.speed * boost, delta * character.data.base_acceleration)
		var y:float = move_toward(new_vel.y, _direction.y * character.data.speed * boost, delta * character.data.base_acceleration)
		new_vel.x = clampf(x, -character.data.speed, character.data.speed)
		new_vel.y = clampf(y, -character.data.speed, character.data.speed)
	else:
		new_vel = new_vel.move_toward(Vector2.ZERO, delta * character.data.base_friction)
		
	return new_vel


func _toggle_boost(action_id:StringName, toggle:bool) -> void:
	if action_id == data.id:
		boosting = toggle
