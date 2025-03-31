class_name PlayerData extends Resource


@export var id:StringName = ""
@export var unlocked_characters:Array[StringName] = []
@export var unlocked_actions:Array[StringName] = []
@export var meta_currency:int = 0

var changes_pending:bool = false
var current_difficulty:int = 0
var run_currency:int = 0

# Settings will go here


func update_unlocked_character(new_unlock:StringName) -> void:
	if unlocked_characters.has(new_unlock):
		print("Character already unloced.")
		return
		
	unlocked_characters.append(new_unlock)
	changes_pending = true
