class_name SpawnManager extends Node2D


var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level
var manager:MangerManager:
	get:
		if manager == null: manager = get_tree().get_first_node_in_group(&"Manager")
		return manager
var character:Character = null


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.SpawnCamera.connect(_spawn_camera)
	Signals.SpawnCharacter.connect(_spawn_character)
	Signals.SpawnChests.connect(_spawn_chests)
	Signals.CharacterReady.connect(_check_character)
	Signals.SpawnObjectiveElements.connect(_spawn_objective_elements)


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


func _spawn_objective_elements(objective:LevelObjectiveData) -> void:
	if objective.type in [Enums.Objective_Type.DESTROYOBJECTS, Enums.Objective_Type.TOGGLEOBJECTS, Enums.Objective_Type.KEYHUNT]:
		var spawn_points:Array[Marker2D] = _get_objective_spawn_points(objective.spawn_group, objective.get_amount_for_difficulty(manager.run_manager.run_difficulty, manager.run_manager.current_run_level))
		if objective.objective_data == null or objective.objective_data.get(&"uid") == "":
			push_error("Missing objective uid. Nothing to spawn.")
		else:
			for point in spawn_points:
				var new_obj = load(objective.objective_data.uid).instantiate()
				level.add_child(new_obj)
				if not new_obj.is_node_ready(): await new_obj.ready
				new_obj.name = objective.spawn_group + "_0"
				new_obj.global_position = point.global_position
				await get_tree().create_timer(0.1).timeout
	Signals.UpdateRunState.emit(&"objective_selected")


func _get_objective_spawn_points(_name:StringName, amount:int = 0) -> Array[Marker2D]:
	var results:Array[Marker2D] = []
	var list:Array[Marker2D] = []
	var children:Array = get_tree().get_nodes_in_group(_name)
	for each in children:
		if each is Marker2D: list.append(each)
	if list.size() < amount:
		push_warning("Not enough nodes of group %s found. Returning amount of %s." % [_name, list.size()])
		return list
	while results.size() < amount:
		results.append(list.pick_random())
	return results
