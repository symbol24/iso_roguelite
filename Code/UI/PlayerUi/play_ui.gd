class_name PlayUi extends Control


const BOXSIZE:Vector2 = Vector2(20, 20)
const TEMPICON:String = "uid://cn5q8epuuj0g7"
const TEMPFILL:String = "uid://wlgi0bk4igll"


@onready var hp_bar: TextureProgressBar = %hp_bar
@onready var abilities_hbox: HBoxContainer = %abilities_hbox
@onready var exp_bar: TextureProgressBar = %exp_bar
@onready var shield_bar: TextureProgressBar = %shield_bar
@onready var armor_bar: TextureProgressBar = %armor_bar

var boxes:Array[ActionBox] = []
var character_id:StringName = &""


func _ready() -> void:
	Signals.HpUpdated.connect(_update_hp)
	Signals.ArmorUpdated.connect(_update_armor)
	Signals.ShieldUpdated.connect(_update_shield)


func set_player_ui(data:CharacterData) -> void:
	character_id = data.id
	var gamepad_buttons:Array[StringName] = [&"trigger_right", &"trigger_left", &"shoulder_right", &"shoulder_left"]
	for input in gamepad_buttons:
		var action:ActionData = _get_action_from_input(input, data.active_actions)
		if action == null:
			print(input, " is missing from active actions in ", data.id)
			continue
		var action_box:ActionBox = ActionBox.new()
		action_box.set_custom_minimum_size(BOXSIZE)
		abilities_hbox.add_child(action_box)
		if not action_box.is_node_ready(): await action_box.ready
		action_box.size = BOXSIZE
		action_box.id = action.id
		if action.icon_uid != "": 
			action_box.texture_under = load(action.icon_uid) as CompressedTexture2D
		else: 
			action_box.texture_under = load(TEMPICON) as CompressedTexture2D
		action_box.texture_progress = load(TEMPFILL) as CompressedTexture2D
		action_box.name = &"action_" + action.id
	
	_update_hp(data)
	_update_armor(data)
	_update_shield(data)


func _update_hp(data:CharacterData) -> void:
	if data.id == character_id:
		hp_bar.value = data.current_hp / data.max_hp


func _update_armor(data:CharacterData) -> void:
	if data.id == character_id:
		if data.max_armor > 0.0:
			armor_bar.show()
			print("Armor: ", data.current_armor)
			armor_bar.value = data.current_armor / data.max_armor
		else:
			armor_bar.hide()


func _update_shield(data:CharacterData) -> void:
	if data.id == character_id:
		if data.max_shield > 0.0:
			shield_bar.show()
			print("Shield: ", data.current_shield)
			shield_bar.value = data.current_shield / data.max_shield
		else:
			shield_bar.hide()


func _get_action_from_input(_input_name:StringName, _actions:Array[ActionData]) -> ActionData:
	for each in _actions:
		if each.input_name == _input_name:
			return each
	return null
