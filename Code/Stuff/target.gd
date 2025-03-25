class_name Target extends StaticBody2D

@export var max_hp:float = 100.0

@onready var hp_bar: ProgressBar = %hp_bar

var current_hp:float:
	set(value):
		current_hp = value
		hp_bar.value = current_hp / max_hp


func _ready() -> void:
	current_hp = max_hp


func receive_damage(damage:Damage) -> void:
	var value:float = damage.value
	if value > current_hp: value = current_hp
	current_hp -= value
	Signals.SpawnDamageNumber.emit(damage, self)
	if current_hp <= 0.0: _death_cycle()
	
	
func _death_cycle() -> void:
	current_hp = max_hp
