class_name Boost extends CharacterAction


var boosting:bool = false
var current_boost_time:float = 1.0:
	set(value):
		if recharging:
			current_boost_time = min(value, data.max_boost_time)
			if current_boost_time >= data.max_boost_time:
				recharging = false
		else:
			current_boost_time = max(0.0, value)
			if current_boost_time <= 0.0:
				_boost(false)
		Signals.ActionTimer.emit(data.id, current_boost_time, data.max_boost_time)

var rechardge_delay_active:bool = false
var recharging:bool = false
var recharge_delay_timer:float = 1.0:
	set(value):
		recharge_delay_timer = max(0.0, value)
		if recharge_delay_timer <= 0.0:
			rechardge_delay_active = false
			recharging = true
			recharge_delay_timer = data.recharge_delay


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(data.input_name):
		_boost(true)
	elif event.is_action_released(data.input_name):
		_boost(false)


func _physics_process(delta: float) -> void:
	if can_act:
		if boosting: current_boost_time -= delta
		if rechardge_delay_active: recharge_delay_timer -= delta
		if recharging: current_boost_time += delta * data.recharge_rate


func _boost(is_on:bool = false) -> void:
	if is_on and current_boost_time > 0.0:
		boosting = true
		rechardge_delay_active = false
		recharging = false
	elif not is_on:
		boosting = false
		rechardge_delay_active = true
		recharging = false
	if not recharging: recharge_delay_timer = data.recharge_delay
	Signals.ActionToggled.emit(data.id, boosting)


func _activate(_character:Node2D) -> void:
	character = _character
	can_act = true
	current_boost_time = data.max_boost_time
	recharge_delay_timer = data.recharge_delay
