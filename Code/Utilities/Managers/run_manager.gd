class_name RunManager extends Node2D


@export var all_characters:CharacterList

var manager:MangerManager:
	get: 
		if manager == null: manager = get_tree().get_first_node_in_group(&"Manager")
		return manager
var level:Node2D:
	get:
		if level == null: level = get_tree().get_first_node_in_group(&"level")
		return level
var current_level_state:Enums.LevelState = Enums.LevelState.SPAWNINGCHESTS
var current_objective
var can_pause:bool = false


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
			Signals.DisplayObjective.emit() # needs current_objective data
		&"objective_displayed":
			print("Objective displayed")
			_toggle_can_pause(true)
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
	# Select through data resource
	Signals.SpawnObjectiveElements.emit(&"tbd")


func _toggle_can_pause(value:bool) -> void:
	can_pause = value
