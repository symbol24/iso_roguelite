class_name Interactible extends Area2D


@export var data:InteractibleData

@onready var interactible_collider: CollisionShape2D = %interactible_collider
@onready var sprite: Sprite2D = %sprite


func _ready() -> void:
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)


func interact(currency:int = 0) -> Dictionary:
	var result:Dictionary = {&"result": false}
	if data and currency >= data.cost:
		result[&"result"] = true
		result[&"cost"] = data.cost
		result[&"reward"] = data.reward
		_trigger_visuals()
	return result


func _trigger_visuals() -> void:
	interactible_collider.set_disabled.call_deferred(true)


func _area_entered(area) -> void:
	if area is Interact:
		_display_interact(true)


func _area_exited(area) -> void:
	if area is Interact:
		_display_interact(false)
		

func _display_interact(_disaply:bool) -> void:
	pass
