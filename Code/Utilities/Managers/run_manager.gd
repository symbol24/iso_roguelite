class_name RunManager extends Node2D


@export var all_characters:CharacterList

var manager:MangerManager:
	get: 
		if manager == null: manager = get_tree().get_first_node_in_group(&"Manager")
		return manager
var level:Level:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level
var current_objective:LevelObjectiveData
var previous_objective:StringName = &""
var can_pause:bool = false
var debug_objective:StringName = &""
var current_run_level:int = 1
var run_difficulty:int = 0

func _input(event: InputEvent) -> void:
	if can_pause:
		if event.is_action_pressed(&"pause"):
			if get_tree().paused:
				Signals.ToggleUi.emit(&"pause_menu", false)
				get_tree().paused = false
			else:
				Signals.ToggleUi.emit(&"pause_menu", true)
				get_tree().paused = true


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.UpdateRunState.connect(_go_to_next_state)
	Signals.ToggleCanPause.connect(_toggle_can_pause)
	Signals.EnemyDeath.connect(_receive_enemy_death)
	Signals.DebugObjectiveSelect.connect(_set_debug_objective)
	Signals.SetDifficulty.connect(_set_difficulty)
	Signals.ResetRun.connect(_reset_run)


func _reset_run() -> void:
	current_run_level = 1
	run_difficulty = 1
	debug_objective = &""
	current_objective = null


func _go_to_next_state(message:StringName) -> void:
	match message:
		&"chests_done":
			await get_tree().create_timer(0.5).timeout
			print("Chests spawned")
			_select_objective()
		&"objective_selected":
			print("Objective elements spawned")
			await get_tree().create_timer(0.5).timeout
			Signals.ToggleLoadingScreen.emit(false)
			Signals.LoadUi.emit(&"play_ui", _get_data_from_id(manager.save_load.get_selected_character()))
		&"play_ui_done":
			print("play ui ready")
			Signals.DisplayLevelIntro.emit(level.data)
		&"intro_displayed":
			print("intro displayed")
			_spawn_character()
		&"characters_done":
			print("Characters spawned")
			Signals.DisplayObjective.emit(current_objective) # needs current_objective data
		&"objective_displayed":
			print("Objective displayed")
			current_objective.can_receive = true
			_toggle_can_pause(true)
		&"objective_complete":
			pass # spawn the boss!
		&"run_ended_failure":
			print("Run ended in fail")
			_toggle_can_pause(false)
			# display run fail screen
		&"run_ended_success":
			print("Run ended in success")
			_toggle_can_pause(false)
			# display run success screen
		_:
			pass


func _spawn_character() -> void:
	var data:CharacterData = _get_data_from_id(manager.save_load.get_selected_character())
	if data == null:
		push_warning("Unable to find proper data for id ", manager.save_load.get_selected_character(), ". Character spawning ignored.")
		return
	Signals.SpawnCharacter.emit(data)


func _get_data_from_id(_character_id:StringName) -> CharacterData:
	for each in all_characters.characters:
		if _character_id == each.id: return each
	return null


func _select_objective() -> void:
	if manager.debug:
		if debug_objective != &"":
			current_objective = level.data.get_objective_from_id(debug_objective)
			debug_objective = &""
			previous_objective = &""
		else:
			current_objective = level.data.get_random_level_objective(previous_objective)
	else:
		current_objective = level.data.get_random_level_objective(previous_objective)
	
	current_objective.reset_objective()
	previous_objective = current_objective.id
	Signals.SpawnObjectiveElements.emit(current_objective)


func _toggle_can_pause(value:bool) -> void:
	can_pause = value


func _receive_enemy_death(enemy_data:EnemyData) -> void:
	match current_objective.type:
		Enums.Objective_Type.ENEMYKILLS:
			current_objective.current_count += 1
		Enums.Objective_Type.DEFEATELITES:
			if enemy_data.type == Enums.Enemy_Type.ELITE:
				current_objective.current_count += 1
		Enums.Objective_Type.DEFEATBOSS:
			if enemy_data.type == Enums.Enemy_Type.BOSS:
				current_objective.current_count += 1
		Enums.Objective_Type.HUNT:
			if enemy_data.type == Enums.Enemy_Type.HUNTED:
				current_objective.current_count += 1
		Enums.Objective_Type.DESTROYOBJECTS:
			if enemy_data.type == Enums.Enemy_Type.DESTRUCTIBLE:
				current_objective.current_count += 1
		_:
			pass


func _set_debug_objective(value:StringName) -> void:
	debug_objective = value


func _set_difficulty(value:int) -> void:
	run_difficulty = value
