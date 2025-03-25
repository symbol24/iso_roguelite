class_name CharacterAction extends Node2D


@export var data:ActionData

var character:Node2D
var can_act:bool = false
var timer_active:bool = false
var delay_timer:float = 1.0
var current_charges:int = 0
var max_charges:int:
	get: return data.base_charges + character.data.charges
var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group("level")
		return level


func _ready() -> void:
	Signals.CharacterReady.connect(_activate)


func _process(delta: float) -> void:
	if character.is_alive and timer_active: _reduce_delay_timer(delta)


func _activate(_character:Node2D) -> void:
	character = _character
	can_act = true


func _reduce_delay_timer(value:float = 0.0) -> void:
	delay_timer -= value
	delay_timer = max(0.0, delay_timer)
	Signals.ActionTimer.emit(data.id, delay_timer, data.action_delay)
	if delay_timer <= 0.0:
		#can_act = true
		current_charges += 1
		if current_charges == max_charges:
			can_act = true
			timer_active = false
		if current_charges < max_charges:
			timer_active = true
		#delay_timer = snappedf(data.action_delay / 1 + character.data.attack_speed, 0.1)
