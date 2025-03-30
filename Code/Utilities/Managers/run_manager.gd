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


func _ready() -> void:
	Signals.UpdateRunState.connect(_go_to_next_state)


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
