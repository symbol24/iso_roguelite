class_name Interact extends Area2D


var interactible:Interactible = null
var manager:MangerManager:
	get:
		if manager ==  null: manager = get_tree().get_first_node_in_group("Manager")
		return manager


func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact"):
		_interact()


func _interact() -> void:
	if interactible != null:
		var result:Dictionary = interactible.interact(manager.save_load.current_save.run_currency)
		if result[&"result"]:
			if result[&"cost"] > 0:
				Signals.RunCurrencyUpdate.emit(-result[&"cost"])
			if result[&"reward"] == null:
				print("No rewards yet")
			else:
				if result[&"reward"] is RunUpgradeData:
					Signals.AddRunUpgrade.emit(result[&"reward"])


func _area_entered(area) -> void:
	if area is Interactible:
		interactible = area


func _area_exited(area) -> void:
	if area == interactible:
		interactible = null
