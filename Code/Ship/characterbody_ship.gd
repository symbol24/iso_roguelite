class_name CharacterBodyShip extends CharacterBody2D


@export_group("Debug")
@export var debug_data:CharacterData
@export var debug_spawn:bool = false


var data:CharacterData = null
var direction:Vector2 = Vector2.ZERO
var last_direction:Vector2 = Vector2.ZERO


func _ready() -> void:
	if debug_spawn:
		if data == null: setup_ship()
		Signals.CharacterReady.emit(self)


func setup_ship(new_data:CharacterData = null) -> void:
	if new_data == null:
		data = debug_data.duplicate()
	else:
		data = new_data
