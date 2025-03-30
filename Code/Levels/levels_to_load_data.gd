class_name LevelsToLoadData extends Resource


@export var levels:Dictionary[StringName, LevelData] = {}


func get_scene_uid(scene_name:StringName) -> LevelData:
	if levels.has(scene_name):
		return levels[scene_name]
	
	print("No scene found wqith name: ", scene_name)
	return null
