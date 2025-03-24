class_name CharacterList extends Resource


@export var characters:Array[CharacterData] = []


func get_character_by_id(_id:StringName) -> CharacterData:
	for each in characters:
		if each.id == _id:
			return each
			
	print("No character with id %s found." % _id)
	return null
