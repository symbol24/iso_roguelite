class_name MovementAction extends CharacterAction


var triggered:bool = false
var doing:bool = false
var doing_direction:Vector2 = Vector2.ZERO
var anim_length:float = 0.1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(data.input_name):
		triggered = true
		get_viewport().set_input_as_handled()
	elif event.is_action_released(data.input_name):
		triggered = false
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	super(delta)
	if character.is_alive:
		if can_act and triggered and not doing: _do_action()
		if doing: character.override_velocity(_get_movement_velocity())


func _activate(_character:Node2D) -> void:
	super(_character)
	Signals.AnimationSignal.connect(_receive_anim_signal)
	anim_length = character.animator.get_animation(data.animaton_name + &"_up").length


func _get_movement_velocity() -> Vector2:
	return character.last_direction * (data.distance / anim_length) if data.fixed_direction else character.velocity.normalized() * (data.distance / anim_length)


func _do_action() -> void:
	can_act = false
	doing = true
	current_charges -= 1
	character.anim_tree.set("parameters/" + data.blend_name + "/blend_position", character.direction)
	character.anim_tree.set("parameters/conditions/" + data.condition_name, true)


func _receive_anim_signal(_character:Character, signal_name:StringName, value) -> void:
	if _character == character and signal_name == data.signal_name and value == true:
		doing = false
		character.anim_tree.set("parameters/conditions/" + data.condition_name, false)
		character.reset_velocity()
		delay_timer = action_delay
		timer_active = true
		
