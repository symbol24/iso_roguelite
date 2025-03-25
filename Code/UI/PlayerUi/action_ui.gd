class_name ActionBox extends TextureProgressBar


const DEFAULTICON:String = ""


@export var id:StringName


func _ready() -> void:
	Signals.ActionTimer.connect(_update_bar)
	max_value = 1.0
	step = 0.01
	fill_mode = FILL_CLOCKWISE


func _update_bar(_id:StringName, current_time:float, max_time:float) -> void:
	if _id == id:
		value = current_time / max_time
