class_name ActionBox extends TextureProgressBar


const DEFAULTICON:String = ""


@export var id:StringName

@onready var charges: Label = %charges

var starting_charges:int = 0

func _ready() -> void:
	Signals.ActionTimer.connect(_update_bar)
	Signals.ActionChargesUpdate.connect(_update_charge)


func setup_box(data:ActionData) -> void:
	id = data.id
	starting_charges = data.base_charges
	if data.uses_charges and data.base_charges > 1:
		charges.show()
		charges.text = str(data.base_charges)
	if data.icon_uid != "":
		texture_under = load(data.icon_uid) as CompressedTexture2D
	else:
		texture_under = load(Data.TEMPICON) as CompressedTexture2D
	texture_progress = load(Data.TEMPFILL) as CompressedTexture2D


func _update_bar(_id:StringName, current_time:float, max_time:float) -> void:
	if _id == id:
		value = current_time / max_time


func _update_charge(_id:StringName, _value:int) -> void:
	if _id == id:
		if not charges.visible and _value > starting_charges: show()
		charges.text = str(_value)
