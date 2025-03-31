class_name PlayUi extends Control


const BOXSIZE:Vector2 = Vector2(20, 20)
const TEMPICON:String = "uid://cn5q8epuuj0g7"
const TEMPFILL:String = "uid://wlgi0bk4igll"
const ACTIONBOX:PackedScene = preload("uid://dwkaxriwbkxdh")


# Player Info
@onready var hp_bar: TextureProgressBar = %hp_bar
@onready var abilities_hbox: HBoxContainer = %abilities_hbox
@onready var exp_bar: TextureProgressBar = %exp_bar
@onready var shield_bar: TextureProgressBar = %shield_bar
@onready var armor_bar: TextureProgressBar = %armor_bar
# Level Info
@onready var level_info: Control = %LevelInfo
@onready var level_name: Label = %level_name
@onready var level_description: Label = %level_description
# Objective Info
@onready var objective_info: PanelContainer = %ObjectiveInfo
@onready var obj_name: Label = %obj_name
@onready var obj_description: Label = %obj_description
@onready var obj_complete_count: Label = %obj_complete_count
# Objective Icons
@onready var objectives_layer: Control = %ObjectivesLayer


var boxes:Array[ActionBox] = []
var character_id:StringName = &""


func _ready() -> void:
	Signals.HpUpdated.connect(_update_hp)
	Signals.ArmorUpdated.connect(_update_armor)
	Signals.ShieldUpdated.connect(_update_shield)
	Signals.DisplayLevelIntro.connect(_display_level_intro)
	Signals.DisplayObjective.connect(_display_objective)
	Signals.ObjectiveCountUpdated.connect(_objective_count_updated)
	level_info.hide()
	objective_info.hide()


func set_player_ui(data:CharacterData) -> void:
	character_id = data.id
	var gamepad_buttons:Array[StringName] = [&"trigger_right", &"trigger_left", &"shoulder_right", &"shoulder_left"]
	for input in gamepad_buttons:
		var action:ActionData = _get_action_from_input(input, data.all_actions)
		if action == null:
			print(input, " is missing from active actions in ", data.id)
			continue
		var action_box:ActionBox = ACTIONBOX.instantiate()
		action_box.set_custom_minimum_size(BOXSIZE)
		abilities_hbox.add_child(action_box)
		if not action_box.is_node_ready(): await action_box.ready
		action_box.setup_box(action)
		action_box.name = &"action_" + action.id
	
	_update_hp(data)
	_update_armor(data)
	_update_shield(data)
	
	Signals.UpdateRunState.emit(&"play_ui_done")


func _update_hp(data:CharacterData) -> void:
	if data.id == character_id:
		hp_bar.value = data.current_hp / data.max_hp


func _update_armor(data:CharacterData) -> void:
	if data.id == character_id:
		if data.max_armor > 0.0:
			armor_bar.show()
			#print("Armor: ", data.current_armor)
			armor_bar.value = data.current_armor / data.max_armor
		else:
			armor_bar.hide()


func _update_shield(data:CharacterData) -> void:
	if data.id == character_id:
		if data.max_shield > 0.0:
			shield_bar.show()
			#print("Shield: ", data.current_shield)
			shield_bar.value = data.current_shield / data.max_shield
		else:
			shield_bar.hide()


func _get_action_from_input(_input_name:StringName, _actions:Array[ActionData]) -> ActionData:
	for each in _actions:
		if each.input_name == _input_name:
			return each
	return null


func _display_level_intro(level_data:LevelData) -> void:
	level_name.text = level_data.debug_name if tr(level_data.tr_name) == level_data.tr_name else tr(level_data.tr_name)
	level_description.text = level_data.debug_description if tr(level_data.tr_description) == level_data.tr_description else tr(level_data.tr_description)
	level_info.modulate = Color.TRANSPARENT
	level_info.show()
	var tween:Tween = create_tween()
	tween.tween_property(level_info, "modulate", Color.WHITE, Data.LEVELINFOTIME)
	await get_tree().create_timer(Data.LEVELINFOTIME).timeout
	tween = create_tween()
	tween.tween_property(level_info, "modulate", Color.TRANSPARENT, Data.LEVELINFOTIME)
	await tween.finished
	level_info.hide()
	Signals.UpdateRunState.emit(&"intro_displayed")


func _display_objective(obj_data:LevelObjectiveData) -> void:
	objective_info.modulate = Color.TRANSPARENT
	obj_name.text = obj_data.debug_name if tr(obj_data.tr_name) == obj_data.tr_name else tr(obj_data.tr_name)
	obj_description.text = obj_data.debug_description if tr(obj_data.tr_description) == obj_data.tr_description else tr(obj_data.tr_description)
	obj_complete_count.text = obj_data.debug_amount_label + " 0/" + str(obj_data.max_count) if tr(obj_data.tr_amount_label) == obj_data.tr_amount_label else tr(obj_data.tr_amount_label) + " 0/" + str(obj_data.max_count)
	objective_info.show()
	var tween:Tween = create_tween()
	tween.tween_property(objective_info, "modulate", Color.WHITE, Data.OBJINFOTIME)
	await tween.finished
	Signals.UpdateRunState.emit(&"objective_displayed")
	

func _objective_count_updated(obj_data:LevelObjectiveData) -> void:
	obj_complete_count.text = obj_data.debug_amount_label + " " + str(obj_data.current_count) + "/" + str(obj_data.max_count) if tr(obj_data.tr_amount_label) == obj_data.tr_amount_label else tr(obj_data.tr_amount_label) + " " + str(obj_data.current_count) + "/" + str(obj_data.max_count)
