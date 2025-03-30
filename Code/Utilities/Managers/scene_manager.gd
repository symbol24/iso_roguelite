class_name SceneManager extends Node

@export var levels:LevelsToLoadData

var active_level:Node2D = null
var to_load:String
var progress:Array = []
var status:ResourceLoader.ThreadLoadStatus
var loading:bool = false


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.LoadScene.connect(_load_scene)


func _process(_delta: float) -> void:
	if loading:
		status = ResourceLoader.load_threaded_get_status(to_load, progress)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			_complete_load()


func _load_scene(scene_name:StringName, _dispay_loading_screen:bool = false) -> void:
	if not loading:
		Signals.ToggleLoadingScreen.emit(_dispay_loading_screen)
		to_load = levels.get_scene_uid(scene_name).uid
		if to_load != "":
			ResourceLoader.load_threaded_request(to_load)
			loading = true
	else:
		print("Scene loading in progress already.")


func _complete_load() -> void:
	loading = false
	var temp = ResourceLoader.load_threaded_get(to_load)
	
	if active_level != null:
		var temp_level = active_level
		active_level = null
		get_tree().root.remove_child(temp_level)
		temp_level.queue_free.call_deferred()
	
	active_level = temp.instantiate()
	get_tree().root.add_child.call_deferred(active_level)
	if not active_level.is_node_ready(): await active_level.ready
	
	#Signals.ToggleLoadingScreen.emit(false)
	
