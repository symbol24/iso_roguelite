class_name LevelData extends Resource


@export var uid:String
@export var debug_name:String
@export var tr_name:String
@export var debug_description:String
@export var tr_description:String
@export var level_objectives:Array[LevelObjectiveData]
@export var level_boss_objective:LevelObjectiveData
@export var level_enemies:Array[EnemyData]


func get_random_level_objective(previous:StringName) -> LevelObjectiveData:
	var result:LevelObjectiveData = level_objectives.pick_random()
	while result.id == previous:
		result = level_objectives.pick_random()
	return result


func get_objective_from_id(id:StringName) -> LevelObjectiveData:
	for each in level_objectives:
		if each.id == id: return each
	return null
