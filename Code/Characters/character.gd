class_name Character extends CharacterBody2D


@export var debug_data:CharacterData
@export var debug_spawn:bool = false

@onready var animator: AnimationPlayer = %animator
@onready var anim_tree: AnimationTree = %anim_tree

var data:CharacterData = null
var direction:Vector2 = Vector2.ZERO
var last_direction:Vector2 = Vector2.ZERO
var actions:Array[CharacterAction] = []
var is_alive:bool = true


func _ready() -> void:
	if debug_spawn:
		if data == null: character_setup()
		Signals.CharacterReady.emit(self)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func character_setup(new_data:CharacterData = null) -> void:
	if new_data == null:
		data = debug_data.duplicate()
		data.setup_data()
		# TODO: Fix for selected actions
		for action in data.all_actions:
			if action.unlocked_be_default:
				data.active_actions.append(action)
	else:
		data = new_data

	Signals.LoadUi.emit(&"play_ui", data)


func set_new_vel(new_vel:Vector2 = Vector2.ZERO, new_direction:Vector2 = Vector2.ZERO) -> void:
	velocity = new_vel
	if new_direction != Vector2.ZERO: last_direction = direction
	direction = new_direction
	_set_animation_params()


func receive_damage(damage:Damage) -> void:
	if is_alive:
		var final_value:float = damage.value
		match damage.type:
			Enums.Damage_Type.PHYSICAL:
				pass
			Enums.Damage_Type.ENERGY:
				pass
			Enums.Damage_Type.PLASMA:
				pass
			Enums.Damage_Type.EXPLOSIVE:
				pass
			_:
				pass


func _set_animation_params() -> void:
	var running:bool = false
	var idle:bool = true
	if direction != Vector2.ZERO:
		running = true
		idle = false
	
	if running != anim_tree.get("parameters/conditions/running"): anim_tree.set("parameters/conditions/running", running)
	if idle != anim_tree.get("parameters/conditions/idle"): anim_tree.set("parameters/conditions/idle", idle)
	if last_direction.x != anim_tree.get("parameters/idle_blend/blend_position"): anim_tree.set("parameters/idle_blend/blend_position", last_direction.x)
	if last_direction != anim_tree.get("parameters/running_blend/blend_position"): anim_tree.set("parameters/running_blend/blend_position",direction)


func _hit_effect() -> void:
	pass
