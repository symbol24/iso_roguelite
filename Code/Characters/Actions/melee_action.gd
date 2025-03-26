class_name MeleeAction extends CharacterAction


var combo_point:int = 0
var combo_active:bool = false
var combo_timer:float = 0.0:
	set(value):
		combo_timer = value
		if combo_timer >= Data.MAXCOMBOWAITTIME:
			combo_active = false
			combo_point = 0
			combo_timer = 0.0
var attacking:bool = false
var cycling:bool = false
var can_attack:bool:
	get:
		if data.uses_charges and current_charges > 0: return true
		elif not data.uses_charges and delay_timer <= 0.0: return true
		return false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(data.input_name):
		attacking = true
		get_viewport().set_input_as_handled()
	elif event.is_action_released(data.input_name):
		attacking = false
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	super(delta)
	if character.is_alive:
		if can_attack and can_act and attacking and not cycling: _cycle()
		if combo_active: combo_timer += delta



func _cycle() -> void:
	cycling = true
	combo_active = true
	character.anim_tree.get("parameters/conditions/" + data.attack)
