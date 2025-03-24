class_name Ship extends RigidBody2D


@export_group("Debug")
@export var debug_data:CharacterData
@export var debug_spawn:bool = false


var data:CharacterData = null
var direction:Vector2 = Vector2.ZERO
var last_direction:Vector2 = Vector2.ZERO
var actions:Array[CharacterAction] = []
var look_at_point:Vector2 = Vector2.ZERO
var look_rotation:float = 0.0
var look:bool = false


func _ready() -> void:
	if debug_spawn:
		if data == null: setup_ship()
		Signals.CharacterReady.emit(self)


func _physics_process(_delta: float) -> void:
	if not look and look_at_point != Vector2.ZERO: look_at(look_at_point)
	elif look: rotation = look_rotation
	


func setup_ship(new_data:CharacterData = null) -> void:
	if new_data == null:
		data = debug_data.duplicate()

	else:
		data = new_data
	
	linear_damp = data.dampening
