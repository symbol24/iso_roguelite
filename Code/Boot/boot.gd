class_name Boot extends Node2D


const MMANAGER:PackedScene = preload("uid://e2faq44ig35a")


func _ready() -> void:
	Signals.ManagerLoaded.connect(_loades_manager)
	var mmanger:MangerManager = MMANAGER.instantiate()
	get_tree().root.add_child.call_deferred(mmanger)
	if not mmanger.is_node_ready(): await mmanger.ready
	Signals.LoadManager.emit(&"save_load")


func _loades_manager(id:StringName) -> void:
	match id:
		&"save_load":
			print("save load manager loaded")
			Signals.LoadManager.emit(&"UI")
		&"UI":
			print("UI Canvas loaded")
			Signals.LoadManager.emit(&"run_manager")
		&"run_manager":
			print("Run Manager loaded")
			Signals.LoadManager.emit(&"scene_manager")
		&"scene_manager":
			print("Scene Manager loaded")
			Signals.LoadScene.emit(&"main_menu", false)
			queue_free.call_deferred()
		_:
			pass
