class_name PelletShipTwinsTickMove extends BasicMove


var boosting:bool = false


func _ready() -> void:
	super()
	Signals.ActionToggled.connect(_toggle_boost)


func _physics_process(_delta: float) -> void:
	if can_act:
		direction = Input.get_vector("left", "right", "up", "down")
		var boost:float = data.boost_multiplyer if boosting else 1.0
		character.apply_central_force(direction * character.data.speed * boost)
		character.linear_velocity.x = clampf(character.linear_velocity.x, -(character.data.speed/2) * boost, (character.data.speed/2) * boost)
		character.linear_velocity.y = clampf(character.linear_velocity.y, -(character.data.speed/2) * boost, (character.data.speed/2) * boost)


func _toggle_boost(action_id:StringName, toggle:bool) -> void:
	if action_id == data.id:
		boosting = toggle
