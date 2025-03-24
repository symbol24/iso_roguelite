class_name TwinStickAim extends CharacterAction


@export var reticle_uid:String
@export var mouse_move_detection_time:float = 0.3

@onready var aim_point_for_controller: Marker2D = %aim_point_for_controller

var reticle:Sprite2D
var ready_to_move:bool = false
var pos:Vector2 = Vector2.ZERO
var is_gamepad:bool = true
var last_direction:Vector2 = Vector2.ZERO
var last_rotation:float = 0.0

# TODO: Move mouse and gamepad detection into an input manager
var detecting_mouse_movement:bool = false
var mouse_move_detection_timer:float = 0.0:
	set(value):
		mouse_move_detection_timer = value
		if mouse_move_detection_timer >= mouse_move_detection_time:
			detecting_mouse_movement = false
			is_gamepad = false
			mouse_move_detection_timer = 0.0
			character.rotation = last_rotation


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if is_gamepad:
			if event.velocity.length() > 0:
				detecting_mouse_movement = true
			else:
				detecting_mouse_movement = false
				mouse_move_detection_timer = 0.0
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		detecting_mouse_movement = false
		mouse_move_detection_timer = 0.0
		is_gamepad = true


func _ready() -> void:
	super()
	_spawn_reticle()
	aim_point_for_controller.position = Vector2(sqrt(data.life_time_distance), 0)
	
	
func _process(delta: float) -> void:
	if can_act and ready_to_move: 
		if is_gamepad:
			var aim_direction:Vector2 = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
			reticle.global_position = aim_point_for_controller.global_position
			var target_angle:float = Vector2.RIGHT.angle_to(last_direction)
			rotation = target_angle
			last_direction = aim_direction
			
		else: 
			pos = get_global_mouse_position()
			reticle.global_position = pos
			look_at(reticle.global_position)
	
		if detecting_mouse_movement: mouse_move_detection_timer += delta


func _spawn_reticle() -> void:
	if reticle == null:
		reticle = load(reticle_uid).instantiate()
		level.add_child.call_deferred(reticle)
		if not reticle.is_node_ready(): await reticle.ready
		ready_to_move = true
