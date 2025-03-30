class_name Level extends Node2D


func _ready() -> void:
	Signals.ManagerLoaded.connect(_manager_check)
	Signals.LoadManager.emit(&"spawn_manager")


func _manager_check(manager:StringName) -> void:
	if manager == &"spawn_manager":
		print("Spawn Manager loaded")
		Signals.SpawnCamera.emit()
		Signals.SpawnChests.emit()
