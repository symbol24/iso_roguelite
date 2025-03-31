class_name LevelsToLoadData extends Resource


@export var levels:Dictionary[StringName, LevelData] = {}
@export var possible_random_levels:Array[StringName] = []


func get_scene_uid(scene_name:StringName) -> LevelData:
	if levels.has(scene_name):
		return levels[scene_name]
	
	print("No scene found with name: ", scene_name)
	return null


func get_random_level() -> StringName:
	if possible_random_levels.is_empty():
		print("Levels To Load Data does not contain any possible random levels.")
		return &" "
	
	return possible_random_levels.pick_random()
