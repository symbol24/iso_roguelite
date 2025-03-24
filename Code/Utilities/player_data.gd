class_name PlayerData extends Resource


@export var id:StringName = ""
@export var current_character:StringName = ""
@export var unlocked_characters:Array[StringName] = []
@export var unlocked_actions:Array[StringName] = []

var changes_pending:bool = false
var current_difficulty:int = 0

# Settings will go here


func set_current_character(_id:StringName) -> void:
	if current_character != _id:
		current_character = _id
		changes_pending = true


func update_unlocked_character(new_unlock:StringName) -> void:
	if unlocked_characters.has(new_unlock):
		print("Ship already unloced.")
		return
		
	unlocked_characters.append(new_unlock)
	changes_pending = true
