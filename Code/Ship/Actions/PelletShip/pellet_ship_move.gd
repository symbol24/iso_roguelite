class_name PelletShipMove extends BasicMove


var boosting:bool = false
var last_direction:Vector2 = Vector2.ZERO

func _ready() -> void:
	super()
	Signals.ActionToggled.connect(_toggle_boost)


func _physics_process(delta: float) -> void:
	if can_act:
		direction = Input.get_vector("left", "right", "up", "down")
		var target_angle:float = Vector2.RIGHT.angle_to(last_direction)
		character.rotation = lerp_angle(character.rotation, target_angle, delta * 10)
		var boost:float = data.boost_multiplyer if boosting else 1.0
		character.apply_central_force(direction * character.data.speed * boost)
		character.linear_velocity.x = clampf(character.linear_velocity.x, -(character.data.speed/2) * boost, (character.data.speed/2) * boost)
		character.linear_velocity.y = clampf(character.linear_velocity.y, -(character.data.speed/2) * boost, (character.data.speed/2) * boost)
		if direction != Vector2.ZERO: last_direction = direction


func _toggle_boost(action_id:StringName, toggle:bool) -> void:
	if action_id == data.id:
		boosting = toggle
