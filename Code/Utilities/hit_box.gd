class_name HitBox extends Area2D


@export var receive_delay:float = 0.1

var parent:Node2D
var can_receive:bool = true


func _ready() -> void:
	area_entered.connect(_area_entered)
	parent = get_parent()


func _area_entered(area:Area2D) -> void:
	if can_receive and area.has_method("get_damage"):
		if parent.has_method("receive_damage"): 
			parent.receive_damage(area.get_damage())
			_toggle_receive()


func _toggle_receive() -> void:
	if can_receive:
		if receive_delay > 0.0: 
			can_receive = false
			get_tree().create_timer(receive_delay).timeout.connect(_toggle_receive)
	else:
		can_receive = true
