class_name RunUpgradeData extends Resource


@export var id:StringName
@export_category("UI STUFF")
@export var name_tr:String
@export var name_debug:String
@export var description_tr:String
@export var description_debug:String
@export var icon_uid:String
@export_category("Data")
@export var type:Enums.Upgrade_Type

var count:int = 1


func setup_totals() -> void:
	pass


func add_to_count() -> void:
	count += 1


func get_variable(_variable:StringName) -> float:
	return 0.0


func get_next_value_level(_variable:StringName) -> float:
	return 0.0


func _log_sum_formula(level:float, min_val:float, max_val:float) -> float:
	return min_val * pow(level, -(min_val/max_val))
