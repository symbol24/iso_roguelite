class_name LevelObjectiveData extends Resource


@export var id:StringName
@export var type:Enums.Objective_Type = Enums.Objective_Type.NOTHING
@export var spawn_group:StringName
@export var objective_data:Resource
@export var tr_name:String
@export var debug_name:String
@export var tr_description:String
@export var debug_description:String
@export var tr_amount_label:String
@export var debug_amount_label:String
@export var difficulty_base_amounts:Dictionary[int, int] = {}

var can_receive:bool = false
var max_count:int = 1
var current_count:int = 0:
	set(value):
		if can_receive and type != Enums.Objective_Type.NOTHING:
			current_count = value
			if current_count >= max_count:
				current_count = max_count
				can_receive = false
				Signals.UpdateRunState.emit(&"objective_complete")
			Signals.ObjectiveCountUpdated.emit(self)


func reset_objective() -> void:
	can_receive = false
	max_count = 1
	current_count = 0


func get_amount_for_difficulty(difficulty:int, level:int) -> int:
	if difficulty_base_amounts.has(difficulty):
		max_count = difficulty_base_amounts[difficulty] + _get_modifier_for_level(level)
		return max_count
	print("Difficulty %s not found in level objective %s." % [difficulty, id])
	return 1


func _get_modifier_for_level(_level:int) -> int:
	return 0
