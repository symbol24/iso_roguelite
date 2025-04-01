class_name PassiveUpgradeData extends RunUpgradeData


@export var variables:Dictionary[StringName, float] = {}
@export var max_of_variables:Dictionary[StringName, float] = {}
@export var stack_type:Enums.Stack_Type

var totals:Dictionary[StringName, float] = {}


func setup_totals() -> void:
	if stack_type == Enums.Stack_Type.LOGARITHMIC:
		for key in variables.keys():
			var max_val:float = max_of_variables[key] if max_of_variables.has(key) else Data.LOGVARMAX
			totals[key] = _log_sum_formula(count, variables[key], max_val)


func add_to_count() -> void:
	count += 1
	if stack_type == Enums.Stack_Type.LOGARITHMIC:
		for key in variables.keys():
			var max_val:float = max_of_variables[key] if max_of_variables.has(key) else Data.LOGVARMAX
			if totals.has(key):
				totals[key] += _log_sum_formula(count, variables[key], max_val)


func get_variable(variable:StringName) -> float:
	if variables.has(variable):
		if stack_type == Enums.Stack_Type.LINEAR:
			return variables[variable] * count
		elif stack_type == Enums.Stack_Type.LOGARITHMIC:
			return totals[variable]
	return 0.0


func get_next_value_level(variable:StringName) -> float:
	var max_val:float = max_of_variables[variable] if max_of_variables.has(variable) else Data.LOGVARMAX
	return _log_sum_formula(count+1, variables[variable], max_val)
