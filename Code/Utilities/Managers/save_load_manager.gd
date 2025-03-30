class_name SaveLoadManager extends Node


const SAVEFOLDER:String = "user://saves/"
const SAVEFILEEXT:String = "tres"


var current_save:PlayerData = null
var all_saves:Array[PlayerData] = []


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Signals.SetCharacter.connect(_set_character)
	if _check_folder():
		all_saves = _load_save_files()
		if all_saves.is_empty():
			_create_save_file(&"test_file")
		else:
			_load_for_id(&"test_file")


func get_selected_character() -> StringName:
	return current_save.current_character


func _load_save_files() -> Array[PlayerData]:
	var saves:Array[PlayerData] = []
	var dir:DirAccess = DirAccess.open(SAVEFOLDER)
	var files:PackedStringArray = dir.get_files()
	for file in files:
		if file.get_extension() == SAVEFILEEXT:
			var temp:PlayerData = load(SAVEFOLDER+file) as PlayerData
			saves.append(temp)
	return saves


func _load_for_id(_id:StringName = "") -> void:
	for each in all_saves:
		if each.id == _id:
			current_save = each
			print("Save file ", _id, " loaded.")
			return
	print("No save file found for id ", _id)


func _save_all() -> void:
	for each in all_saves:
		if each.changes_pending:
			ResourceSaver.save(each)
			each.changes_pending = false


func _check_folder() -> bool:
	var dir:DirAccess = DirAccess.open(SAVEFOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(SAVEFOLDER)
		if result != OK:
			print_debug("Error creating save folder: ", result)
			return false
	return true


func _create_save_file(_id:StringName) -> void:
	if _id != &"":
		var new_save:PlayerData = PlayerData.new()
		new_save.id = _id
		var dir:DirAccess = DirAccess.open(SAVEFOLDER)
		if dir != null:
			var result = ResourceSaver.save(new_save, SAVEFOLDER + _id + "." + SAVEFILEEXT)
			if result != OK:
				print("Error saving new save file ", _id + "." + SAVEFILEEXT, " with error ", error_string(result))
				return
			current_save = new_save
			all_saves.append(new_save)
		else:
			print("Error opening save folder while creating save file.")


func _set_character(id:StringName) -> void:
	current_save.set_current_character(id)
