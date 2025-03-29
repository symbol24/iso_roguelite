class_name ApplyEffectAction extends CharacterAction


var triggered:bool = false
var doing:bool = false
var vfx:PackedScene = null


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
		if can_act and triggered and current_charges > 0 and not doing: _do_action()


func _do_action() -> void:
	doing = true
	can_act = false
	current_charges -= 1
	var new_vfx = _get_vfx()
	add_child(new_vfx)
	if not new_vfx.is_node_ready(): await new_vfx.ready
	new_vfx.position = Vector2.ZERO
	character.add_positive_effect(data.type, data.amount + character.data.damage, data.is_additive)
	delay_timer = action_delay
	timer_active = true
	doing = false


func _get_vfx() -> Node2D:
	if vfx == null: vfx = load(data.vfx_uid)
	return vfx.instantiate()
