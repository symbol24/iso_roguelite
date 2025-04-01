class_name LootTable extends Resource


@export var id:StringName
@export var list:Dictionary[Resource, int] = {}


func get_loot(amount:int = 1) -> Array:
	var result:Array = []
	if list.is_empty():
		print("No loot found in %s." % id)
	else:
		var total:int = 0
		var loot:Dictionary[Resource, int] = {}
		
		for key in list.keys():
			total += list[key]
			loot[key] = total
		
		for i in amount:
			var rand:int = randi_range(0, total)
			var choice:Resource = _get_for_weight(loot, rand)
			result.append(choice)
		
	return result


func _get_for_weight(_dict:Dictionary[Resource, int], weight:int) -> Resource:
	for key in _dict.keys():
		if weight <= _dict[key]: return key
	return null
