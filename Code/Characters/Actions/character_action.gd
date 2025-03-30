class_name CharacterAction extends Node2D


@export var data:ActionData

var character:Character
var can_act:bool = false
var timer_active:bool = false
var delay_timer:float = 1.0
var current_charges:int = 1:
	set(value):
		current_charges = value
		Signals.ActionChargesUpdate.emit(data.id, current_charges)
var max_charges:int:
	get: return data.base_charges + character.data.charges if data else 1
var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level
var action_delay:float:
	get:
		return data.action_delay / (data.attack_speed + character.data.attack_speed) if data.get("attack_speed") else data.action_delay


func _ready() -> void:
	Signals.CharacterReady.connect(_activate)


func _process(delta: float) -> void:
	if character.is_alive and timer_active: _reduce_delay_timer(delta)


func _activate(_character:Node2D) -> void:
	character = _character
	can_act = true
	delay_timer = 0.0


func _reduce_delay_timer(value:float = 0.0) -> void:
	delay_timer -= value
	delay_timer = max(0.0, delay_timer)
	if delay_timer <= 0.0:
		if not data.uses_charges: can_act = true
		else:
			current_charges += 1
			if current_charges == max_charges:
				timer_active = false
			if current_charges < max_charges:
				timer_active = true
				delay_timer = action_delay
	if data.uses_charges and current_charges > 0:
		can_act = true
	Signals.ActionTimer.emit(data.id, delay_timer, action_delay)
