class_name EnemyAction extends Node2D


var enemy:Node2D
var can_act:bool = false
var timer_active:bool = false
var delay_timer:float = 1.0
var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level
var data:EnemyData:
	get:
		if enemy: return enemy.data
		return data


func _ready() -> void:
	enemy = get_parent()
	Signals.EnemyReady.connect(_activate)


func _process(delta: float) -> void:
	if timer_active: _reduce_delay_timer(delta)


func _activate(_enemy:Node2D) -> void:
	enemy = _enemy
	can_act = true


func _reduce_delay_timer(value:float = 0.0) -> void:
	delay_timer -= value
	delay_timer = max(0.0, delay_timer)
	if delay_timer <= 0.0:
		can_act = true
		delay_timer = snappedf(data.delay_between_attacks / 1 + data.attack_speed, 0.1)
		timer_active = false
