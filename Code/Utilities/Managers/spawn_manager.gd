class_name SpawnManager extends Node2D


var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level
var character:Character = null


func _ready() -> void:
	Signals.SpawnCamera.connect(_spawn_camera)
	Signals.SpawnCharacter.connect(_spawn_character)
	Signals.SpawnChests.connect(_spawn_chests)
	Signals.CharacterReady.connect(_check_character)


func _spawn_character(data:CharacterData) -> void:
	if level == null: 
		push_error("No level found. Unable to spawn character")
		return
		
	character = load(data.character_uid).instantiate() as Character
	level.add_child(character)
	if not character.is_node_ready(): await character.ready
	character.global_position = _get_spawn_point().global_position
	character.character_setup(data)


func _check_character(_character:Character) -> void:
	if character == _character:
		Signals.UpdateRunState.emit(&"characters_done")


func _spawn_chests() -> void:
	# TODO: spawn for amount of chests
	_check_all_chests_spawned() # This will be removed


func _check_all_chests_spawned() -> void:
	if level == null: 
		push_error("No level found. Unable to spawn chests")
		return
	# TODO: Add count validation for total chests spawned
	Signals.UpdateRunState.emit(&"chests_done")


func _get_spawn_point() -> Marker2D:
	return get_tree().get_first_node_in_group(&"character_spawn_point")


func _spawn_camera() -> void:
	if level == null: 
		push_error("No level found. Unable to spawn camera")
		return
	
	var play_camera:Camera2D = load(Data.PLAY_CAMERA).instantiate() as Camera2D
	level.add_child(play_camera)
	if not play_camera.is_node_ready(): await play_camera.ready
	play_camera.global_position = _get_spawn_point().global_position
