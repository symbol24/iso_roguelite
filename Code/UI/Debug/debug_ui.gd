class_name DebugUi extends Control


@onready var character_info: RichTextLabel = %character_info

var active_info:Dictionary = {}


func _ready() -> void:
	Signals.DebugCharacterInfo.connect(_update_character_info)
	

func _update_character_info(info:StringName, value:String) -> void:
	if not active_info.has(info):
		active_info[info] = {"value" = value, "timer" = 0.0}
	else:
		active_info[info] = {"value" = value}
	
	character_info.text = ""
	
	for key in active_info.keys():
		character_info.text += key + ": " + active_info[key]["value"] + "\n"
	
