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
var active_attack_anim_name:StringName = &""
var anim_speed_scale:float:
	get: return data.anim_speed_scale + character.data.attack_speed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(data.input_name):
		attacking = true
		get_viewport().set_input_as_handled()
	elif event.is_action_released(data.input_name):
		attacking = false
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if character.is_alive:
		if can_attack and can_act and attacking and not cycling: _cycle()
		if combo_active: combo_timer += delta
		if timer_active: _reduce_delay_timer(delta)
	
	if character and character.debug_signals:
		Signals.DebugCharacterInfo.emit(&"active_attack_anim_name", str(active_attack_anim_name))
	

func _cycle() -> void:
	cycling = true
	can_act = false
	combo_active = true
	character.anim_tree.set("parameters/attack1/attack_speed/scale", anim_speed_scale)
	character.anim_tree.set("parameters/attack2/attack_speed/scale", anim_speed_scale)
	data.active_attack = data.attacks[combo_point]
	var keys = data.attacks[combo_point].keys()
	active_attack_anim_name = keys[0] as StringName
	character.anim_tree.set("parameters/"+ active_attack_anim_name + "/" + active_attack_anim_name + "/blend_position", character.last_direction)
	character.anim_tree.set("parameters/conditions/" + active_attack_anim_name, true)


func _receive_signal_animation(_character:Character, signal_name:StringName, value) -> void:
	if _character == character and signal_name == data.signal_name and value == active_attack_anim_name:
		for each in data.attacks:
			for key in each.keys():
				character.anim_tree.set("parameters/conditions/" + key, false)
		combo_point += 1
		if combo_point >= data.attacks.size(): 
			combo_point = 0
			combo_active = false
		delay_timer = action_delay
		timer_active = true
		cycling = false


func _activate(_character:Node2D) -> void:
	super(_character)
	Signals.AnimationSignal.connect(_receive_signal_animation)
	_setup_melee_attack_area()


func _reduce_delay_timer(value:float = 0.0) -> void:
	delay_timer -= value
	delay_timer = max(0.0, delay_timer)
	if delay_timer <= 0.0: can_act = true
	Signals.ActionTimer.emit(data.id, delay_timer, action_delay)


func _setup_melee_attack_area() -> void:
	var children:Array = get_children()
	for child in children:
		if child is MeleeAttackArea:
			child.setup_attack(data, character)
