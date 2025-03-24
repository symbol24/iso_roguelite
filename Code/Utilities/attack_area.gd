class_name AttackArea extends Area2D


const DESTROYTIME:float = 0.1


var data:ActionData
var active:bool = false
var attack_owner:Node2D
var origin:Vector2


func setup_attack(_data:ActionData, _owner:Node2D, pos:Vector2 = Vector2.ZERO, _rot:float = 0.0) -> void:
	data = _data
	attack_owner = _owner
	if pos != Vector2.ZERO: 
		global_position = pos
		origin = pos


func trigger() -> void:
	active = true


func get_damage() -> Damage:
	var damage:Damage = Damage.new()
	get_tree().create_timer(DESTROYTIME).timeout.connect(destroy_self)
	return damage


func destroy_self() -> void:
	queue_free()
